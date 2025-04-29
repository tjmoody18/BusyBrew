//
//  ReviewsTableViewCell.swift
//  BusyBrew
//
//  Created by Donald Thai on 4/22/25.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {

    var review: Review? {
        didSet {
            // Update the UI whenever review data is set
            updateUI()
        }
    }
    var displayName: String?
    let username = UILabel()
    let date = UILabel()
    let ratingStack = UILabel()
    let userComments = UILabel()
    let imageStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = background3
        setupCell()
        print("cell setup")
    }
    
    func updateUI() {
        username.text = review?.displayName
        date.text = review?.date
        ratingStack.text = "wifi availability: \(review?.wifi ?? 0)/5    cleanliness: \( review?.cleanliness ?? 0)/5    outlets availability: \(review?.outlets ?? 0)/5"
        userComments.text = review?.text
        
     
        imageStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if let review, review.photos.count > 0 {
            
            for photoUrlString in review.photos {
                let imageView = UIImageView()
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
                imageStack.addArrangedSubview(imageView)

                if let url = URL(string: photoUrlString) {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let error = error {
                            print("Failed to load image: \(error.localizedDescription)")
                            return
                        }
                        guard let data = data, let image = UIImage(data: data) else {
                            print("Failed to convert data to UIImage")
                            return
                        }
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }.resume()
                }
            }
        }
    }
    
    required init?(coder: NSCoder) { fatalError("not implemented") }
    
    private func setupCell() {
//        let reviewItem = UIStackView()
//        reviewItem.translatesAutoresizingMaskIntoConstraints = false
        username.translatesAutoresizingMaskIntoConstraints = false
        username.text = review?.displayName
        username.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
//        contentView.addSubview(reviewItem)
        
        date.translatesAutoresizingMaskIntoConstraints = false
        date.text = review?.date
        date.textColor = background1
        date.font = UIFont.systemFont(ofSize: 10, weight: .semibold)

        ratingStack.translatesAutoresizingMaskIntoConstraints = false
        ratingStack.font = UIFont.systemFont(ofSize: 8, weight: .semibold)
        ratingStack.numberOfLines = 2

        userComments.translatesAutoresizingMaskIntoConstraints = false
        userComments.text = review?.text
        userComments.font = UIFont.systemFont(ofSize: 10, weight: .regular)

        contentView.addSubview(username)
        contentView.addSubview(date)
        contentView.addSubview(ratingStack)
        contentView.addSubview(userComments)

        imageStack.translatesAutoresizingMaskIntoConstraints = false
        imageStack.axis = .horizontal
        imageStack.spacing = 10

        contentView.addSubview(imageStack)
        
        
        NSLayoutConstraint.activate([
           
            username.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            username.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            username.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            date.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 1),
            
            ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingStack.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 1),
            
            userComments.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userComments.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userComments.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 4),

            imageStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageStack.topAnchor.constraint(equalTo: userComments.bottomAnchor, constant: 8),
            imageStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4)
        ])
    }
}
