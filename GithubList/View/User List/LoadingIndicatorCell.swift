//
//  LoadingIndicatorCell.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 21/11/2022.
//

import UIKit

class LoadingIndicatorCell: UICollectionReusableView {
    
    private var loadingIndicator : UIActivityIndicatorView = {
        var view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    func setupLayout(){
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
        ])
    }
    
    func showIndicator(flag: Bool){
        loadingIndicator.isHidden = !flag
    }

    func startIndicatorAnimation(){
        loadingIndicator.startAnimating()
    }
    
    func stopIndicatorAnimation(){
        loadingIndicator.stopAnimating()
    }
    

}
