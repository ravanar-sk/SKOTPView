//
//  SKOTPItemCircle.swift
//  SKOTPView
//
//  Created by RavaNar on 13/05/21.
//

import UIKit

public class SKOTPItemCircle: UIView {
    var labelTitle: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func draw(_ rect: CGRect) {
        // Drawing code
        
        let cornerRadius: CGFloat = rect.width < rect.height ? rect.width : rect.height / 2
        self.layer.cornerRadius = cornerRadius
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
        self.clipsToBounds = true
    }
}

extension SKOTPItemCircle: SKOTPItemProtocol {
    
    public func onChangeCharacter(value: String, isNext: Bool) {
        self.layer.borderColor = value.count > 0 ? UIColor.darkGray.cgColor : UIColor.lightGray.cgColor
        
        labelTitle.text = value
    }
    
}
