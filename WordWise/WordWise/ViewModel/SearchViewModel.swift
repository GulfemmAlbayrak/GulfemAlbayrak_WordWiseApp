////
////  SearchViewModel.swift
////  WordWise
////
////  Created by Gülfem Albayrak on 27.05.2023.
////
//
//import Foundation
//import WordWiseAPI
//
//protocol SearchViewModelProtocol {
//    var delegate: SearchViewModelDelegate? { get set }
//    var searchText: String { get set }
//    var numberOfItems: Int { get }
//    func word(_ index: Int) -> WordElement?
//    func fetchData()
//}
//protocol SearchViewModelDelegate: AnyObject {
//    func reloadData()
//}
//
//final class SearchViewModel {
//    private var words: [WordElement] = []
//    let service: WordServiceProtocol
//    internal var searchText: String = ""
//    
//    weak var delegate: SearchViewModelDelegate?
//    
//    init(service: WordServiceProtocol) {
//        self.service = service
//    }
//    fileprivate func fetchWord() {
//        service.getWords(word: searchText) { [weak self] result in
//            switch result {
//            case .success(let words):
//                
//                self?.words.append(contentsOf: words)
//                DispatchQueue.main.async {
//                    self?.delegate?.reloadData()
//                }
//            case .failure(let error):
//                print("Search error: \(error)")
//                // Hata durumunu kullanıcıya bildirebilirsiniz
//            }
//        }
//    }
//}
//extension SearchViewModel: SearchViewModelProtocol {
//    func word(_ index: Int) -> WordElement? {
//        words[index]
//    }
//    
//    var numberOfItems: Int {
//        words.count
//    }
//    
//    
//    func fetchData() {
//        fetchWord()
//    }
//    
//    
//}
