//
//  mapDetailView.swift
//  Kaoyai
//
//  Created by Amorn Apichattanakul on 11/12/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import WebKit

class mapDetailView:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var imgV: UIImageView!
    @IBOutlet var contentV: UIView!
    @IBOutlet var topicL: UILabel!
    @IBOutlet var btnsView: UIView!
    @IBOutlet var placeBt: UIButton!
    @IBOutlet var howToBtn: UIButton!
    
    var imgPath: NSString!
    var contentString: NSString!
    var topicS: NSString!
    var webView: WKWebView!
    var howToDet = [Howto]()
    var tableView: UITableView!
    var slideView: UIView = UIView()
    
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayDetails:", name: "DisplaySpotlightSearch", object: nil)

        
//        let url = NSURL(string: String(self.imgPath))
        
        let url = NSURL(string:self.pathForIdentifier(self.imgPath as String, folder: "Map"))
        
        print("img path: \(url?.path)")
        
        if let data = NSData(contentsOfFile: (url?.path)!) {
            self.imgV.image = UIImage(data: data)
        }
        
        self.webView = WKWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width-12, UIScreen.mainScreen().bounds.size.height-self.contentV.frame.origin.y))
        self.contentV.addSubview(self.webView)
        self.webView!.loadHTMLString(self.contentString as String, baseURL: nil)
        self.webView.scrollView.showsHorizontalScrollIndicator = false
        self.webView.scrollView.showsVerticalScrollIndicator = false
        
        print("webview: \(self.webView)")
        print("web content: \(self.webView.subviews)")
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width+8, UIScreen.mainScreen().bounds.size.height-self.imgV.frame.size.height-self.btnsView.frame.size.height-4), style: UITableViewStyle.Plain)
        self.tableView.registerNib(UINib(nibName: "howToTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.hidden = true
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 180.0
        self.contentV.addSubview(self.tableView)
        
        self.topicL.text = String(topicS)
        
        self.btnsView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.btnsView.layer.shadowOpacity = 0.5
        self.btnsView.layer.shadowColor = UIColor.darkGrayColor().CGColor
        
        self.slideView.backgroundColor = UIColor(red: 0.506, green: 0.765, blue: 0.275, alpha: 1)
        self.slideView.frame = CGRectMake(10, self.btnsView.frame.size.height-2, (UIScreen.mainScreen().bounds.width/2)-20, 2)
        self.btnsView.addSubview(self.slideView)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: String(topicS))
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject:AnyObject])
    }
    
    func displayDetails(notification: NSNotification) {
        
        if notification.userInfo!["objType"] as! String == "Howto" {
            
            self.performSegueWithIdentifier("toHowTo2", sender: notification.object)
            
        }else{
            
            print("YAY!!! I'm map")
            
            let obj = notification.object as! Map
            
            let url = NSURL(string:self.pathForIdentifier(obj.image!, folder: "Map"))
            
            if let data = NSData(contentsOfFile: (url?.path)!) {
                self.imgV.image = UIImage(data: data)
            }
            
            self.webView!.loadHTMLString(obj.content!, baseURL: nil)
            self.topicL.text = obj.title
            self.howToDet.removeAll()
            
            if obj.howto != nil {
                self.howToDet = obj.howto?.allObjects as! [Howto]
            }
        }
    }
    
    @IBAction func goBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func buttonPressed(sender: UIButton!) {
        
        sender.setTitleColor(UIColor(red: 0.506, green: 0.765, blue: 0.275, alpha: 1), forState: UIControlState.Normal)
        
        if sender.tag == 101 {
            
            self.howToBtn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
            
            if self.webView.hidden {
                
                self.webView.hidden = false
            }
            
            if !self.tableView.hidden {
                
                self.tableView.hidden = true
            }
            self.slideView.frame = CGRectMake(10, self.btnsView.frame.size.height-2, (UIScreen.mainScreen().bounds.width/2)-20, 2)
            
        }else if sender.tag == 102 {
            
            self.placeBt.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
            
            if !self.webView.hidden {
                
                self.webView.hidden = true
            }
            
            if self.tableView.hidden {
                
                self.tableView.hidden = false
            }
            self.slideView.frame = CGRectMake((UIScreen.mainScreen().bounds.width/2)+10, self.btnsView.frame.size.height-2, (UIScreen.mainScreen().bounds.width/2)-20, 2)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return howToDet.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! howToTableViewCell
        let howTo = howToDet[indexPath.row]
        
        cell.topic.text = howTo.topics
        
        print("type: \(howTo.type)")
        
        if howTo.type == 1 {
            
            cell.htIcon.image = UIImage(named: "personG")
            
        }else if howTo.type == 2 {
            
            cell.htIcon.image = UIImage(named: "animalG")
            
        }else if howTo.type == 3 {
            
            cell.htIcon.image = UIImage(named: "stopG")
            
        }else if howTo.type == 4 {
            
            cell.htIcon.image = UIImage(named: "eventG")
        }
        
        if howTo.image != nil {
            
            let url = NSURL(string:self.pathForIdentifier(howTo.image!, folder: "Howto"))
            if let data = NSData(contentsOfFile: (url?.path)!) {
                
                cell.htImg.image = UIImage(data: data)
                
            }else{
                cell.htImg.image = nil;
            }
        }else{
            cell.htImg.image = nil;
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("toHowTo", sender: indexPath);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toHowTo" {
            
            let howToC = howToDet[(sender as! NSIndexPath).row]
            let destView = segue.destinationViewController as! howtoDetailView
            
            print(howToC)
            
            destView.contentDet = howToC.content! as NSString
            destView.imgPath = howToC.image!
            destView.titleS = howToC.topics!
        
        }else if (segue.identifier == "toHowTo2") {
            
            let destView = segue.destinationViewController as! howtoDetailView
            let howTo = sender as! Howto
            
            destView.contentDet = howTo.content! as NSString
            destView.imgPath = howTo.image!
            destView.titleS = howTo.topics!
            
        }
    }
    
    func pathForIdentifier(identifier: String, folder:String) -> String {
        let documentsDirectoryURL:NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)[0] as NSURL
        
        let urlPath = documentsDirectoryURL.absoluteString
        let filefolder = urlPath.stringByAppendingString("/"+folder)
        let folderPath = documentsDirectoryURL.URLByAppendingPathComponent(folder)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(filefolder){
            do{
                try  NSFileManager.defaultManager().createDirectoryAtPath(folderPath.path!, withIntermediateDirectories: true, attributes: nil)
            } catch {
//                print("Problem at Create Folder : \(error.localizedDescription)")
            }
        }
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(folder+"/"+identifier)
        
        return fullURL.path!
    }
}