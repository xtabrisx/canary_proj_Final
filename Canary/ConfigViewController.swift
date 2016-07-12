//
//  ConfigViewController.swift
//  Canary
//
//  Created by Alberto Tocados on 4/7/16.
//  Copyright © 2016 ATL. All rights reserved.
//

import UIKit
import Parse

class ConfigViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    
    
    
    
    @IBOutlet weak var profilePic: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var usuarioActual = PFUser.currentUser()
        var query = PFQuery(className:"profilePic")
        query.whereKey("usuario", equalTo: usuarioActual!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("El usuario tiene \(objects!.count) imágenes.")
                // Do something with the found objects
                if let objects = objects {
                    print(objects.last?.objectId)
                    //self.profilePic.image = objects.last!["profilePic"] as? UIImage
                    let profile:PFFile = (objects.last!["profilePic"] as? PFFile)!
                    profile.getDataInBackgroundWithBlock({ (ImageData, error) in
                        if error == nil{
                            
                            let Image:UIImage = UIImage(data: ImageData!)!
                            self.profilePic.image = Image
                            
                            //Cropear la imagen?
                            //De momento la giramos porque sale tumbada. Inexplicablemente los ¿grados? del giro son 33 y no 90... absurdo.
                            self.profilePic.transform = CGAffineTransformMakeRotation(33)
                            
                            
                        }else{
                            print(error)
                        }
                    })
                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

        // Do any additional setup after loading the view.
    }

 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
        self.profilePic.transform = CGAffineTransformMakeRotation(0)
        
    }
    
    @IBAction func uploadPhoto(sender: AnyObject) {
        
        if profilePic.image == nil{
            print("No hay imagen")
        }else{
            var imagenPerfil = PFObject(className: "profilePic")
            imagenPerfil["usuario"] = PFUser.currentUser()
            imagenPerfil.saveInBackgroundWithBlock({ (success, error) in
                if error == nil{
                    //creamos el image data
                    var imageData = UIImagePNGRepresentation(self.profilePic.image!)
                    
                    //creamos el archivo parse
                    var parseImageFile = PFFile(name:"profile_pic.png", data: imageData!)
                    imagenPerfil["profilePic"] = parseImageFile
                    imagenPerfil.saveInBackgroundWithBlock({ (success, error) in
                        if error == nil{
                            print("Imagen subida")
                        }else{
                            print(error)
                        }
                    })
                    
                    
                    
                    
                }else{
                    print(error)
                }
            })
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])  {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        profilePic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOut()
        //Vamos a la pantalla de Login
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
        self.presentViewController(viewController, animated: true, completion: nil)

        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


