//
//  ViewController.swift
//  ImagePickerSwift
//
//  Created by winterrain5 on 04/16/2021.
//  Copyright (c) 2021 winterrain5. All rights reserved.
//

import UIKit
import ImagePickerSwift
import AVKit
class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var videoUrl:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openImage))
        imageView.addGestureRecognizer(tap)
    }

    @objc func openImage() {
        guard let url = URL(string: videoUrl ?? "") else { return }
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func openLibraryPickImage(_ sender: Any) {
        ImagePicker.show(type: .selectPhoto, with: .default) { (image, url) in
            self.imageView.image = image
        }
    }
    
    @IBAction func openLibraryPickVideo(_ sender: Any) {

        ImagePicker.show(type:.selectVideo, with: .default) { (image, url) in
            self.imageView.image = image
            self.videoUrl = url
        }
    }
    
    @IBAction func openLibraryPickAll(_ sender: Any) {

        ImagePicker.show(type:.selectePhotoAndVideo, with: .default) { (image, url) in
            self.imageView.image = image
            self.videoUrl = url
        }
    }

    
    @IBAction func openCamera(_ sender: Any) {
        
        let options = ImagePickerOptions()
        options.cameraDevice = .front
        ImagePicker.show(type:.takePhoto, with: .default) { (image, url) in
            self.imageView.image = image
            self.videoUrl = url
        }
    }
    @IBAction func openVideo(_ sender: Any) {

        ImagePicker.show(type:.recordVideo, with: .default) { (image, url) in
            self.imageView.image = image
            self.videoUrl = url
        }
    }
}



