//
//  SKOTPItemProtocol.swift
//  SKOTP
//
//  Created by RavaNar on 26/11/20.
//

import Foundation

@objc public protocol SKOTPItemProtocol {
    func onChangeCharacter(_ value: String,_ isNext: Bool) -> Void
}
