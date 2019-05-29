//
//  Chat.swift
//  iMesh
//
//  Created by Sina Mirshafiei on 3/14/1397 AP.
//  Copyright © 1397 AP IAUCTB. All rights reserved.
//

import Foundation


class Chat {
    var frequencyName : String
    var messages : [Message]
    var peers : [String]
    
    init(frequencyName : String ) {
        self.frequencyName = frequencyName
        self.messages = []
        self.peers = []
    }
}

class Message : NSObject, NSCoding {
    var id : String
    var text : String
    var peerName : String
    var isItMyMsg : Bool
    var time : Date
    
    init(id : String , text : String , peerName :String , isItMyMsg : Bool , time : Date) {
        self.id = id
        self.text = text
        self.peerName = peerName
        self.isItMyMsg = isItMyMsg
        self.time = time
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let text = aDecoder.decodeObject(forKey: "text") as! String
        let peerName = aDecoder.decodeObject(forKey: "peerName") as! String
        let isItMyMsg = aDecoder.decodeBool(forKey: "isItMyMsg")
        let time = aDecoder.decodeObject(forKey: "time") as! Date
        
        self.init(id: id, text: text, peerName: peerName, isItMyMsg: isItMyMsg, time: time)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(text, forKey: "text")
        aCoder.encode(peerName, forKey: "peerName")
        aCoder.encode(isItMyMsg, forKey: "isItMyMsg")
        aCoder.encode(time, forKey: "time")
    }
}
