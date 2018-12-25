#
# Be sure to run `pod lib lint WLVoiceConverter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WLVoiceConverter'
  s.version          = '0.1.2'
  s.summary          = 'WLVoiceConverter'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A Voice Converter between AMR format and WAV format
                       DESC

  s.homepage         = 'https://github.com/Nomeqc/WLVoiceConverter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nomeqc' => 'nomeqc@gmail.com' }
  s.source           = { :git => 'https://github.com/Nomeqc/WLVoiceConverter.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.public_header_files = 'WLVoiceConverter/Classes/*.h'
  s.source_files = 'WLVoiceConverter/Classes/**/*'
  s.vendored_libraries = 'WLVoiceConverter/Classes/**/*.a'
  s.xcconfig = {
      'VALID_ARCHS' =>  'arm64 x86_64'
  }
  s.compiler_flags = '-fembed-bitcode'
  s.library = 'c++'
  
end
