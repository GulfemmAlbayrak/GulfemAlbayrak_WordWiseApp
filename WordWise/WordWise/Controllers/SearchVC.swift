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
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    
    var viewModel: SearchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        LoadingView.shared.configure()
        keyboardHiding()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisplay), name:UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name:UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    @objc func keyboardWillDisplay(notification: Notification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomConstraints.constant = keyboardHeight - 30
        }
    }
    
    @objc func keyboardHide(){
        bottomConstraints.constant = 0
    }
    
    private func keyboardHiding(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(keyboardRemove))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardRemove(){
        view.endEditing(true)
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
                    wordDetailVC.viewModel.wordElement = wordElement
                    wordDetailVC.viewModel.synonyms = self?.viewModel.synonyms ?? []
                    wordDetailVC.viewModel.partOfSpeechSet = Set(self?.viewModel.meanings.compactMap({ $0.partOfSpeech }) ?? [])
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
    
