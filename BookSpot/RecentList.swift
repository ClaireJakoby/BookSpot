//
//  Menu.swift
//  BookSpot
//
//  Created by MacBook on 2/15/16.
//  Copyright © 2016 Clair&Sida. All rights reserved.
//

import UIKit

class RecentList: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var userPicture: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userJoinDate: UILabel!
    @IBOutlet var userBooksAdded: UILabel!
    @IBOutlet var userBooksTaken: UILabel!
    @IBOutlet var userCameraButton: UIButton!
    @IBOutlet var userView: UIView!
    
    var booksTaken = [Int]()

    @IBAction func userTakePicture(sender: AnyObject) {
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
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        userPicture.image = image
        dismissViewControllerAnimated(true, completion: nil)
        
        let PFImage = PFFile(data: UIImageJPEGRepresentation(image, 1)!)
        PFUser.currentUser()!.setObject(PFImage!, forKey: "picture")
        PFUser.currentUser()?.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
            if (success) {
            NSLog("User picture has been saved.")
            }
        }

    }
    
    
    var allBooks = [PFObject]()
    var bookDetails = BookDetails()

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBooks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! ItemCell
        
        let bookPath = allBooks[indexPath.row]
        cell.titleLabel.text = bookPath.valueForKey("title") as? String
        cell.locationLabel.text = bookPath.valueForKey("locationString") as? String
        let parseImage = bookPath.valueForKeyPath("photo") as? PFFile
        cell.bookImageView.file = parseImage
        cell.bookImageView.loadInBackground()
        cell.bookImageView.layer.cornerRadius = 8.0
        cell.bookImageView.clipsToBounds = true
        cell.backgroundColor = UIColor(red: 67/255, green: 174/255, blue: 170/255, alpha: 0.3)
        cell.alpha = 1
        
        return cell
    }
    
    func loadObjectsFromParse() {
        
        let query = PFQuery(className: "EntrySaveData")
        query.includeKey("user")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            self.allBooks = objects!
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bookDetails = self.storyboard?.instantiateViewControllerWithIdentifier("bookDetails") as! BookDetails
        let bookPath = allBooks[indexPath.row]
        bookDetails.bTitle = bookPath.valueForKey("title") as! String
        bookDetails.bAuthor = bookPath.valueForKey("author") as! String
        bookDetails.bGenre = bookPath.valueForKey("gerne") as! String
        bookDetails.bDescription = bookPath.valueForKey("descriptionNew") as! String
        let user = bookPath.valueForKey("user") as! PFUser
        bookDetails.bUser = user.valueForKey("username") as! String
        bookDetails.bDate = bookPath.valueForKey("createdAt") as! NSDate
        bookDetails.bFoundBool = bookPath.valueForKey("found") as! Bool
        
        
        if bookPath.valueForKey("locationString") != nil {
        bookDetails.bLocation = bookPath.valueForKey("locationString") as! String
            }
        
        if let pfImage = bookPath["photo"] as? PFFile {
            pfImage.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    let image = UIImage(data: imageData!)
                    bookDetails.bPhoto = image!
                    if image != nil {
                        self.navigationController?.pushViewController(bookDetails, animated: true)
                    }
                }
            }
            
        bookDetails.loadView()
        }
    }
    
    override func viewDidLoad() {
        self.loadObjectsFromParse()
        self.tableView.reloadData()
        
        userName.text = "User: \(PFUser.currentUser()!.username!)"
        userJoinDate.text = "Joined: \(PFUser.currentUser()!.createdAt!)"
        
        //retrieve user picture from parse
        if let pfImage = PFUser.currentUser()!.valueForKey("picture") as? PFFile {
            pfImage.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    let image = UIImage(data: imageData!)
                    self.userPicture.image = image!
                }
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //set the number of userBooksAdded
        let query = PFQuery(className: "EntrySaveData")
        query.includeKey("user")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if objects != nil {
                    self.userBooksAdded.text = "\(objects!.count)"
                }
            }
        }
        
        //set the number of userBooksTaken
        let userQuery = PFUser.query()
        
        userQuery!.whereKey("email", equalTo: PFUser.currentUser()!.email!)
        userQuery!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if object.valueForKey("foundCount") != nil {
                        let userFoundCount = object.valueForKey("foundCount") as! Int
                        self.userBooksTaken.text = "\(userFoundCount)"
                    }
                }
            }
        }

        // Refresh the table to ensure any data changes are displayed
        tableView.reloadData()
        
    }
}
