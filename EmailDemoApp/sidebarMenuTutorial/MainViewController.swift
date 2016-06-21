//
//  MainViewController.swift
//  sidebarMenuTutorial
//
//  Created by Aggarwal, Nikhil on 6/15/16.
//  Copyright (c) 2016 Nikhil Aggarwal. All rights reserved.
//
import Foundation
import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet var slideBtn: UIButton!
    @IBOutlet var mailTableView: UITableView!
    var indexNo : Int = 0
    var messageArray : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            slideBtn.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let request = NSURLRequest(URL: NSURL(string: "http://127.0.0.1:8088/")!)
        
        // Perform the request
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response, data, error)-> Void in
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray {
                        self.messageArray = json
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }

            self.mailTableView.delegate = self
            self.mailTableView.dataSource = self
            dispatch_async(dispatch_get_main_queue(),
            {
                    self.mailTableView.reloadData()
            })
        }
       );
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        // Dispose of any resources that can be recreated.
    }
    
//    // MARK: - Table view data source
//    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return messageArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("mail", forIndexPath: indexPath) as UITableViewCell
        var mailDict : NSDictionary!
        mailDict  = self.messageArray[indexPath.row] as! NSDictionary
        let newLabel = UILabel(frame: CGRectMake(15, 10.0, 600.0, 15.0))
        let newLabel2 = UILabel(frame: CGRectMake(15, 30.0, 600.0, 15.0))
        let newLabel3 = UILabel(frame: CGRectMake(15, 45.0, 600.0, 15.0))
        newLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
        newLabel2.font = UIFont(name: "Avenir", size: 13.0)
        newLabel3.font = UIFont(name: "Helvetica Neue", size: 10.0)
        newLabel.textColor = UIColor.blackColor()
        newLabel2.textColor = UIColor.brownColor()
        newLabel3.textColor = UIColor.darkGrayColor()
        newLabel.font = UIFont.italicSystemFontOfSize(13)
        
        let tempArr = mailDict.objectForKey("participants") as! NSArray
        newLabel.text = tempArr[0] as? String
        newLabel2.text = mailDict.objectForKey("subject") as? String
        newLabel3.text = mailDict.objectForKey("preview") as? String
        headerCell.addSubview(newLabel)
        headerCell.addSubview(newLabel2)
        headerCell.addSubview(newLabel3)

        return headerCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexDict : NSDictionary!  = self.messageArray[indexPath.row] as! NSDictionary
        indexNo = indexDict.objectForKey("id") as! Int
        self.performSegueWithIdentifier("clickedMail", sender: self)
    }

     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "clickedMail"
        {
            let destination = segue.destinationViewController as! SpecificMailViewController
            destination.id = indexNo
        }
    }
  
//
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 61.0
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
