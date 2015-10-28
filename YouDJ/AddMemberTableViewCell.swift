//
//  AddMemberTableViewCell.swift
//  YouDJ
//
//  Created by Jordan Nelson on 9/14/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit

class AddMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var memberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWithUser(user: User) {
        
        memberLabel.text = "\(user.name)"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
