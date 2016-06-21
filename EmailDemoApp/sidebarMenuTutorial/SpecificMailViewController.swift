//
//  SpecificMailViewController.swift
//  sidebarMenuTutorial
//
//  Created by Aggarwal, Nikhil on 6/16/16.
//  Copyright (c) 2016 Kenechi Okolo. All rights reserved.
//
import Foundation
import UIKit

class SpecificMailViewController: UIViewController {

   
    @IBOutlet var sender: UILabel!
    @IBOutlet var subject: UILabel!
    @IBOutlet var senderImg: UIImageView!
    @IBOutlet var senderDetails: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var messageBody: UILabel!
    var id : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        senderImg.layer.borderWidth=1.0
        senderImg.layer.masksToBounds = false
        senderImg.layer.borderColor = UIColor.whiteColor().CGColor
        senderImg.layer.cornerRadius = 13
        senderImg.layer.cornerRadius = senderImg.frame.size.height/2
        senderImg.clipsToBounds = true
      
        let newStr = String(format: "http://127.0.0.1:8088/%d", id)
        let request = NSURLRequest(URL: NSURL(string: newStr)!)
        
        // Perform the request
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response: NSURLResponse?, data: NSData?, error: NSError?)-> Void in
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    let tempArr = json.objectForKey("participants") as! NSArray
                    let tempDict : NSMutableDictionary! = [:]
                    tempDict.setObject(tempArr[0], forKey: 1)
                    var tempFinalDict : NSDictionary!
                    tempFinalDict  = tempDict.objectForKey(1) as! NSDictionary
                    self.sender.text = tempFinalDict["name"] as? String
                    self.senderDetails.text = tempFinalDict["email"] as? String
                    self.subject.text = json.objectForKey("subject") as? String
                    self.messageBody.text = json.objectForKey("body") as? String
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        });
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func deleteAction(sender: AnyObject) {
        
        let newStr = String(format: "http://127.0.0.1:8088/%d", id)
        let request = NSMutableURLRequest(URL: NSURL(string: newStr)!)
        request.HTTPMethod = "DELETE"
        // Perform the request
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response: NSURLResponse?, data: NSData?, error: NSError?)-> Void in
            self.performSegueWithIdentifier("delete", sender: self)
            }
        );
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "delete"
        {
//            if var destination = segue.destinationViewController as? SpecificMailViewController
//            {
//            }
        }
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
