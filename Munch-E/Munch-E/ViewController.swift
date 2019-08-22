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
        guard let input: UIImage = selectedImg.image else {
            print("Valid input image required!")
            return
        }
        // Initialize the NST model
//        let model = StarryNight()
        
        // TODO:
        if #available(iOS 13.0, *) {
           let model = Scream()
        
            // Next steps are pretty heavy, better process them on a background thread
            DispatchQueue.global().async {
                
                // 1 - Transform our UIImage to a PixelBuffer of appropriate size
                // CHANGE: transform UIImage to MLMultiArray
                guard let cvBufferInput = input.pixelBuffer(width: 1000, height: 1000) else {
                    print("UIImage to PixelBuffer failed")
                    return
                }
                
                // 2 - Feed that PixelBuffer to the model
                guard let output = try? model.prediction(inputImage: cvBufferInput) else {
                    print("Model prediction failed")
                    return
                }
                
                // 3 - Transform PixelBuffer output to UIImage
                guard let outputImage = UIImage(pixelBuffer: output._175) else {
                    print("PixelBuffer to UIImage failed")
                    return
                }
                
                // 4 - Resize result to the original size, then hand it back to the main thread
                let finalImage = outputImage //.resize(to: input.size)
                DispatchQueue.main.async {
                    self.displayNewImage(image: finalImage)
                }
            }
        }
    }
    func displayNewImage(image: UIImage?) {
        selectedImg.image = image
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
        selectedImg.contentMode = UIView.ContentMode.scaleAspectFit
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

