platform :ios, '13.0'
source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!

install! 'cocoapods', :disable_input_output_paths => true

target 'YCT' do
  use_frameworks!

  # Your pods
  pod 'ZaloSDK'
  pod 'AMapLocation-NO-IDFA'
  pod 'ReactiveObjC'
  pod 'MMKV'
  pod 'YYModel'
  pod 'DGCharts'
  pod 'JXCategoryView'
  pod 'JXPagingView/Pager'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'YTKNetwork', '~> 3.0.6'
  pod 'SDWebImage', '~> 5.12.1'
  pod 'MJRefresh', '~> 3.7.2'
  pod 'GKPhotoBrowser', '~> 2.2.1'
  pod 'IQKeyboardManager', '~> 6.5.9'
  pod 'MJExtension', '~> 3.0.13'
  pod 'Masonry', '~> 1.1.0'
  pod 'iCarousel', '~> 1.8.3'
  pod 'LEEAlert'
  pod 'FLEX', '~> 4.1.1', :configurations => ['Debug']
  pod 'SJVideoPlayer'
  pod 'LBXScan/LBXZXing', '~> 2.5'
  pod 'LBXScan/UI', '~> 2.5'
  pod 'TOCropViewController'
  pod 'JPImageresizerView', '~> 1.9.4'
  pod 'JPBasic/JPConst'
  pod 'JPBasic/JPProgressHUD'
  pod 'TZImagePickerController', '~> 3.6.8'
  pod 'QCloudCOSXML'
  pod 'FBSDKCoreKit'
  pod 'FBSDKShareKit'
  pod 'FBSDKLoginKit'
  pod 'GoogleSignIn'
  pod 'SendbirdLiveSDK', '= 1.2.5'
  pod 'ZLPhotoBrowser'
  pod 'SnapKit'
  pod 'FloatingPanel'
  pod 'Alamofire'
  pod 'FirebaseAnalytics'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'Firebase/Crashlytics'
  pod 'AlipaySDK-iOS'
  pod 'JCore', '3.2.3'
  pod 'JPush', '4.8.0'
  pod 'LineSDKSwift/ObjC', '~> 5.0'
  pod 'gRPC-ProtoRPC'
  #测试下
end

#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    target.build_configurations.each do |config|
#      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
#      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
#    end
#  end
#end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
  end
end

#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    target.build_configurations.each do |config|
#      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = "9.0"
#     end
#  end
#end
