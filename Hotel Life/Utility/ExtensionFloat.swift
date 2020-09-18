//
//  ExtensionFloat.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 12/12/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation

extension Float {
    func truncate(places : Int)-> Float
    {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places)))
    }
}
