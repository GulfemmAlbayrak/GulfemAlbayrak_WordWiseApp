//
//  WordDetailVC.swift
//  WordWise
//
//  Created by Gülfem Albayrak on 26.05.2023.
//

import UIKit
import WordWiseAPI

class WordDetailVC: UIViewController, LoadingShowable {
    
    @IBOutlet weak var wordLbl: UILabel!
    @IBOutlet weak var phoneticLbl: UILabel!
    @IBOutlet weak var wordTableView: UITableView!
    @IBOutlet weak var synonymCollectionView: UICollectionView!
    
    var wordElement: WordElement?
    var viewModel: WordDetailViewModel = WordDetailViewModel()
    var synonyms: [SynWordElement] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideLoading()
        if let word = wordElement?.word {
            wordLbl.text = word.uppercased()
            configureTableView()
            configureCollectionView()
            if let wordElement = wordElement {
                configure(with: wordElement) // configure methodunu burada çağırıyoruz
            }
            updateUI(with: wordElement!)
        }
    }
  
    private func configureTableView() {
        wordTableView.dataSource = self
        wordTableView.register(UINib(nibName: "WordDetailCell", bundle: nil), forCellReuseIdentifier: "WordDetailCell")
    }
    
    private func configureCollectionView() {
        synonymCollectionView.dataSource = self
        synonymCollectionView.register(UINib(nibName: "SynonymCell", bundle: nil), forCellWithReuseIdentifier: "SynonymCell")
    }
    
    private func configure(with wordElement: WordElement) {
        phoneticLbl.text = wordElement.phonetics?.first?.text
        viewModel.meanings = wordElement.meanings ?? []
        wordTableView.reloadData()
    }

        
    private func updateUI(with wordElement: WordElement) {
        phoneticLbl.text = wordElement.phonetics?.first?.text
        wordTableView.reloadData()
        synonymCollectionView.reloadData()
    }

}

extension WordDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.meanings.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordDetailCell", for: indexPath) as! WordDetailCell
        let meaning = viewModel.meanings[indexPath.row]
        cell.configure(meaning: meaning)
        return cell
    }
}

extension WordDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return synonyms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SynonymCell", for: indexPath) as! SynonymCell
        let synonym = synonyms[indexPath.item]
        cell.configure(synonym: synonym)
        return cell
    }
}
    
