//
//  WordDetailVC.swift
//  WordWise
//
//  Created by Gülfem Albayrak on 26.05.2023.
//

import UIKit
import WordWiseAPI

class WordDetailVC: UIViewController {
    
    @IBOutlet weak var wordLbl: UILabel!
    @IBOutlet weak var phoneticLbl: UILabel!
    
    var word: String?
    let wordService: WordServiceProtocol = WordService()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordLbl.text = word
        if let word = word {
            fetchWordData(word: word)
        }
    }
    
    private func fetchWordData(word: String) {
        wordService.getWords(word: word) { [weak self] result in
            switch result {
            case .success(let words):
                if let wordData = words.first {
                    DispatchQueue.main.async {
                        self?.updateUI(with: wordData)
                    }
                }
            case .failure(let error):
                print("API request error: \(error.localizedDescription)")
            }
        }
    }
        
    private func updateUI(with wordData: WordElement) {
        // Update the UI elements with the data from wordData
        phoneticLbl.text = wordData.phonetics?.first?.text
    }
}
