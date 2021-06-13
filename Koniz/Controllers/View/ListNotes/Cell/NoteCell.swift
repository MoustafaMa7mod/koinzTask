//
//  NoteCell.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/13/21.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteBodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
