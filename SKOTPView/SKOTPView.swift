//
//  SKOTPView.swift
//  SKOTP
//
//  Created by RavaNar on 20/11/20.
//

import Foundation
import UIKit

public typealias OTPItemView = UIView & SKOTPItemProtocol

@objc public protocol SKOTPViewDelegate: NSObjectProtocol {
    func viewForIndex(_ index: Int) -> OTPItemView
    func onCodeChange(_ code: String)
    func onCodeComplete(_ code: String)
}

public class SKOTPView: UIView {
    
    private var textFieldOTP: UITextField!
    private var stackViewLabels: UIStackView!
    
    var numberOfDigits: Int = 6
    
    var itemSpacing: CGFloat = 10 {
        didSet {
            stackViewLabels.spacing = itemSpacing
        }
    }
    
    @IBOutlet weak var delegate: SKOTPViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadDefaults()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        loadDefaults()
    }
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    public override func becomeFirstResponder() -> Bool {
        
        let selfBecomeResponder = super.becomeFirstResponder()
        let textFieldBecomeResponder = textFieldOTP.becomeFirstResponder()
        
        return selfBecomeResponder || textFieldBecomeResponder
    }
    
    public override var canResignFirstResponder: Bool {
        return true
    }
    
    public override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder() || textFieldOTP.resignFirstResponder()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = self.becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension SKOTPView: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let value = textField.text  else { return false }
        let previousCode = value as NSString
        
        let newCode = previousCode.replacingCharacters(in: range, with: string)
        
        if newCode.count <= numberOfDigits {
            updateViewValues(newCode)
            self.delegate?.onCodeChange(newCode)
            
            if newCode.count == numberOfDigits {
                self.delegate?.onCodeComplete(newCode)
            }
            
            return true
        }
        return false
    }
}

extension SKOTPView {
    
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
        
        textFieldOTP.keyboardType = .numberPad
        
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
    
    private func setUpViews() {
        
        for view in stackViewLabels.arrangedSubviews {
            stackViewLabels.removeArrangedSubview(view)
        }
        
        if let delegate = self.delegate, delegate.responds(to: #selector(SKOTPViewDelegate.viewForIndex(_:))) {
            for index in 0 ..< self.numberOfDigits {
                let otpItem = delegate.viewForIndex(index)
                stackViewLabels.addArrangedSubview(otpItem)
            }
        }
        
        setText("")
    }
    
    private func updateViewValues(_ text: String) {
        let otpCharacters = Array(text)
        
        guard let arrayViews = stackViewLabels.arrangedSubviews as? [OTPItemView], arrayViews.count > 0 && arrayViews.count <= numberOfDigits else { return }
        
        for index in 0 ..< numberOfDigits {
            if index < otpCharacters.count {
                arrayViews[index].onChangeCharacter(value: String(otpCharacters[index]), isNext: false)
            } else if index > otpCharacters.count {
                arrayViews[index].onChangeCharacter(value: "", isNext: false)
            } else {
                arrayViews[index].onChangeCharacter(value: "", isNext: true)
            }
        }
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
    
    public func reloadData() {
        setUpViews()
    }
}
