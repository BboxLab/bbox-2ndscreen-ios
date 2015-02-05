Pod::Spec.new do |s|
  s.name               = "BboxSecondScreen"
  s.version            = '0.2.2'
  s.summary            = 'A SecondScreen library for the Bbox'
  s.platform           = :ios
  s.ios.deployment_target = "7.0"
  s.homepage           = 'http://dev.bouyguestelecom.fr'
  s.authors            = 'Bouygues Telecom | BboxLab'
  s.license            = 'MIT'
  s.source             = { :git => 'https://github.com/BboxLab/bbox-2ndscreen-ios.git', :tag => '0.2.2' }
  s.source_files       = 'BboxSecondScreen/*.{h,m,c}'
  s.requires_arc       = true
  s.dependency 'SocketRocket'
  s.dependency 'AFNetworking', "~> 2.0"
  s.requires_arc       = true
end