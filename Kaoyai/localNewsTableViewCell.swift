//
//  localNewsTableViewCell.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 12/14/2558 BE.
//  Copyright © 2558 Amorn Apichattanakul. All rights reserved.
//

import UIKit

class localNewsTableViewCell: UITableViewCell {

    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var newsDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
