//
//  EscolhaPessoaTableViewCell.swift
//  CoreData
//
//  Created by Leonardo Koppe Malanski on 07/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit

class EscolhaPessoaTableViewCell: UITableViewCell {

    @IBOutlet weak var imagemPessoa: UIImageView!
    @IBOutlet weak var nomePessoa: UILabel!
    @IBOutlet weak var saldoPessoa: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
