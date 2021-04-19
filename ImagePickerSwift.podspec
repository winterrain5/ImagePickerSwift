
Pod::Spec.new do |s|
  s.name             = 'ImagePickerSwift'
  s.version          = '0.2.0'
  s.summary          = 'ImagePickerSwift is a simple & easy-to-use image picker designed to present both camera and photo library options and get the UIImage easily.'

  s.description      = <<-DESC
ImagePickerSwift is a basically a wrapper for `UIImagePickerController` that allows to pick image in a easy way. It is designed to present both camera and photo library options and get the UIImage easily.
                       DESC

  s.homepage         = 'https://github.com/winterrain5/ImagePickerSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'winterrain5' => '913419042@qq.com' }
  s.source           = { :git => 'https://github.com/winterrain5/ImagePickerSwift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_versions = ['4.1', '4.2', '5.0', '5.1', '5.2', '5.3']
  s.source_files = 'ImagePickerSwift/Classes/**/*'
  
 
end
