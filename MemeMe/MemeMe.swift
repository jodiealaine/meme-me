//
//  imagePicker.swift
//  ImagePickerExperiment
//
//  Created by JODIE PARKER on 19/09/2016.
//  Copyright © 2016 urbanshed. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }
}
