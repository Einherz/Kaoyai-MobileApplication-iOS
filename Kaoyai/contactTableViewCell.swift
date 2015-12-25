//
//  contactTableViewCell.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 12/15/2558 BE.
//  Copyright © 2558 Amorn Apichattanakul. All rights reserved.
//

import UIKit

class contactTableViewCell: UITableViewCell {

    @IBOutlet var colourV: UIView!
    @IBOutlet var ctName: UILabel!
    @IBOutlet var ctPosition: UILabel!
    @IBOutlet var ctNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func callContact(sender: AnyObject) {
        
        print("call : \(self.ctNumber.text)")
        
        if let number = NSURL(string: "tel://\(self.ctNumber.text)") {
            print("IF")
            UIApplication.sharedApplication().openURL(number)
        }
    }
}
