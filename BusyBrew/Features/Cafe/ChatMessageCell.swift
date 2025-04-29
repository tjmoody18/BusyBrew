//
//  ChatMessageCell.swift
//  BusyBrew
//
//  Created by Nabil Chowdhury on 4/22/25.
//
import UIKit

class ChatMessageCell: UITableViewCell {
    let nameLabel = UILabel()
    let messageLabel = UILabel()
    let timeLabel = UILabel()
    let bubbleBackground = UIView()

    var isIncoming: Bool = true {
        didSet {
            bubbleBackground.backgroundColor = isIncoming
                ? UIColor(white: 0.90, alpha: 1)
                : UIColor.systemBlue
            messageLabel.textColor = isIncoming ? .black : .white
            nameLabel.textColor    = isIncoming ? .darkGray : .white
            timeLabel.textColor    = isIncoming ? .gray    : .white
            updateConstraintsForSide()
        }
    }

    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupViews() {
        selectionStyle = .none
        bubbleBackground.layer.cornerRadius = 16
        bubbleBackground.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleBackground)

        nameLabel.font = .boldSystemFont(ofSize: 13)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackground.addSubview(nameLabel)

        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackground.addSubview(messageLabel)

        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackground.addSubview(timeLabel)

        bubbleBackground.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75).isActive = true
        NSLayoutConstraint.activate([
            bubbleBackground.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            nameLabel.topAnchor.constraint(equalTo: bubbleBackground.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: bubbleBackground.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: bubbleBackground.trailingAnchor, constant: -12),

            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleBackground.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleBackground.trailingAnchor, constant: -12),

            timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: bubbleBackground.leadingAnchor, constant: 12),
            timeLabel.trailingAnchor.constraint(equalTo: bubbleBackground.trailingAnchor, constant: -12),
            timeLabel.bottomAnchor.constraint(equalTo: bubbleBackground.bottomAnchor, constant: -8)
        ])
    }

    private func updateConstraintsForSide() {
        leftConstraint?.isActive = false
        rightConstraint?.isActive = false
        leftConstraint  = bubbleBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        rightConstraint = bubbleBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

        if isIncoming {
            leftConstraint?.isActive = true
        } else {
            rightConstraint?.isActive = true
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        messageLabel.text = nil
        timeLabel.text = nil
    }
}
