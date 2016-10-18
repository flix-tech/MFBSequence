#
# Be sure to run `pod lib lint MFBSequence.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MFBSequence'
  s.version          = '0.1.0'
  s.summary          = 'Simple non-concurrent non-blocking queue for Objective-C'

  s.description      = <<-DESC
MFBSequence provides execution of multiple steps sequentially without blocking current queue/thread.
                       DESC

  s.homepage         = 'https://github.com/flix-tech/MFBSequence'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nickolay Tarbayev' => 'tarbayev-n@yandex.ru' }
  s.source           = { :git => 'https://github.com/flix-tech/MFBSequence.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'Sources/**/*.{h,m}'
end
