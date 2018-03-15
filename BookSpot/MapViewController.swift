//
//  MapViewController.swift
//  BookSpot
//
//  Created by MacBook on 2/15/16.
//  Copyright © 2016 Clair&Sida. All rights reserved.
//
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,  PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    

    var locationManager: CLLocationManager!
    var pinArray = [PFObject]()

    
    
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        let location = CLLocationCoordinate2D(latitude: 52.373305, longitude: 4.892629)
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        mapView.showsUserLocation = true
    
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func cameraSetUp () {
        mapView.camera.altitude = 1400
        mapView.camera.pitch = 50
        mapView.camera.heading = 180
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000)
        
        mapView.setRegion(region, animated: true)
        locationManager = nil
    }
    
    func setAnnotations() {
        
        //Run query and get objects from parse, then add annotations
        let query = PFQuery(className: "EntrySaveData")
        query.includeKey("user")
        query.findObjectsInBackground { ([PFObject?], NSError) in
            
            if error == nil{
                
                self.pinArray = objects!
                for object in self.pinArray{
                    
                    //data for annotation
                    let annotation = BookAnnotation(object: object)
                    let place = object.valueForKey("location") as? PFGeoPoint
                    let pinPlace = CLLocationCoordinate2D(latitude: place!.latitude, longitude: place!.longitude)
                    let bookTitle = object.valueForKey("title") as? String
                    let bookDes = object.valueForKey("descriptionNew") as? String
                    annotation.coordinate = pinPlace
                    annotation.title = bookTitle
                    annotation.subtitle = bookDes

                    self.mapView.addAnnotation(annotation)
                
                }
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? BookAnnotation{
            let identifier = "pin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
             
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                annotationView!.canShowCallout = true
                annotationView!.calloutOffset = CGPoint(x: -5, y: 5)
                annotationView!.rightCalloutAccessoryView = UIButton(type: .infoLight) as UIView
                annotationView!.image = UIImage(named: "bookPinIcon")

                let bookDetails = BookDetails()
            if let pfImage = annotation.currentObject!["photo"] as? PFFile {
                            pfImage.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                        let image = UIImage(data: imageData!)
                        bookDetails.bPhoto = image!

                                }
                            }
                        }
                    
                let leftIconView = PFImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
            let imageBooks = annotation.currentObject!["photo"] as! PFFile
                        leftIconView.file = imageBooks
                        annotationView!.leftCalloutAccessoryView = leftIconView
                        leftIconView.loadInBackground()
            }
            else
            {
                annotationView!.annotation = annotation
            }
            return annotationView
        }
        return nil
    }

    override func viewWillAppear(_ animated: Bool) {
        setAnnotations()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let customAnnotation = view.annotation as! BookAnnotation
        let bookDetails = self.storyboard?.instantiateViewController(withIdentifier: "bookDetails") as! BookDetails
        bookDetails.currentObject = customAnnotation.currentObject
        self.navigationController?.pushViewController(bookDetails, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (PFUser.current() == nil) {
            let loginViewController = LoginViewController()
            loginViewController.delegate = self
            
            loginViewController.emailAsUsername = true
            loginViewController.signUpController?.delegate = self
            loginViewController.signUpController?.emailAsUsername = true
            loginViewController.signUpController?.delegate = self
            
            self.present(loginViewController, animated: true, completion: nil)
        } else {

        }
    }
    
    //If user is already logged in
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismiss(animated: true, completion: nil)
        presentLoggedInAlert()
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        user.setObject(0, forKey: "foundCount")
        user.saveInBackground()
        self.dismiss(animated: true, completion: nil)
        presentLoggedInAlert()
    }
    
    func presentLoggedInAlert() {
        let alertController = UIAlertController(title: "You're logged in", message: "Welcome to BookSpot", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
