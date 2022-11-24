//
//  UserCell.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 21/11/2022.
//

import UIKit

class UserCell: UICollectionViewCell {
    var uuid = UUID()
    
    var imageView : UIImageView = {
        var imageView = UIImageView()
        imageView.frame = CGRect(x: 10, y: 21, width: 57, height: 57)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    var nameLabel : UILabel = {
        var text = UILabel()
        text.frame = CGRect(x: 87, y: 27.5, width: 182, height: 24)
        text.text = "Text"
        text.numberOfLines = 1
        text.textAlignment = .left
        text.font = UIFont(name: ".AppleSystemUIFont", size: 15)
        return text
    }()
//    var detailLabel : UILabel = {
//        var text = UILabel()
//        text.frame = CGRect(x: 87, y: 49.5, width: 182, height: 20)
//        text.text = "Text"
//        text.numberOfLines = 2
//        text.textAlignment = .left
//        text.font = UIFont(name: ".AppleSystemUIFont", size: 12)
//        return text
//    }()
    var noteImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.frame = CGRect(x: 236, y: 35.5, width: 28, height: 28)
        imageView.image = UIImage(named: "notes")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    
    // MARK: Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        layer.cornerRadius = 5
        backgroundColor = UIColor.white
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.4
        
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        
        addSubview(imageView)
        addSubview(nameLabel)
//        addSubview(detailLabel)
        addSubview(noteImageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        noteImageView.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, constant: 0),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        
        ])
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 0),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        
        ])
//        NSLayoutConstraint.activate([
//            detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -2),
//            detailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 0),
//            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//
//        ])
        NSLayoutConstraint.activate([
            noteImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            noteImageView.widthAnchor.constraint(equalToConstant: 20),
            noteImageView.widthAnchor.constraint(equalTo: noteImageView.heightAnchor, constant: 0),
            noteImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        
        ])
        
    }
    
    // MARK: Configure Cell
    
    func configure(user: UserCellViewModel, indexPath: IndexPath){
        imageView.image = UIImage(named: "emptyImage.jpg")
        nameLabel.text = user.loginName
        
        if let notes = user.notes{
            noteImageView.isHidden = false
        }else{
            noteImageView.isHidden = true
        }
        if let avatarURL = user.avatarURL, let url = URL(string: avatarURL){
            if indexPath.row % 4 == 3{
                imageView.loadImage(for: url, invertedColor: true)
            }else{
                imageView.loadImage(for: url)
            }
        }
    }
}
