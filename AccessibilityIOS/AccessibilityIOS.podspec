#
# Be sure to run `pod lib lint AccessibilityIOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AccessibilityIOS'
  s.version          = '0.1.0'
  s.summary          = 'AccessibilityIOS is a visually impaired tool'
  s.homepage         = 'https://github.com/haleli/AccessibilityIOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'haleli' => 'haleli@tencent.com' }
  s.social_media_url    = "https://github.com/haleli/AccessibilityIOS"
  s.platform            = :ios, "9.0"
  s.source           = { :git => 'https://github.com/haleli/AccessibilityIOS.git', :tag => s.version.to_s }
  s.requires_arc        = true
 
 
  s.source_files = 'AccessibilityIOS/Classes/**/*'
  s.public_header_files = "Core/**/*.h"
  s.source_files      = "Core/**/*.{h,m,mm,mlmodel}"
end
