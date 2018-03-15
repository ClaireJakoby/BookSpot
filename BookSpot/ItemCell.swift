//
//  ItemCell.swift
//  BookSpot
//
//  Created by MacBook on 2/16/16.
//  Copyright © 2016 Clair&Sida. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var bookImageView: PFImageView!
    
    func updateLabels() {
        
        let caption1Font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        locationLabel.font = caption1Font
    }
    
}
