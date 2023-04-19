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
        addSubview(noteImageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
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
        
        if let notes = user.notes, notes.count > 0{
            noteImageView.isHidden = false
        }else{
            noteImageView.isHidden = true
        }
        if let url = URL(string: user.avatarURL){
            user.imageLoader.loadImage(url) {[weak self] result in
                guard let self else {return}
                
                if let image = try? result.get(){
                    if indexPath.row % 4 == 3{
                        self.imageView.image = image.inverted()
                    }else{
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
    func updateAvatarImage(_ image: UIImage){
        imageView.image = image
    }
}
