#
# Be sure to run `pod lib lint ZZNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZZNetworking'
  s.version          = '0.1.0'
  s.summary          = 'A Networking Framework for RESTful API, in RxSwift'
  
  s.description      = 'A Networking Framework for RESTful API, in RxSwift. Provides model that can easily do GET | POST | PUT | DELETE with a RESTful API.'

  s.homepage         = 'https://github.com/LittleChuan/ZZNetworking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Zaza' => 'little.chuan@qq.com' }
  s.source           = { :git => 'https://github.com/LittleChuan/ZZNetworking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.0', '5.0'

  s.source_files = 'ZZNetworking/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ZZNetworking' => ['ZZNetworking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire', '~> 4.9.0'
  s.dependency 'RxSwift', '~> 5.0.0'
  s.dependency 'RxCocoa', '~> 5.0.0'
end
