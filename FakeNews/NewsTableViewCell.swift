//
//  NewsTableViewCell.swift
//  FakeNews
//
//  Created by Alexandr Gerasimov on 06.01.2022.
//

import UIKit

class NewsTableViewCellViewModel{
    let title: String
    let subTitle: String
    let imageURL: URL?
    let articleURL: URL?
    var imageData: Data?
    init(
        title: String,
        subTitle: String,
        imageURL: URL?,
        articleURL: URL?
    ){
        self.title = title
        self.subTitle = subTitle
        self.imageURL = imageURL
        self.articleURL = articleURL
    }
}

class NewsTableViewCell: UITableViewCell {
    static let id = "NewsCell"
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    private let subTitleLabel: UILabel = {
       let label = UILabel()
        
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .secondarySystemBackground
        image.clipsToBounds = true
        image.layer.cornerRadius = 7
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
         fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 170,
            height:  70
        )
        subTitleLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width - 170,
            height:  contentView.frame.size.height/2
        )
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width - 150,
            y: 5,
            width: 140 ,
            height:  contentView.frame.size.height - 10
        )
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subTitleLabel.text = nil
        newsImageView.image = nil
    }
    func configure(with viewModel: NewsTableViewCellViewModel){
        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
        
        // Image
        if let data  = viewModel.imageData{
            newsImageView.image = UIImage(data: data)
        }else if let url  = viewModel.imageURL{
            URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
