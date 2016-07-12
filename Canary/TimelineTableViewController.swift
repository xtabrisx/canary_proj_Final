//
//  TimelineTableViewController.swift
//  Canary
//
//  Created by Alberto Tocados on 4/7/16.
//  Copyright © 2016 ATL. All rights reserved.
//

import UIKit
import Parse

class TimelineTableViewController: UITableViewController {

    var timelineData:NSMutableArray = NSMutableArray()
    
    func loadData(){
        
        timelineData.removeAllObjects()
        
        var findTimeLineData:PFQuery = PFQuery(className: "Canary")
        
        findTimeLineData.findObjectsInBackgroundWithBlock { (objects, error) in
            if (error == nil){
                for object:PFObject in objects!{
                    self.timelineData.addObject(object)
                }
                
                let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                //self.timelineData = array as! NSMutableArray
                
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.loadData()
        
        super.viewDidAppear(true)
        if ((PFUser.currentUser() == nil)){
          print("NO USER")
            //Vamos a la pantalla de Login
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login") 
            self.presentViewController(viewController, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timelineData.count
    }

    
    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CanaryTableViewCell = tableView!.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CanaryTableViewCell

      
        let canary:PFObject = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        //Autor del mensaje
        var findUser:PFQuery = PFUser.query()!
        findUser.whereKey("objectId", equalTo: (canary.objectForKey("usuario")?.objectId)!)
        findUser.findObjectsInBackgroundWithBlock { (objects, error) in
            if error == nil{
                let user:PFUser = (objects! as NSArray).lastObject as! PFUser
                cell.nameLBL.text = user.username
                print(user.objectId!)
                
                
                
            }
        }
        
        ////////////////////////////
        //Imagen perfilUsuario
        
        var queryImagen = PFQuery(className:"profilePic")
        queryImagen.whereKey("usuario", equalTo:canary.objectForKey("usuario")!)
        
        queryImagen.findObjectsInBackgroundWithBlock { (objects, error) in
            if error == nil{
                print("IT WORKS")
                print(objects!.count)
                
                if let objects = objects {
                    print(objects.last?.objectId)
                    //self.profilePic.image = objects.last!["profilePic"] as? UIImage
                    let profile:PFFile = (objects.last!["profilePic"] as? PFFile)!
                    profile.getDataInBackgroundWithBlock({ (ImageData, error) in
                        if error == nil{
                            
                            let Image:UIImage = UIImage(data: ImageData!)!
                            cell.thumbPic.image = Image
                            
                            //Cropear la imagen?
                            //De momento la giramos porque sale tumbada. Inexplicablemente los ¿grados? del giro son 33 y no 90... absurdo.
                            cell.thumbPic.transform = CGAffineTransformMakeRotation(33)
                            
                            
                        }else{
                            print(error)
                        }
                    })
                    
                }

                
            }else{
                print("ERROR")
                
            }
        }
        
        
        ////////////////////////////////////////////////
        

        
        //Contenido del mensaje
        let content = canary["content"] as! String
        cell.messageTV.text = content
        //Fecha del mensaje
        var dataFormatter:NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.dateLBL.text = dataFormatter.stringFromDate(canary.createdAt!)
        
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
