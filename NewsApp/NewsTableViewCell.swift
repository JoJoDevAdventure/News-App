//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Youssef Bhl on 29/12/2021.
//

import UIKit

class NewsTableViewCellModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        subtitle: String,
        imageURL: URL?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImageView)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(x: 10,
                                      y: 0,
                                      width: contentView.frame.size.width - 170,
                                      height: 70)
        
        subTitleLabel.frame = CGRect(x: 10,
                                      y: 75,
                                      width: contentView.frame.size.width - 170,
                                      height: contentView.frame.size.height/2)
        
        newsImageView.frame = CGRect(x: contentView.frame.size.width-150,
                                      y: 5,
                                      width: 140,
                                     height: contentView.frame.size.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with ViewModel: NewsTableViewCellModel) {
        newsTitleLabel.text = ViewModel.title
        subTitleLabel.text = ViewModel.subtitle
        
        //image
        if let data = ViewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else if let url = ViewModel.imageURL {
            //fetch
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                ViewModel.imageData = data
                DispatchQueue.main.sync {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
}
