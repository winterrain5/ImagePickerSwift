import UIKit
import AVFoundation
import Photos
import PhotosUI

open class ImagePicker:NSObject{
    
    private static let `default` = ImagePicker()
    
    public typealias CompleteClosure = ((UIImage?, String?) -> Void)?
    
    private lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.modalPresentationStyle = .overCurrentContext
        
        if #available(iOS 11.0, *) {
            picker.videoExportPreset = AVAssetExportPresetPassthrough
            picker.imageExportPreset = .compatible
        }
        return picker
    }()
    
    override private init() {
        super.init()
        picker.delegate = self
    }
    
    private var options: ImagePickerOptions = ImagePickerOptions()
    private var getImage: ((UIImage?, String?) -> Void)!
    
    private var presentController : UIViewController {
        return (options.presentController ?? rootViewController)
    }
    
    private var rootViewController: UIViewController {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("ImagePicker - Application key window not found. Please check UIWindow in AppDelegate.")
        }
        return root
    }
    
    
    /// 调起相册或者相机
    /// - Parameters:
    ///   - type: 操作类型
    ///   - options: 配置
    ///   - completion: 回调
    public static func show(type:PickerType,with options:ImagePickerOptions,_ completion: CompleteClosure) {
        switch type {
        case .recordVideo:
            ImagePicker.default.recordVideo(with: options, completion)
        case .selectVideo:
            ImagePicker.default.selectVideo(with: options, completion)
        case .selectPhoto:
            ImagePicker.default.selectPhoto(with: options, completion)
        case .takePhoto:
            ImagePicker.default.takePhoto(with: options, completion)
        case .selectePhotoAndVideo:
            ImagePicker.default.selectePhotoAndVideo(with: options, completion)
        }
    }

    
    /// 录制视频
    /// - Parameters:
    ///   - options: 配置类
    ///   - completion: 回调
    private func recordVideo(with options:ImagePickerOptions , _ completion: CompleteClosure) {
        self.options = options
        
        /// 是否有访问相机权限
        let avAuthor: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if avAuthor == .restricted || avAuthor == .denied {
            showNoAuthorizationAlert("相机权限未开启,请在设置中启用")
            return
        }
        
        /// 是否有访问相机权限
        let author: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if author == .restricted || author == .denied {
            showNoAuthorizationAlert("相机权限未开启,请在设置中启用")
            return
        }
        
        /// 是否有访问麦克风权限
        let microStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        if microStatus == .restricted || microStatus == .denied {
            showNoAuthorizationAlert("麦克风权限未开启,请在设置中启用")
            return
        }
        
        picker.sourceType = .camera
        picker.allowsEditing = options.allowsEditing
        picker.mediaTypes = MediaType.video.MediaTypes
        picker.cameraCaptureMode = .video
        picker.cameraDevice = options.cameraDevice
        
        presentController.present(picker, animated: true, completion: nil)
        
        self.getImage = { image, url in
            completion?(image, url)
        }
    }
    
    
    /// 从相册中选择视频
    /// - Parameters:
    ///   - options: 配置类
    ///   - completion: 回调
    private func selectVideo(with options:ImagePickerOptions , _ completion: CompleteClosure) {
        self.options = options
        
        /// 是否有访问相册权限
        let phAuthor: PHAuthorizationStatus = PHAuthorizationStatus.authorized
        if phAuthor == .restricted || phAuthor == .denied {
            showNoAuthorizationAlert("相册权限未开启,请在设置中启用")
            return
        }
        
        picker.sourceType = .photoLibrary
        picker.mediaTypes = MediaType.video.MediaTypes
        picker.allowsEditing = options.allowsEditing
        picker.videoMaximumDuration = options.videoMaximumDuration
        picker.videoQuality = options.videoQuality
        
        presentController.present(picker, animated: true, completion: nil)
        
        self.getImage = { image, url in
            completion?(image, url)
        }
    }
    
    
    /// 拍照
    /// - Parameters:
    ///   - options: 配置类
    ///   - completion: 回调
    private func takePhoto(with options:ImagePickerOptions , _ completion: CompleteClosure) {
        self.options = options
        
        /// 是否有访问相机权限
        let avAuthor: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if avAuthor == .restricted || avAuthor == .denied {
            showNoAuthorizationAlert("相机权限未开启,请在设置中启用")
            return
        }
        
        /// 是否有访问相册权限
        let phAuthor: PHAuthorizationStatus = PHAuthorizationStatus.authorized
        if phAuthor == .restricted || phAuthor == .denied {
            showNoAuthorizationAlert("相册权限未开启,请在设置中启用")
            return
        }
        
        picker.sourceType = .camera
        picker.allowsEditing = options.allowsEditing
        picker.mediaTypes = MediaType.image.MediaTypes
        picker.cameraCaptureMode = .photo
        picker.cameraDevice = options.cameraDevice
        
        presentController.present(picker, animated: true, completion: nil)
        
        self.getImage = { image, url in
            completion?(image, url)
        }
    }
    
    
    /// 从相册选择图片
    /// - Parameters:
    ///   - options: 配置类
    ///   - completion: 回调
    private func selectPhoto(with options:ImagePickerOptions, _ completion: CompleteClosure) {
        self.options = options
        
        /// 是否有访问相册权限
        let author: PHAuthorizationStatus = PHAuthorizationStatus.authorized
        if author == .restricted || author == .denied {
            showNoAuthorizationAlert("相册权限未开启,请在设置中启用")
            return
        }
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = options.allowsEditing
        picker.mediaTypes = MediaType.image.MediaTypes
        
        presentController.present(picker, animated: true, completion: nil)
        
        self.getImage = { image, url in
            completion?(image, url)
        }
    }
    
    
    /// 从相册选择图片或者视频
    /// - Parameters:
    ///   - options: 配置类
    ///   - completion: 回调
    private func selectePhotoAndVideo(with options:ImagePickerOptions, _ completion: CompleteClosure) {
        self.options = options
        
        /// 是否有访问相册权限
        let author: PHAuthorizationStatus = PHAuthorizationStatus.authorized
        if author == .restricted || author == .denied {
            showNoAuthorizationAlert("相册权限未开启,请在设置中启用")
            return
        }
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = options.allowsEditing
        picker.mediaTypes = MediaType.all.MediaTypes
        
        presentController.present(picker, animated: true, completion: nil)
        
        self.getImage = { image, url in
            completion?(image, url)
        }
    }
}

