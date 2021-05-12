//
//  SKOTPItemSquare.swift
//  SKOTP
//
//  Created by RavaNar on 26/11/20.
//

import UIKit

public class SKOTPItemSquare: UIView {
    var labelTitle: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }

    private func setUpViews() {

        labelTitle = UILabel()
        labelTitle.textAlignment = .center
        labelTitle.font = UIFont.systemFont(ofSize: 22, weight: .medium)

        labelTitle.text = ""

        self.addSubview(labelTitle)
        
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: self.topAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }

        
}

extension SKOTPItemSquare: SKOTPItemProtocol {
    
    public func onChangeCharacter(value: String, isNext: Bool) {
        self.layer.borderColor = value.count > 0 ? UIColor.darkGray.cgColor : UIColor.lightGray.cgColor
        
        labelTitle.text = value
    }
    
}


