#
# Be sure to run `pod lib lint GTMotionTransitioning.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GTMotionTransitioning'
  s.version          = '0.0.1'
  s.summary          = '场景切换轻量化工具'
  s.homepage         = 'https://github.com/liuxc123/GTMotionTransitioning'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuxc123' => 'lxc_work@126.com' }
  s.source           = { :git => 'https://github.com/liuxc123/GTMotionTransitioning.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.public_header_files = "src/*.h"
  s.source_files = "src/*.{h,m,mm}", "src/private/*.{h,m,mm}"
end
