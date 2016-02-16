//
//  ViewController.swift
//  JordanHeadMeme
//
//  Created by David Okun on 12/18/15.
//  Copyright © 2015 David Okun, LLC. All rights reserved.
//

import UIKit
import SVProgressHUD
import Crashlytics

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageEditingViewControllerDelegate {
    
    // MARK: IBActions
    
    @IBAction func takePhotoTapped() {
        // TODO: Track the user action that is important for you.
        Answers.logCustomEventWithName("Photo Capture Began", customAttributes: ["Method":"Take Photo"])
        let picker = UIImagePickerController.init()
        picker.sourceType = .Camera
        presentPicker(picker)
    }
    
    @IBAction func takeSelfieTapped() {
        Answers.logCustomEventWithName("Photo Capture Began", customAttributes: ["Method":"Take Selfie"])
        let picker = UIImagePickerController.init()
        picker.sourceType = .Camera
        picker.cameraDevice = .Front
        presentPicker(picker)
    }
    
    @IBAction func choosePhotoTapped() {
        Answers.logCustomEventWithName("Photo Capture Began", customAttributes: ["Method":"Choose Photo"])
        let picker = UIImagePickerController.init()
        picker.sourceType = .PhotoLibrary
        presentPicker(picker)
    }
    
    func presentPicker(picker: UIImagePickerController) {
        picker.allowsEditing = false
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        Answers.logCustomEventWithName("Photo Capture Completed", customAttributes: ["Got Photo":info[UIImagePickerControllerOriginalImage] != nil])
        picker.dismissViewControllerAnimated(true) { () -> Void in
            self.performSegueWithIdentifier("editImageSegue", sender: info[UIImagePickerControllerOriginalImage] as! UIImage)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        Answers.logCustomEventWithName("Photo Capture Cancelled", customAttributes:nil)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "editImageSegue") {
            let nextController:ImageEditingViewController = segue.destinationViewController as! ImageEditingViewController
            nextController.uneditedImage = sender as! UIImage
            nextController.delegate = self
        }
    }
    
    // MARK: ImageEditingViewControllerDelegate methods
    
    func controllerDidFinishWithImage(controller: ImageEditingViewController, image: UIImage) {
        controller.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func controllerDidCancel(controller: ImageEditingViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

