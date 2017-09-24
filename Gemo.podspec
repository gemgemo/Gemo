
Pod::Spec.new do |s|
  s.name             = 'Gemo'
  s.version          = '0.1.7'
  s.summary          = 'my first library'


  s.description      = <<-DESC
my first library, use to make my work easy
                       DESC

  s.homepage         = 'https://github.com/gemgemo/Gemo'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gamal' => 'gamalgemfox@gmail.com' }
  s.source           = { :git => 'https://github.com/gemgemo/Gemo.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Gemo/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Gemo' => ['Gemo/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
