//
//  MessageCell.swift
//  LetGoMVVM
//
//  Created by Ümit Örs on 29.01.2024.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
