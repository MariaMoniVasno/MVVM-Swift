//
//  ShopifyTableViewCell.swift
//  Shopify
//
//  Created by Trident on 08/06/22.
//

import UIKit

class ShopifyTableViewCell: UITableViewCell {
    
    @IBOutlet var imgProduct : UIImageView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblDescription : UILabel!
    @IBOutlet var productImgHeightConstraint : NSLayoutConstraint!
    @IBOutlet var descriptionHeightConstraint : NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
