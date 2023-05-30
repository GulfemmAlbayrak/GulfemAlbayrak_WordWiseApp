//
//  SynonymCell.swift
//  WordWise
//
//  Created by Gülfem Albayrak on 28.05.2023.
//

import UIKit
import WordWiseAPI

class SynonymCell: UICollectionViewCell {

    @IBOutlet weak var synonymLabel: UILabel!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(synonym: SynWordElement) {
        synonymLabel.text = synonym.word
        
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
       }
    }

