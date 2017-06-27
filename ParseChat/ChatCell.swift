//
//  ChatCell.swift
//  ParseChat
//
//  Created by John Abreu on 6/26/17.
//  Copyright © 2017 John Abreu. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var sender: UILabel!
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
