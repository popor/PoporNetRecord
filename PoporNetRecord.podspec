#
# Be sure to run `pod lib lint PoporNetRecord.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'PoporNetRecord'
    s.version          = '0.0.11'
    s.summary          = 'PoporNetRecord will record net request only in debug configuration'
    
    s.homepage         = 'https://github.com/popor/PoporNetRecord'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'popor' => '908891024@qq.com' }
    s.source           = { :git => 'https://github.com/popor/PoporNetRecord.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '8.0'
    
    s.frameworks = 'UIKit', 'Foundation'
    
    s.subspec 'entity' do |ss|
        ss.source_files = 'PoporNetRecord/Classes/entity/*.{h,m}'
    end
    
    s.subspec 'ListVC' do |ss|
        ss.dependency 'PoporNetRecord/entity'
        ss.dependency 'PoporNetRecord/DetailVC'
        
        ss.source_files = 'PoporNetRecord/Classes/ListVC/*.{h,m}'
    end
    
    s.subspec 'DetailVC' do |ss|
        ss.source_files = 'PoporNetRecord/Classes/DetailVC/*.{h,m}'
        
    end
    
    s.dependency 'Masonry'
    
    s.dependency 'PoporUI/IToast'
    s.dependency 'PoporUI/UIView'
    
    s.dependency 'PoporFoundation/NSDictionary'
    s.dependency 'PoporFoundation/NSString'
    s.dependency 'PoporFoundation/NSDate'
    
end
