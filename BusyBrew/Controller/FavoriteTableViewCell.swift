//
//  FavoriteTableViewCell.swift
//  BusyBrew
//
//  Created by Grace Pan on 4/9/25.
//

import Foundation
import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    var cafeImage = UIImageView()
    var nameLabel = UILabel()
    var statusLabel = UILabel()
    let heartIcon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        cafeImage.translatesAutoresizingMaskIntoConstraints = false
        cafeImage.contentMode = .scaleAspectFill
        cafeImage.clipsToBounds = true
        cafeImage.layer.cornerRadius = 8
        contentView.addSubview(cafeImage)
        
        nameLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        heartIcon.contentMode = .scaleAspectFit
        heartIcon.image = UIImage(systemName: "heart.fill")
        heartIcon.tintColor = .red
        contentView.addSubview(heartIcon)
        
        NSLayoutConstraint.activate([
            cafeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cafeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cafeImage.widthAnchor.constraint(equalToConstant: 60),
            cafeImage.heightAnchor.constraint(equalToConstant: 60),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: cafeImage.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: heartIcon.leadingAnchor, constant: -8),

            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            statusLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),

            heartIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            heartIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            heartIcon.widthAnchor.constraint(equalToConstant: 20),
            heartIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
