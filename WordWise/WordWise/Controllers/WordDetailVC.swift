//
//  WordDetailVC.swift
//  WordWise
//
//  Created by Gülfem Albayrak on 26.05.2023.
//

import UIKit
import WordWiseAPI
import AVFoundation


class WordDetailVC: UIViewController, LoadingShowable {
    
    @IBOutlet weak var wordLbl: UILabel!
    @IBOutlet weak var phoneticLbl: UILabel!
    @IBOutlet weak var wordTableView: UITableView!
    @IBOutlet weak var synonymCollectionView: UICollectionView!
    @IBOutlet weak var speakerButton: UIButton!
    
    var viewModel: WordDetailViewModel = WordDetailViewModel()
    var wordElement: WordElement?
    var synonyms: [SynWordElement] = []
    var player: AVAudioPlayer!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideLoading()
        if let word = wordElement?.word {
            wordLbl.text = word.lowercased().capitalized
            configureTableView()
            configureCollectionView()
            if let wordElement = wordElement {
                configure(with: wordElement) // configure methodunu burada çağırıyoruz
            }
            updateUI(with: wordElement!)
            toggleSpeakerButton()
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
        viewModel.synonyms = synonyms
        wordTableView.reloadData()
    }

        
    private func updateUI(with wordElement: WordElement) {
        phoneticLbl.text = wordElement.phonetics?.first?.text
        wordTableView.reloadData()
        synonymCollectionView.reloadData()
    }
    @IBAction func audioButton(_ sender: Any) {
        guard let phonetics = wordElement?.phonetics, !phonetics.isEmpty,
              let audioURLString = phonetics[0].audio, !audioURLString.isEmpty,
              let audioURL = URL(string: audioURLString) else {
            return
        }
        print("audioURLString: \(audioURLString)")
        print("audioURL: \(audioURL)")
        playAudioFromURL(audioURL)
    }

    private func playAudioFromURL(_ audioURL: URL) {
        let session = URLSession.shared
        let request = URLRequest(url: audioURL)
        
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                print("Failed to play audio: \(error)")
                return
            }
            
            guard let data = data else {
                print("Failed to get audio data")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    self?.player = try AVAudioPlayer(data: data)
                    self?.player.prepareToPlay()
                    self?.player.play()
                } catch {
                    print("Failed to play audio: \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    private func toggleSpeakerButton() {
        if let phonetics = wordElement?.phonetics, !phonetics.isEmpty,
           let audioURLString = phonetics[0].audio, !audioURLString.isEmpty {
            speakerButton.isHidden = false
        } else {
            speakerButton.isHidden = true
        }
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
        return min(5,viewModel.synonyms.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SynonymCell", for: indexPath) as! SynonymCell
        let synonym = viewModel.synonyms[indexPath.item]
        cell.configure(synonym: synonym)
        return cell
    }
}
    
