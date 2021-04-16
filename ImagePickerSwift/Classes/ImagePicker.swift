import UIKit
import AVFoundation
import Photos
import PhotosUI

open class ImagePicker:NSObject{
    
    public static let `default` = ImagePicker()
    
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


    open func present(with options:ImagePickerOptions , _ completion: ((UIImage?, String?) -> Void)? = nil) {
        
        setupImagePicker(options: options)
        
        self.getImage = { image, url in
            completion?(image, url)
        }
    }
    
}

extension ImagePicker {
    
    private func setupImagePicker(options: ImagePickerOptions) {
        self.options = options
        
        let type = options.pickType
        picker.sourceType = options.sourceType
        picker.allowsEditing = options.allowsEditing
        
        /// 是否有访问相册权限
        let author: PHAuthorizationStatus = PHAuthorizationStatus.authorized
        if author == .restricted || author == .denied {
            showNoAuthorizationAlert("相册权限未开启,请在设置中启用")
            return
        }
        
        if type == .photo {
            
            picker.mediaTypes = options.mediaTypes.MediaTypes
            
        } else if type == .camera {
            assert(options.sourceType == .camera, "sourceType 必须指定为camera")
            
            /// 是否有访问相机权限
            let author: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            if author == .restricted || author == .denied {
                showNoAuthorizationAlert("相机权限未开启,请在设置中启用")
                return
            }
            
            picker.mediaTypes = options.mediaTypes.MediaTypes
            picker.cameraCaptureMode = .photo
            
            
        } else if type == .video {
            assert(options.sourceType == .camera, "sourceType 必须指定为camera")
            
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
            
            picker.mediaTypes = [MediaType.video.rawValue]
            picker.cameraCaptureMode = .video
            picker.cameraDevice = options.cameraDevice
            picker.videoMaximumDuration = options.videoMaximumDuration
            picker.videoQuality = options.videoQuality
           
        }
        
        presentController.present(picker, animated: true, completion: nil)
    }
    
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
            
            if options.sourceType == .camera {
                DispatchQueue.global().async {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            }
           
            editImage(image.fixOrientation(), path: absoluteString)
            
        } else if mediaType == MediaType.video.rawValue {
            
            if let url = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL {
                let pathString = url.absoluteString
                
                if options.sourceType == .camera {
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


