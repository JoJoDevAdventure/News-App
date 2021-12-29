//
//  ViewController.swift
//  NewsApp
//
//  Created by Youssef Bhl on 29/12/2021.
//

import UIKit
import SafariServices

// TableView
// Custom Cell
// API Call
// Open the News Story
// Search for News stories

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        title = "News"
        view.backgroundColor = .systemBackground
        
        APICaller.shared.getTopStoriees { [weak self] result in
            switch result {
            case .failure(let error) :
                print(error)
            case .success(let articles) :
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellModel(
                        title: $0.title,
                        subtitle: $0.description ?? "No description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                DispatchQueue.main.sync {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let articles = articles[indexPath.row]
        
        guard let url = URL(string: articles.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
