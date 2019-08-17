//
//  ViewController.swift
//  Munch-E
//
//  Created by jason@rhombe on 7/11/19.
//  Copyright © 2019 Rhombe Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func btnClick(_ sender: UIButton) {
        print("Button clicked")
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
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available.")
        }
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

