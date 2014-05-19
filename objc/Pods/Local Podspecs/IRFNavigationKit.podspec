Pod::Spec.new do |s|
  s.name         = "IRFNavigationKit"
  s.version      = "0.1.0"
  s.summary      = "iOS like navigation through view controller brought to the mac."
  s.homepage     = "https://github.com/irrationalfab/IRFNavigationKit"
  s.license      = 'MIT'
  s.author       = { "Fabio Pelosin" => "fabiopelosin@gmail.com" }
  s.source       = { :git => "https://github.com/irrationalfab/IRFNavigationKit.git", :tag => s.version.to_s }

  s.platform     = :osx, '10.8'
  s.requires_arc = true

  s.source_files = 'Classes/**/*'
  # s.dependency 'JSONKit', '~> 1.4'
end
