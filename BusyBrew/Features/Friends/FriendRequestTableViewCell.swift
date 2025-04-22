//
//  FriendRequestTableViewCell.swift
//  BusyBrew
//
//  Created by Nabil Chowdhury on 4/21/25.
//
import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let acceptButton = UIButton(type: .system)
    let denyButton = UIButton(type: .system)

    var onAccept: (() -> Void)?
    var onDeny: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        backgroundColor = background3
        selectionStyle = .none

        // Profile Image
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "cafe.png")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        // Name & Email
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        emailLabel.font = .systemFont(ofSize: 14, weight: .regular)
        nameLabel.textColor = .black
        emailLabel.textColor = .darkGray
        nameLabel.numberOfLines = 1
        emailLabel.numberOfLines = 1

        let textStack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.alignment = .leading

        // Buttons
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.backgroundColor = .systemGreen
        acceptButton.layer.cornerRadius = 12
        acceptButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        acceptButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        acceptButton.addTarget(self, action: #selector(didTapAccept), for: .touchUpInside)

        denyButton.setTitle("Deny", for: .normal)
        denyButton.setTitleColor(.white, for: .normal)
        denyButton.backgroundColor = .systemRed
        denyButton.layer.cornerRadius = 12
        denyButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        denyButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        denyButton.addTarget(self, action: #selector(didTapDeny), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [acceptButton, denyButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually

        // Combine Text + Buttons
        let verticalContent = UIStackView(arrangedSubviews: [textStack, buttonStack])
        verticalContent.axis = .vertical
        verticalContent.spacing = 8
        verticalContent.alignment = .leading

        let mainStack = UIStackView(arrangedSubviews: [profileImageView, verticalContent])
        mainStack.axis = .horizontal
        mainStack.spacing = 16
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(name: String, email: String) {
        nameLabel.text = name
        emailLabel.text = email
    }

    @objc func didTapAccept() {
        onAccept?()
    }

    @objc func didTapDeny() {
        onDeny?()
    }
}
