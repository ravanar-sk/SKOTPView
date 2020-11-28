//
//  SKOTPView.swift
//  SKOTP
//
//  Created by RavaNar on 20/11/20.
//

import Foundation
import UIKit

typealias OTPItemView = UIView & SKOTPItemProtocol

@objc protocol SKOTPViewDelegate: class {
    func viewForIndex(_ index: Int) -> OTPItemView
    @objc optional func onCodeChange(_ code: String)
    @objc optional func onCodeComplete(_ code: String)
}

class SKOTPView: UIView {
    
    var textFieldOTP: UITextField!
    var stackViewLabels: UIStackView!
    private var arrayOTPItems: [OTPItemView] = []
    
    var numberOfDigits: Int = 6 {
        didSet {
            setUpViews()
        }
    }
    
    var itemSpacing: CGFloat = 10 {
        didSet {
            stackViewLabels.spacing = itemSpacing
        }
    }
    
    weak var delegate: SKOTPViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadDefaults()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        loadDefaults()
    }
    
    override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder() || textFieldOTP.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder() || textFieldOTP.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    
    
    private func loadDefaults() {
        
        textFieldOTP = UITextField(frame: .zero)
        self.addSubview(textFieldOTP)
        textFieldOTP.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldOTP.topAnchor.constraint(equalTo: self.topAnchor),
            textFieldOTP.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textFieldOTP.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textFieldOTP.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        textFieldOTP.delegate = self
        textFieldOTP.isHidden = true
        
        if #available(iOS 12.0, *) {
            textFieldOTP.textContentType = .oneTimeCode
        }
        
        
        stackViewLabels = UIStackView(frame: .zero)
        self.addSubview(stackViewLabels)
        stackViewLabels.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewLabels.topAnchor.constraint(equalTo: self.topAnchor),
            stackViewLabels.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackViewLabels.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackViewLabels.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        stackViewLabels.alignment = .fill
        stackViewLabels.spacing = 10
        stackViewLabels.distribution = .fillEqually
        
    }
    
    public func setText(_ text: String) {
        if text.count <= numberOfDigits {
            updateViewValues(text)
            textFieldOTP.text = text
        } else {
            updateViewValues("")
            textFieldOTP.text = ""
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension SKOTPView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return false }
        let newString = currentText.replacingCharacters(in: range, with: string)
        
        if newString.count <= numberOfDigits {
            updateViewValues(newString)
            self.delegate?.onCodeChange?(newString)
            
            if newString.count == numberOfDigits {
                self.delegate?.onCodeComplete?(newString)
            }
            
            return true
        }
        return false
    }
}

extension SKOTPView {
    
    private func setUpViews() {
        for index in 1...self.numberOfDigits {
            if let otpItem = self.delegate?.viewForIndex(index) {
                stackViewLabels.addArrangedSubview(otpItem)
                arrayOTPItems.append(otpItem)
            }
        }
        setText("")
    }
    
    private func updateViewValues(_ text: String) {
        let otpCharacters = Array(text)
        
        for index in 0 ..< numberOfDigits {
            if index < otpCharacters.count {
                arrayOTPItems[index].onChangeCharacter(String(otpCharacters[index]), false)
            } else if index > otpCharacters.count {
                arrayOTPItems[index].onChangeCharacter("", false)
            } else {
                arrayOTPItems[index].onChangeCharacter("", true)
            }
        }
    }
}
