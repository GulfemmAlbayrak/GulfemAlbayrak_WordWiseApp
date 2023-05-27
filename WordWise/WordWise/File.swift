//
//  File.swift
//  WordWise
//
//  Created by Gülfem Albayrak on 27.05.2023.
//

import Foundation
 
/*
guard let searchText = textField.text?.lowercased(), !searchText.isEmpty else {
        return
    }
    
    service.getWords(word: searchText) { [weak self] result in
        guard let self = self else { return }
        
        switch result {
        case .success(let wordElements):
            self.words.append(contentsOf: wordElements)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            // Check if there are any words
            if !wordElements.isEmpty {
                // Pass the selected word to WordDetailVC
                let wordDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "WordDetailVC") as! WordDetailVC
                wordDetailVC.selectedWord = wordElements.first
                
                self.navigationController?.pushViewController(wordDetailVC, animated: true)
            }
        case .failure(let error):
            // Error handling
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // Clear the text field
    textField.text = ""
*/

/*
    extension SearchVC: UITableViewDelegate, UITableViewDataSource  {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return words.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentWordCell", for: indexPath) as! RecentWordCell
            let wordResult = self.words[indexPath.row]
            cell.configure(words: wordResult)
            return cell
        }


        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let wordDetailVC = storyboard?.instantiateViewController(withIdentifier: "WordDetailVC") as! WordDetailVC
            let selectedWord = self.words[indexPath.row]
            wordDetailVC.word = selectedWord
            navigationController?.pushViewController(wordDetailVC, animated: true)
            
        }
    }



 if let recentWord = wordElements.first?.word {
     let recentWordElement = WordElement(from: recentWord as! Decoder)
     self.words.append(recentWordElement)
     DispatchQueue.main.async {
         self.tableView.reloadData()
     }
 }
 */