extension ImagePicker {
    
    private func getVideoThumbnail(_ url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: url , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch let error {
            print("ImagePicker - Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func editImage(_ img: UIImage?, path: String?) {
        var image = img
        if let imgg = image {
            if let value = options.resizeWidth {
                image = imgg.resize(width: value)
            }
            
            if let value = options.resizeScale {
                image = imgg.resize(scale: value)
            }
        }
        getImage(image, path)
    }
    
    private func showNoAuthorizationAlert(_ message:String) {
        let a1 = UIAlertAction(title: "去设置", style: .default) { (action) in
            let url = URL.init(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        let a2 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "温馨提示", message: message, preferredStyle: .alert)
        alert.addAction(a1)
        alert.addAction(a2)
        presentController.present(alert, animated: true, completion: nil)
    }
}

extension ImagePicker:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let info = Dictionary(uniqueKeysWithValues: info.map {key, value in (key.rawValue, value)})
        picker.dismiss(animated: true, completion: nil)

        let absoluteString = (info[UIImagePickerController.InfoKey.referenceURL.rawValue] as? NSURL)?.absoluteString

        let mediaType = info[UIImagePickerController.InfoKey.mediaType.rawValue] as? String
        if mediaType == MediaType.image.rawValue {
            
            let editedImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage
            let originalImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
            guard let image = editedImage ?? originalImage else {
                return
            }
            
            if picker.sourceType == .camera {
                DispatchQueue.global().async {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            }
           
            editImage(image.fixOrientation(), path: absoluteString)
            
        } else if mediaType == MediaType.video.rawValue {
            
            if let url = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL {
                let pathString = url.absoluteString
                
                if picker.sourceType == .camera {
                    if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathString) {
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                        }) { (finish, error) in
                        }
                    }
                }
               
                let thumbail = getVideoThumbnail(url)?.fixOrientation()
                editImage(thumbail, path: pathString)
            }
            
        }
       
    }
}


