//
//  MyMSGTableViewCell.swift
//  iMesh
//
//  Created by Sina Mirshafiei on 3/13/1397 AP.
//  Copyright © 1397 AP IAUCTB. All rights reserved.
//

import UIKit

class MyMSGTableViewCell: UITableViewCell {

    @IBOutlet weak var myMsgTxt: DesignableLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
