Pod::Spec.new do |s|
  s.name = 'AntavoLoyaltySDK'
  s.version = '1.0.1'
  s.license = 'MIT'
  s.summary = 'The Antavo Loyalty Swift SDK makes it easy for mobile developers to build Antavo-powered applications.'
  s.homepage = 'https://github.com/qzephyrmor/antavo-sdk-swift'
  s.authors = { 'qzephyrmor' => 'qzephyrmor@gmail.com' }
  s.source = { :git => 'https://github.com/qzephyrmor/antavo-sdk-swift.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'AntavoLoyaltySDK/Classes/*.swift'
  s.dependency 'Alamofire', '~> 4.4'
end
