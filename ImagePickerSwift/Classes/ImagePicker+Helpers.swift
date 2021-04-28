//
//  DKImagePicker+Helpers.swift
//  CameraPhotoTool
//
//  Created by VICTOR03 on 2021/4/15.
//

import Foundation
import UIKit

open class ImagePickerOptions: NSObject {
    
    public static var `default` = ImagePickerOptions()
    
    public var allowsEditing = false
    public var rotateCameraImage: CGFloat = 0
    public var resizeWidth: CGFloat?
    public var resizeScale: CGFloat?
    public var presentController: UIViewController?
    /// 数据来源 camera: 相机 photoLibrary： 图库
    public var sourceType: UIImagePickerController.SourceType = .photoLibrary
    /// 相机拍摄方向 rear：后置 front：前置
    public var cameraDevice: UIImagePickerController.CameraDevice = .rear
    /// 相机模式 video：录制 photo：拍照
    public var cameraCaptureMode: UIImagePickerController.CameraCaptureMode = .video
    /// 文件类型 
    public var mediaTypes: MediaType = .image
    /// 视频质量
    public var videoQuality: UIImagePickerController.QualityType = .typeMedium
    /// 视频最大时长
    public var videoMaximumDuration: TimeInterval = Double.infinity
}

public enum MediaType: String {
    case image = "public.image"
    case video = "public.movie"
    case all
    
    var MediaTypes: [String] {
        switch self {
        case .image:
            return ["public.image"]
        case .video:
            return ["public.movie"]
        case .all:
            return ["public.movie","public.image"]
        }
    }
}

/// 操作类型
public enum PickerType {
    // 录制视频
    case recordVideo
    // 选择选择
    case selectVideo
    // 拍照
    case takePhoto
    // 选择照片
    case selectPhoto
    // 选择照片和视频
    case selectePhotoAndVideo
}

