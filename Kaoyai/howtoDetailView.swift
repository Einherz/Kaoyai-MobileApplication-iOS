//
//  howtoDetailView.swift
//  Kaoyai
//
//  Created by Amorn Apichattanakul on 11/12/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import WebKit

class howtoDetailView:UIViewController, UINavigationBarDelegate{
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var contentV: UIView!
    @IBOutlet var imgHeight: NSLayoutConstraint!
    @IBOutlet var backB: UIButton!
    var contentDet: NSString = ""
    var imgPath: NSString?
    var webView: WKWebView!
    var titleS: String = ""
    var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayDetails:", name: "DisplaySpotlightSearch", object: nil)
        
        print("test 2:")
        print(contentDet)
        
        print("img path: \(self.imgPath)")
        
        if imgPath == nil {
            
            navBar = UINavigationBar(frame: CGRectMake(0,0,self.view.frame.size.width,60))
            navBar.backgroundColor = UIColor.redColor()
            navBar.delegate = self
            
            let navItems = UINavigationItem()
            navItems.title = "Title"
            
            let backB = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Done, target: self, action:"goBack")
            navItems.leftBarButtonItem = backB
            
            navBar.items = [navItems]
            
            self.view.addSubview(navBar)
            
            self.imgHeight.constant = 60
            
            self.backB.hidden = true
        
        }else{
            
            print("ELSE")
            
            print("path: \(self.pathForIdentifier(self.imgPath as! String, folder: "HowTo"))")
            
            let url = NSURL(string:self.pathForIdentifier(self.imgPath as! String, folder: "HowTo"))
            if let data = NSData(contentsOfFile: url!.path!) {
                
                self.imageView.image = UIImage(data: data)
            
            }else{
                
                navBar = UINavigationBar(frame: CGRectMake(0,0,self.view.frame.size.width,60))
                navBar.backgroundColor = UIColor.redColor()
                navBar.delegate = self
                
                let navItems = UINavigationItem()
                navItems.title = "Title"
                
                let backB = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Done, target: self, action:"goBack")
                navItems.leftBarButtonItem = backB
                
                navBar.items = [navItems]
                
                self.view.addSubview(navBar)
                
                self.imgHeight.constant = 60
                
                self.backB.hidden = true
            }
        }
        
        self.webView = WKWebView(frame: CGRectMake(8, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height-self.imgHeight.constant))
        self.contentV.addSubview(self.webView)
        self.webView!.loadHTMLString(self.contentDet as String, baseURL: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: titleS as String)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject:AnyObject])
    }
    
    func displayDetails(notification: NSNotification) {
        
        if notification.userInfo!["objType"] as! String == "Howto" {
            
            print("YAY!!! I'm how to")
            
            let obj = notification.object as! Howto
            
            if obj.image == nil {
                
                if !self.view.subviews.contains(self.navBar) {
                    
                    print("IF")
                    
                    let navBar = UINavigationBar(frame: CGRectMake(0,0,self.view.frame.size.width,60))
                    navBar.backgroundColor = UIColor.redColor()
                    navBar.delegate = self
                    
                    let navItems = UINavigationItem()
                    navItems.title = "Title"
                    
                    let backB = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Done, target: self, action:"goBack")
                    navItems.leftBarButtonItem = backB
                    
                    navBar.items = [navItems]
                    
                    self.view.addSubview(navBar)
                    
                    self.imgHeight.constant = 60
                    
                    self.backB.hidden = true
                }
                
            }else{
                
                print("ELSE")
                
                print("path: \(self.pathForIdentifier(obj.image!, folder: "HowTo"))")
                
                let url = NSURL(string:self.pathForIdentifier(obj.image!, folder: "HowTo"))
                if let data = NSData(contentsOfFile: url!.path!) {
                    
                    self.imageView.image = UIImage(data: data)
                    
                    if self.navBar != nil {
                       
                        self.navBar.removeFromSuperview()
                        self.imgHeight.constant = 200
                        self.backB.hidden = false
                    }
                    
                }else{
                    
                    if !self.view.subviews.contains(self.navBar) {
                        
                        let navBar = UINavigationBar(frame: CGRectMake(0,0,self.view.frame.size.width,60))
                        navBar.backgroundColor = UIColor.redColor()
                        navBar.delegate = self
                        
                        let navItems = UINavigationItem()
                        navItems.title = "Title"
                        
                        let backB = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Done, target: self, action:"goBack")
                        navItems.leftBarButtonItem = backB
                        
                        navBar.items = [navItems]
                        
                        self.view.addSubview(navBar)
                        
                        self.imgHeight.constant = 60
                        
                        self.backB.hidden = true
                    }
                }
            }
            
            self.webView!.loadHTMLString(obj.content!, baseURL: nil)
            
        }else{
            
            self.performSegueWithIdentifier("toMap", sender: notification.object)
        }
    }
    
    func goBack(){
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func goBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toMap") {
            
            let mapC = sender as! Map
            let destView = segue.destinationViewController as! mapDetailView
            
            print("mapC: " + String(mapC))
            
            print("mapC how to: " + String(mapC.howto?.allObjects))
            
            destView.contentString = mapC.content
            destView.imgPath = mapC.image
            destView.topicS = mapC.title
            
            print(mapC.howto?.allObjects)
            
            if mapC.howto != nil {
                destView.howToDet = mapC.howto?.allObjects as! [Howto]
            }
        }
    }
}