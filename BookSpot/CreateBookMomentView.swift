//
//  CreateItemsDetailView.swift
//  BookSpot
//
//  Created by MacBook on 2/15/16.
//  Copyright © 2016 Clair&Sida. All rights reserved.
//

import UIKit
import MapKit

class BookMoment: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var authorTextField: UITextField!
    @IBOutlet var genreTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    
    @IBOutlet var locationAutoLabel: UILabel!

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIBarButtonItem!

    @IBOutlet var deleteButton: UIBarButtonItem!
    
    @IBAction func deletePhoto(sender: UIBarButtonItem) {
        if imageView != nil {
            imageView.image = nil
            saveButton.isEnabled = false
            deleteButton.isEnabled = false
            super.viewWillAppear(true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if imageView.image != nil {
            deleteButton.isEnabled = true
            saveButton.isEnabled = true
        }
    }
    override func viewDidLoad() {
        addressMaker()
    }
    
   // var book = BookDetails()
    
    // updating the Label of the location
    func addressMaker() {
        let manager = CLLocationManager()
        let locator = manager.location?.coordinate
        let geoCoder = CLGeocoder()
        if let long = locator?.longitude {
        if let lati = locator?.latitude {

        let location = CLLocation(latitude: lati, longitude: long )
        geoCoder.reverseGeocodeLocation(location)
            {
                (placemarks, error) -> Void in
                
                let placeArray = placemarks as [CLPlacemark]!
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                // Address dictionary
                print(placeMark.addressDictionary as Any)
                
                // Location names
               // let locationName = placeMark.addressDictionary?["Name"] as! NSString
                let street = placeMark.addressDictionary?["Thoroughfare"] as! NSString
                let city = placeMark.addressDictionary?["City"] as! NSString
                let zip = placeMark.addressDictionary?["ZIP"] as! NSString
                let country = placeMark.addressDictionary?["Country"] as! NSString
                self.locationAutoLabel.text = "\(street), \(city), \(zip), \(country)"
                }
            }
        }
    }

    
    // Taking Pictures FUNCTION
    @IBAction func takePicture(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        
        // Camera or Library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Save to the preview
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }



    // PRESS SAVE TO PARSE
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        
        let newEntrySave = PFObject(className:"EntrySaveData")
        
        newEntrySave["title"] = titleTextField.text
        newEntrySave["author"] = authorTextField.text
        newEntrySave["gerne"] = genreTextField.text
        newEntrySave["descriptionNew"] = descriptionTextView.text
        newEntrySave["locationString"] = locationAutoLabel.text
        newEntrySave["user"] = PFUser.current()
        newEntrySave["found"] = false
        
        let manager = CLLocationManager()
        let loc =  manager.location!.coordinate
        let bookLocation = PFGeoPoint(latitude:loc.latitude,longitude:loc.longitude)
        newEntrySave["location"] = bookLocation

        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)
        let parsePhoto = PFFile(data: imageData!)
        newEntrySave.setObject(parsePhoto!, forKey: "photo")
        
        newEntrySave.saveInBackground as! PFBooleanResultBlock {
            (success: Bool, error: NSError?) -> Void in 
            if (success) {
                NSLog("The object has been saved.")
                
                //Sends book details to BookDetailView
                let bookDetails = self.storyboard?.instantiateViewController(withIdentifier: "bookDetails") as! BookDetails
                bookDetails.bTitle = self.titleTextField.text!
                bookDetails.bAuthor = self.authorTextField.text!
                bookDetails.bGenre = self.genreTextField.text!
                bookDetails.bDescription = self.descriptionTextView.text!
                bookDetails.bLocation = self.locationAutoLabel.text!
                bookDetails.bPhoto = self.imageView.image!
                bookDetails.bUser = PFUser.current()!.username!
                
                    //Shows notification when entry is saved
                let title = "Entry Saved"
                let message = "The new book entry was successfully saved"
                let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                
                
                
                let doneAction = UIAlertAction(title: "View Entry", style: .cancel, handler: {(action) -> Void in
                    
                    //Resets all the text fields
                    self.titleTextField.text = nil
                    self.authorTextField.text = nil
                    self.genreTextField.text = nil
                    self.descriptionTextView.text = nil
                    self.imageView.image = nil
                    self.locationAutoLabel = nil
                    
                    
                    //Presents the book detail view when the action button is pressed
                    self.navigationController?.pushViewController(bookDetails, animated: true)
                    bookDetails.loadView()
                })
                        ac.addAction(doneAction)
                
                        //Present the alert controller
                self.present(ac, animated: true, completion: nil)
                    }
            }
    }
}


