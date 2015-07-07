//
//  ExtratoTableViewCell.swift
//  CoreData
//
//  Created by Leonardo Koppe Malanski on 07/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit

class ExtratoTableViewCell: UITableViewCell {


    @IBOutlet weak var valorTransacao: UILabel!
    @IBOutlet weak var dataTransacao: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
