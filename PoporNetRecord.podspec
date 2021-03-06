#
# Be sure to run `pod lib lint PoporNetRecord.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name     = 'PoporNetRecord'
  s.version  = '1.18'
  s.summary  = 'PoporNetRecord will record net request only in debug configuration'
  
  s.homepage = 'https://github.com/popor/PoporNetRecord'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.author   = { 'popor' => '908891024@qq.com' }
  s.source   = { :git => 'https://github.com/popor/PoporNetRecord.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '8.0'
  s.frameworks = 'UIKit', 'Foundation'
  
  s.subspec 'Entity' do |ss|
    ss.source_files = 'Example/Classes/Entity/*.{h,m}'
  end
  
  s.subspec 'Web' do |ss|
    ss.dependency 'PoporNetRecord/Entity'
    ss.source_files = 'Example/Classes/Web/*.{h,m}'
  end
  
  s.subspec 'MessageVC' do |ss|
    ss.dependency 'PoporNetRecord/Entity'
    ss.source_files = 'Example/Classes/MessageVC/*.{h,m}'
  end
  
  s.subspec 'DetailVC' do |ss|
    ss.dependency 'PoporNetRecord/Entity'
    ss.source_files = 'Example/Classes/DetailVC/*.{h,m}'
  end
  
  s.subspec 'ExtraVC' do |ss|
    ss.dependency 'PoporNetRecord/Entity'
    ss.source_files = 'Example/Classes/ExtraVC/*.{h,m}'
  end
  
  s.subspec 'ListVC' do |ss|
    ss.dependency 'PoporNetRecord/Web'
    ss.dependency 'PoporNetRecord/DetailVC'
    ss.dependency 'PoporNetRecord/ExtraVC'
    ss.dependency 'PoporNetRecord/MessageVC'
    
    ss.source_files = 'Example/Classes/ListVC/*.{h,m}'
  end
  
  s.subspec 'Record' do |ss|
    ss.dependency 'PoporNetRecord/ListVC'
    ss.source_files = 'Example/Classes/Record/*.{h,m}'
  end
  
  s.dependency 'Masonry'
  
  s.dependency 'PoporUI/UIDevice'
  s.dependency 'PoporUI/IToast'
  s.dependency 'PoporUI/UIView'
  s.dependency 'PoporUI/UIImage'
  s.dependency 'PoporUI/UITextField'
  
  s.dependency 'PoporFoundation/NSDictionary'
  s.dependency 'PoporFoundation/NSString'
  s.dependency 'PoporFoundation/NSDate'
  
  s.dependency 'PoporAlertBubbleView'
  
  s.dependency 'JSONSyntaxHighlight'
  
  s.dependency 'GCDWebServer'
  s.dependency 'GCDWebServer/WebUploader'
  s.dependency 'GCDWebServer/WebDAV'
  
end
