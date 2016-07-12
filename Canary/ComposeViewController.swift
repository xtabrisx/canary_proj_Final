//
//  ComposeViewController.swift
//  Canary
//
//  Created by Alberto Tocados on 4/7/16.
//  Copyright © 2016 ATL. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

class ComposeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var composeTextView: UITextView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var coordsLBL: UILabel!
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        composeTextView.layer.borderColor = UIColor.orangeColor().CGColor
        composeTextView.layer.borderWidth = 1
        composeTextView.layer.cornerRadius = 5
        //composeTextView.becomeFirstResponder()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.stopUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
        
        
        //Ocultar el teclado al hacer tap fuera
        self.hideKeyboardWhenTappedAround()
        
     
        
        //let locationReverse = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        /*
        geoCoder.reverseGeocodeLocation(locationManager.location!, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            //placeMark contiene toda la info del punto
            print(placeMark.addressDictionary)
            
            
            // Ciudad
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
                self.coordsLBL.text = city as String
            }
            
            
        })*/
 
       
        
    }
    
    
    
   
    

    @IBAction func sendCanary(sender: AnyObject) {
        
        
        var canary:PFObject = PFObject(className: "Canary")
        canary["content"] = composeTextView.text
        canary["usuario"] = PFUser.currentUser()
        //canary["ciudad"] = coordsLBL.text
        
        canary.saveInBackground()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

    //Funciones del truqui del teclado
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
    }

    
    //MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
    
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }
    
    
}
