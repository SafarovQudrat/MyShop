//
//  ProfileTVC.swift
//  MyShop
//
//  Created by Qudrat on 15/05/25.
//

import UIKit

class ProfileTVC: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!{
        didSet{
            nameLbl.font = .customFont(.regular, 17)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
