#
# Be sure to run `pod lib lint FirebaseRxSwiftExtensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FirebaseRxSwiftExtensions"
  s.version          = "3.0.0"
  s.summary          = "Untangle your messy Firebase code with RxSwift Extension Methods"

  s.description      = "Firebase is a block or closure based API, unfortunately doing anything robust will take a lot of nesting.
 This makes your code get out of hand very fast. RxSwift 2.5 or higher is required. Swift 2 and XCode 7.1 are required."

  s.homepage         = "https://github.com/RxSwiftCommunity/FirebaseRxSwiftExtensions.git"
  s.license          = 'MIT'
  s.author           = { "Maximilian Alexander" => "mbalex99@gmail.com" }
  s.source           = { :git => "https://github.com/RxSwiftCommunity/FirebaseRxSwiftExtensions.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/maxofeden'

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.platform = :ios, '8.0'

  s.dependency 'RxSwift', '~> 4'
  s.dependency 'Firebase/Database'
  s.dependency 'Firebase/Auth'
  s.dependency 'Firebase/Analytics'
  s.dependency 'Firebase/RemoteConfig'
  s.dependency 'Firebase/Storage'

  s.cocoapods_version = '>= 1.4.0'
  s.swift_version = '4.0'
  s.static_framework = true
end
