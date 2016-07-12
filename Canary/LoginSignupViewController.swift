//
//  LoginSignupViewController.swift
//  Canary
//
//  Created by Alberto Tocados on 4/7/16.
//  Copyright © 2016 ATL. All rights reserved.
//

import UIKit
import Parse

class LoginSignupViewController: UIViewController {

    
    @IBOutlet weak var loginSignupSelector: UISegmentedControl!
   
    @IBOutlet weak var userTF: UITextField!
    
    @IBOutlet weak var passTF: UITextField!
    
    @IBOutlet weak var logoCanary: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        logoCanary.layer.cornerRadius = logoCanary.frame.size.width/2
        logoCanary.clipsToBounds = true
        
        //Ocultar el teclado al hacer tap fuera
        self.hideKeyboardWhenTappedAround()
        
        //Truqui del teclado
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)


        
    }

    

    @IBAction func signupOrLogin(sender: AnyObject) {
        
        var camposVacios = false
        
        if userTF.text != "" && passTF != ""{
            camposVacios = true
            
            //SI LOS CAMPOS NO ESTÁN VACÍOS
            
            if loginSignupSelector.selectedSegmentIndex == 0 {
                
                print("Estamos en login")
                
                PFUser.logInWithUsernameInBackground(userTF.text!, password:passTF.text!) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        print("logado con éxito")
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Timeline")
                        self.presentViewController(viewController, animated: true, completion: nil)
                    } else {
                        print(error)
                        //Presentamos un error de login al usuario
                        let alertLogin = UIAlertController(title: "Login Error", message: "Wrong username or password", preferredStyle: .Alert)
                        alertLogin.addAction(UIAlertAction(title: "Close", style: .Default, handler: nil))
                        self.presentViewController(alertLogin, animated: true, completion: nil)
                        
                        
                    }
                }
                
                
            }else{
                
                var user = PFUser()
                user.username = userTF.text
                user.password = passTF.text
                let imageDef:UIImage = UIImage(named: "spiral.png")!
                let imageData = UIImagePNGRepresentation(imageDef)
                let imageFile = PFFile(name: "spiral.png", data: imageData!)
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if let error = error {
                        let errorString = error.userInfo["error"] as? NSString
                        print(error)
                        //Presentamos un error de login al usuario
                        let alertSignup = UIAlertController(title: "Signup Error", message: "Error creating your user: \(error)", preferredStyle: .Alert)
                        alertSignup.addAction(UIAlertAction(title: "Close", style: .Default, handler: nil))
                        self.presentViewController(alertSignup, animated: true, completion: nil)
                    } else {
                        print("REGISTRADO CON ÉXITO")
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Timeline")
                        self.presentViewController(viewController, animated: true, completion: nil)
                        let usuarioActual = PFUser.currentUser()
                        print(usuarioActual)
                        //Creamos una imagen por defecto para evitar que pete!
                        var newUserDefaultPic = PFObject(className: "profilePic")
                        newUserDefaultPic["usuario"] = PFUser.currentUser()
                        newUserDefaultPic["profilePic"] = imageFile
                        newUserDefaultPic.saveInBackground()
                    }
                }
                
                
                print("Estamos en signup")
                
            }

            
            
        }else{
            //ALERT
            print("Los campos están vacíos, no hacemos nada")
            
            let alertVacios = UIAlertController(title: "Empty fields!", message: "One or more fields are empty, please, fill them in!", preferredStyle: .Alert)
            alertVacios.addAction(UIAlertAction(title: "Close", style: .Default, handler: nil))
            self.presentViewController(alertVacios, animated: true, completion: nil)
            
        }
        
        
        
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
    
    
}

//Dismiss del teclado
    
    extension UIViewController {
        func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
            view.addGestureRecognizer(tap)
        }
        
        func dismissKeyboard() {
            view.endEditing(true)
        }
    }
