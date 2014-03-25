require 'xcodeproj'
require 'colored'

class XCPorjectMapper

  attr_accessor :dry_run

  def initialize(dry_run = false)
    @dry_run = dry_run
  end

  attr_accessor :all_references
  attr_accessor :used_referneces
  attr_accessor :proj

  # @return [void]
  #
  def map_project
    @proj = Xcodeproj::Project.open('Confab App.xcodeproj')
    @all_references = proj.main_group.recursive_children
    @used_referneces = []

    match_targets
    proj.sort(:groups_position => :below)
    move_special_groups

    unless dry_run
      proj.save
    end
  end

  #---------------------------------------------------------------------------#

  def match_targets
    proj.targets.sort_by(&:name).each do |target|
      target_dir = Pathname.pwd + target.name
      if target_dir.exist?
        map_dir(target_dir, proj.main_group, target)
      end
      clean_target_build_files(target)
    end
  end

  def clean_target_build_files(target)
    if target.isa == 'PBXNativeTarget'
      target.source_build_phase.files.each do |bf|
        unless bf.file_ref && bf.file_ref.referrers != [bf]

          p bf.file_ref
          bf.remove_from_project
        end
      end
    end
  end

  def move_special_groups
    proj.frameworks_group.move(proj.main_group)
    proj.products_group.move(proj.main_group)
  end

  # @return [Xcodeproj::PBXGroup, Xcodeproj::PBXFileReference]
  #
  def find_ref(path, parent_group)
    ref = parent_group.children.find { |child| child.real_path == path }
    if ref
      used_referneces << ref
      ref.set_path(path)
    end
    ref
  end

  # @return [Xcodeproj::PBXGroup]
  #
  def map_dir(path, parent_group, target)
    group = find_ref(path, parent_group)
    unless group
      output('Creating', :green, 'group', path)
      group = parent_group.new_group(path.basename.to_s, path.to_s)
    end

    raise "#{p group} with path `#{group.path}` for path `#{path}` expected to be a group" unless group.isa == 'PBXGroup' || group.isa == 'XCVersionGroup'

    found_refs = []
    path.children.sort.each do |child_path|
      next if child_path.basename.to_s == '.DS_Store'
      next if child_path.extname.to_s == '.lproj'

      has_group = child_path.directory? && child_path.extname != '.xcdatamodeld' && child_path.extname != '.xcassets'
      if has_group
        found_refs << map_dir(child_path, group, target)
      else
        child_file_ref = find_ref(child_path, group)
        unless child_file_ref
          output('Creating', :green, 'file', child_path)
          child_file_ref = group.new_file(child_path)
          add_file_to_target(child_file_ref, target)
        end
        found_refs << child_file_ref
      end
    end

    clean_unused_refs(group, found_refs)
    group
  end

  def add_file_to_target(ref, target)
    if ['.h', '.m'].include?(ref.real_path.extname)
      target.add_file_references([ref])
    else
      target.add_resources([ref])
    end
  end

  def clean_unused_refs(group, found_refs)
    unrecognized = group.children - found_refs
    unrecognized.reject! do |ref|
      ref.parent == proj.main_group ||
        ref == proj.frameworks_group ||
        ref == proj.products_group ||
        ref.parents.include?(proj.frameworks_group) ||
        ref.parents.include?(proj.products_group) ||
        # TODO
        ref.isa == 'PBXVariantGroup' ||
        ref.real_path.to_s.include?('.xcdatamodeld/') ||
        ref.real_path.to_s.include?('.lproj/')
    end

    unrecognized.each do |ref|
      unless ref.referrers.count.zero?
        output('Deleting', :red, '', ref.real_path)
        remove_ref(ref)
      end
    end
  end

  def remove_ref(ref)
    ref.referrers.each do |referrer|
      if referrer.isa == 'PBXBuildFile'
        referrer.remove_from_project
      elsif ref.isa == 'PBXGroup'
        ref.children.each do |child_ref|
          remove_ref(child_ref)
        end
      end
    end
    ref.remove_from_project
  end

  #---------------------------------------------------------------------------#

  # @return [void]
  #
  def output(colored, color, rest, path)
    colored = colored.send(color)
    just_part = "#{colored.ljust(18)} #{rest.ljust(6)}"
    puts "#{just_part} `#{path.relative_path_from(Pathname.pwd)}`"
  end

  #---------------------------------------------------------------------------#

end

dry_run = false
mapper = XCPorjectMapper.new(dry_run)
mapper.map_project
