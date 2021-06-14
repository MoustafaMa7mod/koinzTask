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
    @IBOutlet weak var pinLocationImage: UIImageView!
    @IBOutlet weak var noteImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(_ object: NoteObject){
        noteTitleLabel.text = object.noteTitle
        noteBodyLabel.text = object.noteBody
        if object.notePhoto != "" {
            if let image = UIImage().renderImageFromDocs(imageName: object.notePhoto) {
                noteImage.isHidden = false
                noteImage.image = image
            }else{
                noteImage.isHidden = true
            }
        }else{
            noteImage.isHidden = true
        }
                
        if  object.noteLongitude != 0.0 && object.noteLatitude != 0.0{
            pinLocationImage.isHidden = false
        }else{
            pinLocationImage.isHidden = true
        }
        
    }
    
}
