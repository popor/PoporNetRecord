#
# Be sure to run `pod lib lint PoporNetRecord.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name     = 'PoporNetRecord'
    s.version  = '0.1.00'
    s.summary  = 'PoporNetRecord will record net request only in debug configuration'

    s.homepage = 'https://github.com/popor/PoporNetRecord'
    s.license  = { :type => 'MIT', :file => 'LICENSE' }
    s.author   = { 'popor' => '908891024@qq.com' }
    s.source   = { :git => 'https://github.com/popor/PoporNetRecord.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '8.0'
    
    s.frameworks = 'UIKit', 'Foundation'
    
    # 基础1
    s.subspec 'entity' do |ss|
        ss.source_files = 'PoporNetRecord/Classes/entity/*.{h,m}'
    end
    
    # 基础2
    s.subspec 'WebVC' do |ss|
      ss.dependency 'PoporNetRecord/entity'
      
      ss.dependency 'PoporFoundation/NSString'
      ss.dependency 'PoporFoundation/PrefixCore'
      ss.dependency 'PoporUI/Tool'
      ss.dependency 'PoporQRCodeIos'
      
      ss.source_files = 'PoporNetRecord/Classes/WebVC/*.{h,m}'
    end
    
    s.subspec 'DetailVC' do |ss|
      ss.dependency 'PoporNetRecord/entity'
      ss.dependency 'PoporNetRecord/WebVC'
      
      ss.source_files = 'PoporNetRecord/Classes/DetailVC/*.{h,m}'
    end
    
    s.subspec 'ListVC' do |ss|
        ss.dependency 'PoporNetRecord/entity'
        ss.dependency 'PoporNetRecord/DetailVC'
        ss.dependency 'PoporNetRecord/WebVC'
        
        ss.dependency 'PoporAlertBubbleView'
        
        ss.source_files = 'PoporNetRecord/Classes/ListVC/*.{h,m}'
    end
    
    s.dependency 'Masonry'
    
    s.dependency 'PoporUI/IToast'
    s.dependency 'PoporUI/UIView'
    s.dependency 'PoporUI/UIImage'
    s.dependency 'PoporUI/UITextField'
    s.dependency 'PoporUI/UINavigationController'
    
    s.dependency 'PoporFoundation/NSDictionary'
    s.dependency 'PoporFoundation/NSString'
    s.dependency 'PoporFoundation/NSDate'
    
    s.dependency 'JSONSyntaxHighlight'
    
    s.dependency 'GCDWebServer'
    s.dependency 'GCDWebServer/WebUploader'
    s.dependency 'GCDWebServer/WebDAV'
    
end
