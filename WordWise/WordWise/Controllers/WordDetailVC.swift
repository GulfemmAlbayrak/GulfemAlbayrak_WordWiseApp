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
    @IBOutlet weak var wordTableView: UITableView!
    
    var word: String?
    let wordService: WordServiceProtocol = WordService()
    var meanings: [Meaning] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordLbl.text = word?.uppercased()
        configureTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let word = word {
            fetchWordData(word: word)
        }
    }
    private func configureTableView() {
            wordTableView.dataSource = self
            wordTableView.register(UINib(nibName: "WordDetailCell", bundle: nil), forCellReuseIdentifier: "WordDetailCell")
        }
    
    private func fetchWordData(word: String) {
            wordService.getWords(word: word) { [weak self] result in
                switch result {
                case .success(let wordElements):
                    if let wordElement = wordElements.first {
                        DispatchQueue.main.async {
                            self?.updateUI(with: wordElement)
                        }
                    }
                case .failure(let error):
                    print("API request error: \(error.localizedDescription)")
                }
            }
        }
        
        private func updateUI(with wordElement: WordElement) {
            phoneticLbl.text = wordElement.phonetics?.first?.text
            meanings = wordElement.meanings ?? []
            wordTableView.reloadData()
        }
    }

    extension WordDetailVC: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return meanings.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WordDetailCell", for: indexPath) as! WordDetailCell
            let meaning = meanings[indexPath.row]
            cell.configure(meaning: meaning)
            return cell
        }
    }
