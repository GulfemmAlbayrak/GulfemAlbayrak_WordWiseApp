//
//  ViewController.swift
//  WordWise
//
//  Created by Gülfem Albayrak on 26.05.2023.
//

import UIKit

class SearchVC: UIViewController, LoadingShowable {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    var viewModel: SearchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        LoadingView.shared.configure()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "RecentWordCell", bundle: nil), forCellReuseIdentifier: "RecentWordCell")
    }
    
    private func fetchWordData(for word: String) {
        viewModel.fetchWordDataAndSynonyms(word: word) { [weak self] result in
            switch result {
            case .success(let wordElement):
                DispatchQueue.main.async {
                    let wordDetailVC = self?.storyboard?.instantiateViewController(withIdentifier: "WordDetailVC") as! WordDetailVC
                    wordDetailVC.wordElement = wordElement
                    wordDetailVC.synonyms = self?.viewModel.synonyms ?? []
                    //wordDetailVC.delegate = self
                    self?.navigationController?.pushViewController(wordDetailVC, animated: true)
               }
            case .failure(let error):
                let alertController = UIAlertController(title: "Uyarı", message: "Sonuç bulunamadı.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Tamam", style: .default) { _ in
                    self?.navigationController?.popViewController(animated: true)
                    self?.hideLoading()
                }
                alertController.addAction(okAction)
                self?.present(alertController, animated: true, completion: nil)
                print("API request error: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let searchText = searchBar.text else { return }
        viewModel.addWord(searchText)
        tableView.reloadData()
        searchBar.text = ""
        showLoading()
        fetchWordData(for: searchText)
    }
}
    
extension SearchVC: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(5, viewModel.words.count)
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentWordCell", for: indexPath) as! RecentWordCell
        let word = viewModel.words[indexPath.row]
        cell.configure(word: word)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWord = viewModel.words[indexPath.row]
        fetchWordData(for: selectedWord)
    }
}
    
