//
//  ViewController.swift
//  FakeNews
//
//  Created by Alexandr Gerasimov on 06.01.2022.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private let tableView: UITableView = {
         let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.id)
        return table
    }()
    private let searchVC = UISearchController(searchResultsController: nil)
    
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FakeNews"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchTopNews()
        createSearchBar()
    }
    // Fetching top news
    private func fetchTopNews(){
        NetworkManager.instance.getTopNews(completion: {[weak self]result in
            switch result{
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles
                    .compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subTitle: $0.description ?? "",
                        imageURL: URL(string: $0.urlToImage ?? ""),
                        articleURL: URL(string: $0.url ?? ""))
                }
                )
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error) :
                print(error)
            
            }
        })
    }
    // SearchBar
    private func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
        
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.id,
            for: indexPath
        )as? NewsTableViewCell else{
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article =  articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else{
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    // Search func
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        NetworkManager.instance.searchNews(with: text) {[weak self]result in
            switch result{
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles
                    .compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subTitle: $0.description ?? "",
                        imageURL: URL(string: $0.urlToImage ?? ""),
                        articleURL: URL(string: $0.url ?? ""))
                }
                )
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchVC.dismiss(animated: true, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
                }
            case .failure(let error) :
                print(error)
            
            }
        }
        print(text)
    }
    
}

