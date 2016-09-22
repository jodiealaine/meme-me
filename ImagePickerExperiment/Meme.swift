//
//  Meme.swift
//  ImagePickerExperiment
//
//  Created by JODIE PARKER on 22/09/2016.
//  Copyright © 2016 urbanshed. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    // MARK: Properties
    var textTop: String
    var textBottom: String
    var image: UIImage?
    var memedImage: UIImage?
    
    init?(textTop: String, textBottom: String, image: UIImage?, memedImage: UIImage?) {
        self.textTop = textTop
        self.textBottom = textBottom
        self.image = image
        self.memedImage = memedImage
        
        if textTop.isEmpty || textBottom.isEmpty {
            return nil
        }
    }
    
    
}
