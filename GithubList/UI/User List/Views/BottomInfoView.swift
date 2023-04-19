//
//  BottomInfoView.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 23/11/2022.
//

import UIKit

///An info view that can be attached to the bottom of a view, such as to display no internet connection info.
class BottomInfoView: UIView, CAAnimationDelegate {
    var infoLabel : UILabel = {
        var text = UILabel()
        text.frame = CGRect(x: 0, y: 12.5, width: 238, height: 24)
        text.text = "Info"
        text.numberOfLines = 2
        text.textAlignment = .center
        text.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        text.textColor = UIColor.white
        return text
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
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
    }
    
    func showInfo(_ info: String, in view: UIView, color: UIColor) {
        var animate = false
        
        infoLabel.text = info
        backgroundColor = color
        if self.superview != view{
            animate = true
        }
        view.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            self.heightAnchor.constraint(equalToConstant: 80),
        ])
        
        //Animate the info view from bottom
        if animate{
            let anim      = CABasicAnimation(keyPath:"transform")
            anim.fromValue = NSValue(caTransform3D: CATransform3DMakeTranslation(0, 100, 0))
            anim.toValue  = NSValue(caTransform3D: CATransform3DIdentity)
            anim.timingFunction = CAMediaTimingFunction(name:.easeInEaseOut)
            anim.duration = 0.3
            self.layer.add(anim, forKey: "transformIn")
        }
    }
    
    func hideInfo() {
        guard let superview = self.superview else{
            return
        }
        
        CATransaction.begin()
        let anim      = CABasicAnimation(keyPath:"transform")
        anim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        anim.toValue  = NSValue(caTransform3D: CATransform3DMakeTranslation(0, 100, 0))
        anim.timingFunction = CAMediaTimingFunction(name:.easeInEaseOut)
        anim.duration = 0.3
        anim.delegate = self
        self.layer.add(anim, forKey: "transformOut")
        
        CATransaction.setCompletionBlock{ [weak self] in
            self?.removeFromSuperview()
        }
        
        CATransaction.commit()
    }
    
    

}
