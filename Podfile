


source 'git@github.com:CocoaPods/Specs.git'

def general_pods
   
    pod 'Masonry' # 自动布局
  
    pod 'YYWebImage'
    pod 'YYText'  
    pod 'YYModel'
    pod 'YYImage/WebP'


    # Vendor


    pod 'UMengAnalytics-NO-IDFA' # 友盟 SDK（无 IDFA）
#    pod 'Pingpp/Alipay'
#    pod 'Pingpp/QQWallet'

    pod "DKNightVersion"
    pod 'UICollectionView-QLX', '~> 1.1.0'
    pod  'SSZipArchive'
    
    pod 'AFNetworking'
    pod 'WeexSDK', :path=>'./sdk/'
    pod 'SDWebImage'
    
    pod "QLXNavigationController" #导航栏
    pod 'GBDeviceInfo' #设备信息

    pod 'UMengUShare/Social/WeChat'

    pod 'UMengUShare/Social/QQ'

    pod 'UMengUShare/Social/Sina'
    
    pod 'BlocksKit'
    #友盟统计
    pod 'UMengAnalytics-NO-IDFA'
    pod 'TZImagePickerController' # 图片选择框架



end

def debug_pods
    # Debug
    pod 'FLEX'
    pod 'Reveal-iOS-SDK'
    pod "PLeakSniffer"
end

target 'WhiteWhale' do
    general_pods
end

target 'WhiteWhale Development' do
    general_pods
    debug_pods
end


plugin 'cocoapods-prune-localizations', {:localizations => ["en", "zh-Hans"]}
