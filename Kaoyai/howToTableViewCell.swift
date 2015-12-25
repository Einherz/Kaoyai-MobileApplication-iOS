//
//  howToTableViewCell.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 12/14/2558 BE.
//  Copyright © 2558 Amorn Apichattanakul. All rights reserved.
//

import UIKit

class howToTableViewCell: UITableViewCell {

    @IBOutlet var topic: UILabel!
    @IBOutlet var htIcon: UIImageView!
    @IBOutlet var htImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
