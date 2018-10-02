//
//  PhotoCell.swift
//  Tumblr
//
//  Created by Harold  on 11/20/17.
//  Copyright © 2017 Harold . All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
