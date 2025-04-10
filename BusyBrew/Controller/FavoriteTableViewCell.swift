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
        contentView.backgroundColor = background3
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        statusLabel.textColor = .black
        contentView.addSubview(statusLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        nameLabel.textColor = .black
        contentView.addSubview(nameLabel)
        
        cafeImage.translatesAutoresizingMaskIntoConstraints = false
        cafeImage.contentMode = .scaleAspectFill
        cafeImage.clipsToBounds = true
        cafeImage.layer.cornerRadius = 8
        contentView.addSubview(cafeImage)
        
        heartIcon.image = UIImage(systemName: "heart.fill")
        heartIcon.tintColor = .systemRed
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(heartIcon)
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            
            heartIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            heartIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            cafeImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            cafeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            cafeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cafeImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
     
    }
}
