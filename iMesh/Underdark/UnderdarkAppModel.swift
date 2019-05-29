//
//  UnderdarkAppModel.swift
//  iMesh
//
//  Created by Sina Mirshafiei on 3/25/1397 AP.
//  Copyright © 1397 AP IAUCTB. All rights reserved.
//

import Foundation
class UnderdarkAppModel
{
    static var shared = UnderdarkAppModel()
    
    var node: Node!
    
    init()
    {
        
    }
    
    func configure()
    {
        
        node = Node()
    }
    
    
} // AppModel
