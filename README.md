# ImagePickerSwift

[![CI Status](https://img.shields.io/travis/winterrain5/ImagePickerSwift.svg?style=flat)](https://travis-ci.org/winterrain5/ImagePickerSwift)
[![Version](https://img.shields.io/cocoapods/v/ImagePickerSwift.svg?style=flat)](https://cocoapods.org/pods/ImagePickerSwift)
[![License](https://img.shields.io/cocoapods/l/ImagePickerSwift.svg?style=flat)](https://cocoapods.org/pods/ImagePickerSwift)
[![Platform](https://img.shields.io/cocoapods/p/ImagePickerSwift.svg?style=flat)](https://cocoapods.org/pods/ImagePickerSwift)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Useage

#### 选择照片
```
ImagePicker.show(type: .selectPhoto, with: .default) { (image, url) in
    self.imageView.image = image
}
```
#### 选择视频
```
ImagePicker.show(type:.selectVideo, with: .default) { (image, url) in
    self.imageView.image = image
    self.videoUrl = url
}
```
#### 选择视频和图片
```
ImagePicker.show(type:.selectePhotoAndVideo, with: .default) { (image, url) in
    self.imageView.image = image
    self.videoUrl = url
}
```
#### 拍照
```
let options = ImagePickerOptions()
options.cameraDevice = .front
ImagePicker.show(type:.takePhoto, with: .default) { (image, url) in
    self.imageView.image = image
    self.videoUrl = url
}
```
#### 录制视频
```
ImagePicker.show(type:.recordVideo, with: .default) { (image, url) in
    self.imageView.image = image
    self.videoUrl = url
}
```

## Requirements

## Installation

ImagePickerSwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ImagePickerSwift'
```

## Author

winterrain5, 913419042@qq.com

## License

ImagePickerSwift is available under the MIT license. See the LICENSE file for more info.
