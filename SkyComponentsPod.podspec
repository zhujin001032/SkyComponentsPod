#
# Be sure to run `pod lib lint SkyComponentsPod.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SkyComponentsPod"
  s.version          = "0.1.1"
  s.summary          = "A short description of SkyComponentsPod."
  s.description      = <<-DESC
                       An optional longer description of SkyComponentsPod

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/zhujin001032/SkyComponentsPod"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Jason.He" => "zhujin001xb@163.com" }
  s.source           = { :git => "https://github.com/zhujin001032/SkyComponentsPod.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SkyComponentsPod' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # Need for HTTP Component, add by Mark 2015-11-19
  s.dependency 'AFNetworking', '~> 2.3'
  # URL: https://github.com/mwaterfall/MWPhotoBrowser, Add by Mark 2016-03-17
  s.dependency 'MWPhotoBrowser', '~> 2.1.1'
  # Add auto layout
  s.dependency 'Masonry', '~> 0.6.3'
  # for 读取相册二维码
  s.dependency 'ZXingObjC', '~> 3.0'
end
