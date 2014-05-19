Pod::Spec.new do |s|
  s.name         = "IFBKCampground"
  s.version      = "0.1.0"
  s.summary      = "Provides support to interface with with 37Signal's Campfire service."
  s.homepage     = "https://github.com/irrationalfab/Marshmallow"
  s.license      = 'MIT'
  s.author       = { "Fabio Pelosin" => "fabiopelosin@gmail.com" }
  s.source       = { :git => "https://github.com/irrationalfab/Marshmallow.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.ios.deployment_target = '6.1'
  s.osx.deployment_target = '10.8'

  s.source_files = 'Classes'
  s.dependency 'IFBKThirtySeven'

  s.subspec 'Authorization' do |sp|
    sp.source_files = 'Classes/Authorization'
  end

  s.subspec 'Accounts' do |sp|
    sp.source_files = 'Classes/Accounts'
  end

  s.subspec 'Rooms' do |sp|
    sp.source_files = 'Classes/Rooms'
    sp.dependency 'twitter-text-objc'
    sp.dependency 'IRFEmojiCheatSheet'
  end
end
