platform :ios, '9.0'
swift_version = '3.0'

target 'BackgroundGradationScroll' do
  use_frameworks!
  pod 'SVProgressHUD', :git => 'https://github.com/SVProgressHUD/SVProgressHUD.git'
  pod 'AlamofireImage'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'RealmSwift'
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end
