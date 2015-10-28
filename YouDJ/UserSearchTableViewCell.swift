//
//  UserSearchTableViewCell.swift
//  YouDJ
//
//  Created by Soren Nelson on 9/23/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit

class UserSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    var user: User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWithUser(user: User) {
        self.user = user
        self.nameLabel.text = user.name
    }

    

}
