//
//  WordDetailVC.swift
//  WordWise
//
//  Created by Gülfem Albayrak on 26.05.2023.
//

import UIKit
import AVFoundation

class WordDetailVC: UIViewController, LoadingShowable {
    
    @IBOutlet weak var wordLbl: UILabel!
    @IBOutlet weak var phoneticLbl: UILabel!
    @IBOutlet weak var wordTableView: UITableView!
    @IBOutlet weak var synonymCollectionView: UICollectionView!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var partOfSpeechCollectionView: UICollectionView!
    @IBOutlet weak var synonymsTitle: UILabel!
    
    var viewModel: WordDetailViewModel = WordDetailViewModel()
    var player: AVAudioPlayer!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideLoading()
        
        if let word = viewModel.wordElement?.word {
            wordLbl.text = word.lowercased().capitalized
            configureTableView()
            configureCollectionView()
            
            if viewModel.wordElement != nil {
                configure(with: viewModel)
            }
            toggleSpeakerButton()
        }
    }
  
    //MARK: -Configure methods
    
    private func configureTableView() {
        wordTableView.dataSource = self
        wordTableView.register(UINib(nibName: "WordDetailCell", bundle: nil), forCellReuseIdentifier: "WordDetailCell")
        wordTableView.reloadData()
    }
    
    private func configureCollectionView() {
        synonymCollectionView.dataSource = self
        synonymCollectionView.register(UINib(nibName: "SynonymCell", bundle: nil), forCellWithReuseIdentifier: "SynonymCell")
        partOfSpeechCollectionView.dataSource = self
        partOfSpeechCollectionView.register(UINib(nibName: "PartOfSpeechCell", bundle: nil), forCellWithReuseIdentifier: "PartOfSpeechCell")
        
        if let flowLayout = partOfSpeechCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 20)
            partOfSpeechCollectionView.reloadData()
        }
        
        if viewModel.synonyms.count == 0 {
            synonymCollectionView.isHidden = true
            synonymsTitle.isHidden = true
        } else {
            synonymCollectionView.isHidden = false
            synonymsTitle.isHidden = false
        }
    }
    
    private func configure(with viewModel: WordDetailViewModel) {
        guard let phonetics = viewModel.wordElement?.phonetics, !phonetics.isEmpty else {
            phoneticLbl.text = ""
            return  viewModel.meanings = viewModel.wordElement?.meanings ?? []
        }

        var validPhoneticText: String? = nil

        for phonetic in phonetics {
            if let text = phonetic.text, !text.isEmpty {
                validPhoneticText = text
                viewModel.meanings = viewModel.wordElement?.meanings ?? []
                break
            }
        }

        if let validText = validPhoneticText {
            phoneticLbl.text = validText
        } else {
            phoneticLbl.text = "N/A"
        }
        viewModel.meanings = viewModel.wordElement?.meanings ?? []

    }

    //MARK: -Audio
    
    @IBAction func audioButton(_ sender: Any) {
        guard let phonetics = viewModel.wordElement?.phonetics, !phonetics.isEmpty else {
            return
        }
        
        var audioURL: URL? = nil
        
        for phonetic in phonetics {
            if let audioURLString = phonetic.audio, !audioURLString.isEmpty {
                audioURL = URL(string: audioURLString)
                break
            }
        }
        
        if let audioURL = audioURL {
            print("audioURL: \(audioURL)")
            playAudioFromURL(audioURL)
        }
        
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
    
    //MARK: -Speaker Button
    
    private func toggleSpeakerButton() {
        guard let phonetics = viewModel.wordElement?.phonetics else {
            speakerButton.isHidden = true
            return
        }
        
        var hasAudio = false
        
        for phonetic in phonetics {
            if let audioURLString = phonetic.audio, !audioURLString.isEmpty {
                hasAudio = true
                break
            }
        }
        
        speakerButton.isHidden = !hasAudio
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

extension WordDetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == synonymCollectionView {
            return min(5, viewModel.synonyms.count)
        } else if collectionView == partOfSpeechCollectionView {
            return viewModel.partOfSpeechSet.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == synonymCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SynonymCell", for: indexPath) as! SynonymCell
            let synonym = viewModel.synonyms[indexPath.item]
            cell.configure(synonym: synonym)
            return cell
        } else if collectionView == partOfSpeechCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartOfSpeechCell", for: indexPath) as! PartOfSpeechCell
            let partOfSpeechString = Array(viewModel.partOfSpeechSet)[indexPath.item]
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            if let meaning = viewModel.meanings.first(where: { $0.partOfSpeech == partOfSpeechString }) {
                cell.configure(meaning: meaning)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == partOfSpeechCollectionView {
            let availableWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right
            let sideInset = max((availableWidth ) / 2, 0)
            return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        }
        
        return UIEdgeInsets.zero
    }
}


