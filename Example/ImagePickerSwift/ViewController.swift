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
        let options = ImagePickerOptions()
        options.pickType = .photo
        options.mediaTypes = .image
        options.sourceType = .photoLibrary
        options.allowsEditing = true
        ImagePicker.default.present(with: options) { (image, url) in
            self.imageView.image = image
            self.videoUrl = url
        }
    }
    
    @IBAction func openLibraryPickVideo(_ sender: Any) {
        let options = ImagePickerOptions()
        options.pickType = .photo
        options.mediaTypes = .video
        options.sourceType = .photoLibrary
        options.allowsEditing = true
        ImagePicker.default.present(with: options) { (image, url) in
            self.imageView.image = image
            self.videoUrl = url
        }
    }
    
    @IBAction func openLibraryPickAll(_ sender: Any) {
        let options = ImagePickerOptions()
        options.pickType = .photo
        options.mediaTypes = .all
        options.sourceType = .photoLibrary
        options.allowsEditing = true
        ImagePicker.default.present(with: options) { (image, url) in
            self.imageView.image = image
            self.videoUrl = url
        }
    }

    
    @IBAction func openCamera(_ sender: Any) {
        
        let options = ImagePickerOptions()
        options.pickType = .camera
        options.sourceType = .camera
        ImagePicker.default.present(with: options) { (image, url) in
            self.imageView.image = image
        }
       
    }
    @IBAction func openVideo(_ sender: Any) {
        let options = ImagePickerOptions()
        options.pickType = .video
        options.sourceType = .camera
        ImagePicker.default.present(with: options) { (image, url) in
            self.imageView.image = image
            self.videoUrl = url
        }
    }
}



