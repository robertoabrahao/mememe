//
//  ViewController.swift
//  MemeMe
//
//  Created by Roberto Abrahao on 5/20/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    //Outlets to the visual elements in the view controller
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //defines if the user edited the top text at least once
    var isTopTextEdited = false

    //defines if the user edited the bottom text at least once
    var isBottomTextEdited = false
    
    //the memed image created when the user finishes editing it
    var memedImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up the top text inicial value, centers it, and disables the textfield
        topTextField.text = "TOP"
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.enabled = false
        
        //Sets up the bottom text inicial value, centers it, and disables the textfield
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.enabled = false
        
        //Defines the font style to both top and bottom textfields
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        //Remove the borders of both top and bottom text fields
        topTextField.borderStyle = UITextBorderStyle.None
        bottomTextField.borderStyle = UITextBorderStyle.None
        
        //Disables the share button
        shareButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Checks if there is a camera available and, if not, disables the camera button
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //Subscribes to the keyboard notifications to move the view when the keyboard is activated
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Unsubscribes to the keyboard notifications to stop moving the view when the keyboard is activated
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
        if textField == topTextField {
            //Cleans-up the top text field in the first time the user edits it
            if !isTopTextEdited {
                topTextField.text = ""
            }
            //Unsubscribes to the keyboard notifications to stop moving the view when the keyboard is activated
            self.unsubscribeFromKeyboardNotifications()
        }
        //Cleans-up the top text field in the first time the user edits it
        if textField == bottomTextField && !isBottomTextEdited {
            bottomTextField.text = ""
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == topTextField {
            //Subscribes to the keyboard notifications again to move the view when the keyboard is activated
            self.subscribeToKeyboardNotifications()
            
            //Identifies that the user already edited the top text field
            isTopTextEdited = true
        }
        if textField == bottomTextField {
            
            //Identifies that the user already edited the bottom text field
            isBottomTextEdited = true
        }
        
        //Enables the share button only if both text fields have been edited
        shareButton.enabled = isTopTextEdited && isBottomTextEdited
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //Dimisses the keyboard when the user press return
        textField.resignFirstResponder()
        return true
    }

    @IBAction func takeAPhoto(sender: UIBarButtonItem) {
        
        //Shows the camera image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        
        //Shows the photo library image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        //Presents the meme table/collection view controller
        var memeCollectionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        self.presentViewController(memeCollectionViewController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        
        //Generates the meme
        memedImage = generateMemedImage()
        
        //Prepare the activity view controller
        var activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionHandler = { (activity, sucess) in
            
            //Once the activity is selected, saves the new meme
            self.save()
            
            //Dismiss the activity view controller
            self.dismissViewControllerAnimated(true, completion: nil)
            
            //Presents the mmeme collection view controller
            var memeCollectionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            self.presentViewController(memeCollectionViewController, animated: true, completion: nil)
        }
        
        //Presents the activity view controller
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        //Once the user selects an image, sets is in the image view
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            
            //Enables both text fields
            topTextField.enabled = true
            bottomTextField.enabled = true
            
            //And dismisses the image picker view controller
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //Subscribes to both keyboardWillShow and keyboardWillHide notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Unsubscribes from both keyboardWillShow and keyboardWillHide notifications
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        //Moves the view up so the keyboard doesn't cover the image
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //Moves the view back down
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    //Gets the keyboard height in the screen
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func save() {
        //Create the meme
        var meme = Meme()
        meme.text = topTextField.text + " " + bottomTextField.text
        meme.originalImage = imagePickerView.image
        meme.memedImage = memedImage
        
        //Adds the meme to the shared model
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage
    {
        //hides both navigation and tool bar
        navigationBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //shows both navigation and tool bar again
        navigationBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }

}

