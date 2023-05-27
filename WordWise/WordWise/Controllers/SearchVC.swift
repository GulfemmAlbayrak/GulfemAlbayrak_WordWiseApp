//
//  ViewController.swift
//  WordWise
//
//  Created by Gülfem Albayrak on 26.05.2023.
//

import UIKit
import WordWiseAPI

class SearchVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
//    let service: WordServiceProtocol = WordService()
//    var words: [WordElement] = []
    var words: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "RecentWordCell", bundle: nil), forCellReuseIdentifier: "RecentWordCell")
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let searchText = searchBar.text else { return }
                words.append(searchText)
                tableView.reloadData()
                
                let wordDetailVC = storyboard?.instantiateViewController(withIdentifier: "WordDetailVC") as! WordDetailVC
        wordDetailVC.word = searchText.lowercased()
                navigationController?.pushViewController(wordDetailVC, animated: true)
            }
}
    
    extension SearchVC: UITableViewDelegate, UITableViewDataSource  {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return words.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentWordCell", for: indexPath) as! RecentWordCell
            let word = words[indexPath.row]
            cell.configure(word: word)
            return cell
            
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //            let wordDetailVC = storyboard?.instantiateViewController(withIdentifier: "WordDetailVC") as! WordDetailVC
            //            let selectedWord = self.words[indexPath.row]
            //            wordDetailVC.selectedWord = selectedWord
            //            navigationController?.pushViewController(wordDetailVC, animated: true)
            
        }
    }
    

    
    


