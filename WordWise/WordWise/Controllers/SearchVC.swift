//
//  ViewController.swift
//  WordWise
//
//  Created by Gülfem Albayrak on 26.05.2023.
//

import UIKit
import CoreData

class SearchVC: UIViewController, LoadingShowable {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    
    var viewModel: SearchViewModel = SearchViewModel()
    var words: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        LoadingView.shared.configure()
        keyboardHiding()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisplay), name:UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name:UIResponder.keyboardWillHideNotification , object: nil)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSavedWords()
        tableView.reloadData()
    }
    
    //MARK: -SearchButton Location
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
    
    //MARK: -TableView configure method
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "RecentWordCell", bundle: nil), forCellReuseIdentifier: "RecentWordCell")
    }
    
    //MARK: -Core Data
    
    func addWord(_ word: String) {
        // remove the word from list
        if let index = words.firstIndex(of: word) {
            words.remove(at: index)
            tableView.reloadData()
        }
        
        // add the new word to the beginning of the list
        words.insert(word, at: 0)
        tableView.reloadData()
        
        // add core data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Search the word in core data and delete if its in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
        fetchRequest.predicate = NSPredicate(format: "word == %@", word)
        
        do {
            let existingWords = try context.fetch(fetchRequest)
            for existingWord in existingWords as! [NSManagedObject] {
                context.delete(existingWord)
            }
            
            // add the new word
            let newWord = NSEntityDescription.insertNewObject(forEntityName: "Words", into: context)
            newWord.setValue(word, forKey: "word")
            
            try context.save()
        } catch {
            print("Kelime kaydedilemedi...")
        }
        
        fetchSavedWords()
        searchBar.text = ""
   }
    
    func fetchSavedWords() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
        
        do {
            let results = try context.fetch(fetchRequest)
            if let words = results as? [NSManagedObject] {
                self.words = words.compactMap { $0.value(forKey: "word") as? String }.reversed()
                tableView.reloadData()
            } else {
                //No data case
            }
        } catch {
            print("Veri çekilemedi: \(error.localizedDescription)")
        }
        
    }
    
    //MARK: -Fetching Data and Synonyms
    
    private func fetchWordData(for word: String) {
        viewModel.fetchWordDataAndSynonyms(word: word) { [weak self] result in
            switch result {
            case .success(let wordElement):
                DispatchQueue.main.async {
                    let wordDetailVC = self?.storyboard?.instantiateViewController(withIdentifier: "WordDetailVC") as! WordDetailVC
                    
                    if let phonetic = wordElement.phonetic {
                        wordDetailVC.viewModel.phonetic = phonetic
                    } else if let firstNonEmptyPhonetic = wordElement.phonetics?.first(where: { $0.text != nil && !$0.text!.isEmpty }) {
                        if let phoneticText = firstNonEmptyPhonetic.text {
                            wordDetailVC.viewModel.phonetic = phoneticText
                            print("A")
                        } else {
                            wordDetailVC.viewModel.phonetic = "Yok"
                            print("B")
                        }
                    } else {
                        wordDetailVC.viewModel.phonetic = "Yok"
                    }
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
    
    //MARK: -SearchButton Action
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let searchText = searchBar.text, !searchText.isEmpty, !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        addWord(searchText)
        tableView.reloadData()
        
        showLoading()
        fetchWordData(for: searchText)
  }
}
    
extension SearchVC: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(5, words.count)
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentWordCell", for: indexPath) as! RecentWordCell
        let word = words[indexPath.row]
        cell.configure(word: word)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWord = words[indexPath.row]
        fetchWordData(for: selectedWord)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
    
