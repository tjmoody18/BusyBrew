//
//  FriendsTableViewCell.swift
//  BusyBrew
//
//  Created by Donald Thai on 4/21/25.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    let profilePicture: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = background3
        setupCell()
    }
    required init?(coder: NSCoder) { fatalError("not implemented") }
    
    private func setupCell() {
        contentView.addSubview(profilePicture)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            // Avatar
            profilePicture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            profilePicture.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profilePicture.widthAnchor.constraint(equalToConstant: 50),
            profilePicture.heightAnchor.constraint(equalToConstant: 50),
            profilePicture.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            profilePicture.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            // Name
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        
        // Make it circular
        profilePicture.layer.cornerRadius = 25
    }
}
