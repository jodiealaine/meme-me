//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by JODIE PARKER on 19/09/2016.
//  Copyright © 2016 urbanshed. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var imagePickerView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    // When I cancel then I want to return to the original scene
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // When I select an image then I want that image to be displayed in UIImageView
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePickerView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }

    // MARK: Actions
    
    @IBAction func selectImage(_ sender: UIBarButtonItem) {
        // When I click on Pick I want the UIImagePickerController to show my images
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

