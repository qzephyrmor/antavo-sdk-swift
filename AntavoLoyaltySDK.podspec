#
# Be sure to run `pod lib lint AntavoLoyaltySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AntavoLoyaltySDK'
  s.version          = '0.1.0'
  s.summary          = 'The Antavo Loyalty Swift SDK makes it easy for mobile developers to build Antavo-powered applications.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
The Antavo Loyalty Swift SDK makes it easy for mobile developers to build Antavo-powered applications. With the Swift SDK you can leverage the power of Antavo API functionality
                       DESC

  s.homepage         = 'https://github.com/qzephyrmor/antavo-sdk-swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qzephyrmor' => 'qzephyrmor@gmail.com' }
  s.source           = { :git => 'https://github.com/qzephyrmor/antavo-sdk-swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AntavoLoyaltySDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AntavoLoyaltySDK' => ['AntavoLoyaltySDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire', '~> 4.4'
end
