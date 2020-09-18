//
//  StringExtension.swift
//  Hotel Life
//
//  Created by Adil Mir on 2/1/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import Foundation
extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
//    func removeSpecialCharsFromString() -> String {
//        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
//        return self.filter {okayChars.contains($0) }
//    }
    
    func removeSpecialCharsFromString() -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        return String(self.characters.filter {okayChars.contains($0) })
    }
}

extension String {

    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
        return self.filter {okayChars.contains($0) }
    }
}
