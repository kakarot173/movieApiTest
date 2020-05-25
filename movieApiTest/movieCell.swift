//
//  movieCell.swift
//  movieAssignment
//
//  Created by Animesh Mohanty on 25/05/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import Kingfisher
import TinyConstraints
class movieCell: UICollectionViewCell, SelfConfiguringCell  {
    
    static let reuseIdentifier: String = "MovCell"
    

    fileprivate let imageApiBaseUrl = "https://image.tmdb.org/t/p/w342"
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 22
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor.init(white: 0.3, alpha: 0.8)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = UIColor.init(white: 0.3, alpha: 0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private func setupView() {
    
//        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        backgroundColor = UIColor(white: 1, alpha: 0.6)
        clipsToBounds = true
        
        addSubview(posterImageView)
        addSubview(activityIndicatorView)

        posterImageView.edgesToSuperview(excluding: .trailing, insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
               posterImageView.size(CGSize(width: 100, height: 100))
               
        activityIndicatorView.center(in: posterImageView)
        
        let innerStackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        
        innerStackView.axis = .vertical
        innerStackView.spacing = 15
        
        innerStackView.distribution = .fill
        innerStackView.alignment = .leading
        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(innerStackView)
      
      innerStackView.leadingToTrailing(of: posterImageView, offset: 8)

        innerStackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10).isActive = true
        innerStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor,constant:-108).isActive = true

        
    }
    
    func configure(with item: detail) {
        if let str = item.poster_path{
            let imageUrl = "\(imageApiBaseUrl)\(str)"
            if let url = URL(string: imageUrl) {
                let resource = ImageResource(downloadURL: url)
                self.posterImageView.kf.setImage(with: resource, placeholder: nil, options: nil, progressBlock: nil) { (result: Result<RetrieveImageResult, KingfisherError>) in
                    switch result {
                    case .success(_):
                        self.activityIndicatorView.stopAnimating()
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
            }
        }
        

        nameLabel.text = item.title
        descriptionLabel.text = item.overview
    }
    
}
