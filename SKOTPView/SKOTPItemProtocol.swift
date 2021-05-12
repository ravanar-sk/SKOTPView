//
//  SKOTPItemProtocol.swift
//  SKOTP
//
//  Created by RavaNar on 26/11/20.
//

import Foundation

@objc public protocol SKOTPItemProtocol {
    func onChangeCharacter( value: String, isNext: Bool) -> Void
}
