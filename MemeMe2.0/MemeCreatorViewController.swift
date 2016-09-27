//
//  MemeCreatorViewController.swift
//  MemeMe2.0
//
//  Created by afbdev on 9/13/16.
//  Copyright © 2016 afbdev. All rights reserved.
//

import UIKit

class MemeCreatorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {


    var memes = [Meme]()
    var meme: Meme?
    
    
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var albumButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var toolBar: UIToolbar!
    
    @IBAction func cancelMeme(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextAttributes(topTextField, text: "TOP")
        setTextAttributes(bottomTextField, text: "BOTTOM")
        
        // Dismiss keyboard when screen is tapped
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MemeCreatorViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes

        if meme != nil {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        
        // Disabling the camera button if camera isnot available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        // Set meme details if editing a meme
        if meme != nil {
            imagePickerView.image = meme?.originalImage
            topTextField.text = meme?.topText
            bottomTextField.text = meme?.bottomText
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    
    
    // IMAGE METHODS
    
    // Selecting image from Camera
    @IBAction func pickImageFromCamera(_ sender: AnyObject) {
        
        pickImageFromSource(type: .camera)
    }
    
    // Selecting image from Photo Library
    @IBAction func pickImageFromAlbum(_ sender: AnyObject) {
        
        pickImageFromSource(type: .photoLibrary)
    }
    
    // Receiving the image using the delegate pattern
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismiss(animated: true, completion: nil)
            
            self.shareButton.isEnabled = true
        }
    }
    
    // Image picker controller
    func pickImageFromSource(type: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    // MEME TEXT ATTRIBUTES
    
    // Array of attributes to apply to meme text
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0
    ] as [String : Any]
    
    // Method for setting text field attributes
    
    func setTextAttributes(_ textField: UITextField, text: String) {
        textField.delegate = self
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    
    
    
    // KEYBOARD METHODS
    
    // Adding observer for keyboard notification
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector:#selector(MemeCreatorViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(MemeCreatorViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Removing observer for keyboard notification
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Moving frame up when keyboard is used
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    // Moving frame down when keyboard is dismissed
    func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    // Obtaining height for keyboard movement
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Dismissing keyboard with return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    

    
    
    // MEME METHODS
    
    // Combining original image and text into memed image
    func generateMemedImage() -> UIImage {
        
        // Hide bars
        navigationBar.isHidden = true
        toolBar.isHidden = true
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        // Show bars
        navigationBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    
    // Save the memed image
    func save() {
        
        let memedImage: UIImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
  
    
    // Share button action
    @IBAction func shareMeme(_ sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        let activityVC: UIActivityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = { (activityType, completed: Bool, returnedItems: [Any]?, error) in
            
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
                
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }

    
    
    
    
}
