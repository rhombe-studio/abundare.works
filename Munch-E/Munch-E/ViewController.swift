//
//  ViewController.swift
//  Munch-E
//
//  Created by jason@rhombe on 7/11/19.
//  Copyright © 2019 Rhombe Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var selectedImg: UIImageView!
    
    @IBAction func btnClick(_ sender: UIButton) {
        print("Opening Image Picker")
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func openCameraButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            // Prevent user from editing/cropping the photo
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available.")
        }
    }
    @IBAction func munchify(_ sender: Any) {
        //
        print("MUNCHIFYING IMAGE: \(selectedImg.image!)")
//        Save the input image size
//        Convert the input UIImage to a 720 x 720 CVPixelBuffer, as specified in the model view.
//        Feed it to our Model
//        Convert the CVPixelBuffer output to an UIImage
//        Resize it to the original size saved at the first step

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View loaded")
        // Do any additional setup after loading the view.
    }
    
    // This implements a function from UIImagePickerControllerDelegate
    // to handle the image after it has been selected.
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else
        {
            print("Failed to import UIImage for processing...")
            return
        }
        picker.delegate = self
        selectedImg.contentMode = UIView.ContentMode.scaleAspectFill
        selectedImg.image = image
        let imageName = UUID().uuidString
        print("IMAGE NAME: \(imageName)")
        let imagePath =
            getDocumentsDirectory().appendingPathComponent(imageName)
        print("IMAGE PATH: \(imagePath)")
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask)
        return paths[0]
    }


}

