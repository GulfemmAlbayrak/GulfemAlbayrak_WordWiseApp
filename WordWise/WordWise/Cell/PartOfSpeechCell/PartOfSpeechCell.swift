//
//  PartOfSpeechCell.swift
//  WordWise
//
//  Created by Gülfem Albayrak on 30.05.2023.
//

import UIKit
import WordWiseAPI

class PartOfSpeechCell: UICollectionViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var partOfSpeechLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(meaning: Meaning) {
       partOfSpeechLbl.text = meaning.partOfSpeech
        
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
       }

}
