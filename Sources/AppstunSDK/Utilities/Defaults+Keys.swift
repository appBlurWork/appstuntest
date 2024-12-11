//
//  File.swift
//  
//
//  Created by Bora Erdem on 5.02.2024.
//

import Foundation
import Defaults

public extension Defaults.Keys {
    static let premium = Key<Bool>("premium", default: false)
    static let isLikedBefore = Key<Bool>("isLovedBefore", default: false)
    static let isBonusRatingSeen = Key<Bool>("isBonusRatingSeen", default: false)
}
