//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by JODIE PARKER on 19/09/2016.
//  Copyright © 2016 urbanshed. All rights reserved.
//

import UIKit


class MemeEditorViewController: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var textTop: String = ""
    var textBottom: String = ""
    var image: UIImage!
    var memedImage: UIImage!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0 // Needs to be a negative in order to be stroked and filled
    ] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ensure Share Functionality is initial disabled
        shareButton.isEnabled = false
        
        // Ensure no image is set
        imagePickerView.image = nil
        
        // Styling and Set Text Fields
        setUpTextField(textField: bottomTextField, text: "BOTTOM")
        setUpTextField(textField: topTextField, text: "TOP")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Ensure Camera functionality only enabled for devices that can handle it
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        // Handle the text field's user input through delegate callbacks
        topTextField.delegate = self
        bottomTextField.delegate = self
 
        // Styling Icons
        shareButton.image = UIImage(named: "shareIcon.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        // Subscribe to Keyboard Notifications
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from Keyboard Notifications
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Handle keyboard input
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        resetViewFrame()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        // Only remove default text
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
        if topTextField.isEditing {
            resetViewFrame()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text == ""){
            if textField.tag == 1 {
                textField.text = "TOP"
            }else {
                textField.text = "BOTTOM"
            }
        }
    }
    func resetViewFrame(){
        view.frame.origin.y = 0
    }
    
    // MARK: Handle Keyboard Notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // When the keyboardWillShow notication is received, shift the view's frame up
    func keyboardWillShow(notification: NSNotification){
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification: notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            resetViewFrame()
        }
    }
    
    // MARK: Create the meme
    
    func generateMemedImage() -> UIImage {
        // Hide the toolbar and navbar
        toggleNavToolBars(hidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show the toolbar and navbar
        toggleNavToolBars(hidden: false)
        
        return memedImage
    }
    
    func save(){
        let meme = Meme(textTop: topTextField.text!, textBottom: bottomTextField.text!, image: imagePickerView.image, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme!)
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
        // Enable the share button
        shareButton.isEnabled = true
    }

    // MARK: Actions
    
    @IBAction func selectImage(_ sender: UIBarButtonItem) {
        // When I click on Pick I want the UIImagePickerController to show my library of images
        getImage(source: .photoLibrary)
    }
    
    @IBAction func takeImage(_ sender: UIButton) {
        // When I click on Camera I want the UIImagePickerController to allow me to take a new image
        getImage(source: .camera)
    }
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        memedImage = generateMemedImage()
        let image: UIImage = memedImage
        let itemsToShare = [image]
        let shareViewController : UIActivityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        shareViewController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        self.present(shareViewController, animated: true, completion: nil)
    }
    
    // TODO: Cancel seems to need to return to another page... refresh doesn't seem to work
    @IBAction func cancelMeme(_ sender: AnyObject){
        viewDidLoad()
        viewWillAppear(true)
    }
    
    // MARK: Utility Functions
    func toggleNavToolBars(hidden: Bool){
        navBar!.isHidden = hidden
        toolbar!.isHidden = hidden
    }
    
    func getImage(source: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setUpTextField(textField: UITextField, text: String){
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.text = text
    }
}

