//
//  CanaryTableViewCell.swift
//  Canary
//
//  Created by Alberto Tocados on 4/7/16.
//  Copyright © 2016 ATL. All rights reserved.
//

import UIKit

class CanaryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var thumbPic: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
