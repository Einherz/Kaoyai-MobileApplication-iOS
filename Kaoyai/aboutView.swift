//
//  aboutView.swift
//  Kaoyai
//
//  Created by Amorn Apichattanakul on 11/12/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation

class aboutView:UIViewController{
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayDetails:", name: "DisplaySpotlightSearch", object: nil)
        
        super.viewDidLoad()
        
//        self.tabBarController?.tabBar.barTintColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "About")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject:AnyObject])
    }
    
    func displayDetails(notification: NSNotification) {
        
        if notification.userInfo!["objType"] as! String == "Howto" {
            
            self.performSegueWithIdentifier("toHowTo", sender: notification.object)
            
        }else{
            
            self.performSegueWithIdentifier("toMap", sender: notification.object)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toHowTo") {
            
            let destView = segue.destinationViewController as! howtoDetailView
            let howTo = sender as! Howto
            
            destView.contentDet = howTo.content! as NSString
            destView.imgPath = howTo.image!
            destView.titleS = howTo.topics!
            
        }else if (segue.identifier == "toMap") {
            
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