//
//  ItemsDetailView.swift
//  BookSpot
//
//  Created by MacBook on 2/15/16.
//  Copyright © 2016 Clair&Sida. All rights reserved.
//

import UIKit

class BookDetails: UIViewController, UINavigationBarDelegate {
    

    @IBOutlet var bookTitle: UILabel!
    @IBOutlet var bookAuthor: UILabel!
    @IBOutlet var bookGenre: UILabel!
    @IBOutlet var bookDescription: UITextView!
    @IBOutlet var location: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var bookAddedOn: UILabel!
    @IBOutlet var bookUser: UILabel!
    @IBOutlet var bookFound: UILabel!
    
    var currentObject : PFObject!
    
    var bTitle : String = "No title to display :("
    var bAuthor = ""
    var bGenre = ""
    var bDescription = ""
    var bLocation = ""
    var bPhoto = UIImage(named: "random.jpg")
    var bUser = ""
    var bDate = NSDate()
    var bFound = ""
    var bFoundBool = Bool()
    
    override func viewWillAppear(_ animated: Bool) {
        
        if currentObject != nil {
            navigationItem.title = currentObject?.value(forKey: "title") as? String
            bookTitle.text = currentObject?.value(forKey: "title") as? String
            bookAuthor.text = currentObject?.value(forKey: "author") as? String
            bookGenre.text = currentObject?.value(forKey: "gerne") as? String
            bookDescription.text = currentObject?.value(forKey: "descriptionNew") as? String
            location.text = currentObject?.value(forKey: "location") as? String
            if let pfImage = currentObject?.value(forKey: "photo") as? PFFile {

                pfImage.getDataInBackground() {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        let image = UIImage(data: imageData!)
                        self.imageView.image = image!
                    }
                    }
                }
        
        }
        else {
            navigationItem.title = bTitle
            bookTitle.text = bTitle
            bookAuthor.text = bAuthor
            bookGenre.text = bGenre
            bookDescription.text = bDescription
            location.text = bLocation
            imageView.image = bPhoto
            bookUser.text = bUser
            bookAddedOn.text = "\(bDate)"
            bookFound.text = bFound
        }
        
    }
    
 }





