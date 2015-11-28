//
//  ViewController.swift
//  Kaoyai
//
//  Created by Amorn Apichattanakul on 10/27/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import UIKit

class homeView: UIViewController {

    @IBOutlet weak var humid: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var tempNow: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let api = apiLoader()
        api.getDataAPI("tempnow.php") { (jsonData) -> () in
            print("test")
            print(jsonData)
            self.tempNow.text = (jsonData.valueForKey("now-temp") as! String)
            self.maxTemp.text = (jsonData.valueForKey("max-temp") as! String)
            self.minTemp.text = (jsonData.valueForKey("min-temp") as! String)
            self.humid.text = (jsonData.valueForKey("now-humid") as! String)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

