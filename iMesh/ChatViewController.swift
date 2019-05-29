//
//  ChatViewController.swift
//  iMesh
//
//  Created by Sina Mirshafiei on 3/13/1397 AP.
//  Copyright © 1397 AP IAUCTB. All rights reserved.
//

import UIKit
import ISEmojiView
import Underdark


class ChatViewController: UIViewController,ISEmojiViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    
    //MARK: properties
    var mChat : Chat?
    //var chatServiceManager : ChatServiceManager!
    var node : Node!
    
    
    //MARK: view outlets
    
    @IBOutlet weak var msgTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var msgBox: UITextField!
    @IBOutlet weak var emojiBtn: UIImageView!
    @IBOutlet weak var peersCountLabel: DesignableLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //for showing chat box above keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        msgBox.delegate = self
        
        msgTableView.delegate = self
        msgTableView.dataSource = self
        
        if mChat == nil{
            mChat = Chat(frequencyName: "Default")
        } else {
            msgTableView.reloadData()
            updateTableContentInset()
        }
        updateTableContentInset()

        
 //       chatServiceManager = ChatServiceManager()
 //       chatServiceManager.delegate = self
        
        
        node = UnderdarkAppModel.shared.node
        node.delegate = self
        node.start()
        if node.peersCount == 0 {
            navigationController?.popViewController(animated: true)
        } else {
            peersCountLabel.text = "\(node.peersCount)"
        }
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        node.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        msgBox.delegate = self
    }
    
    
    
    //MARK: show chat box above keyboard
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    //MARK: Actions
    
    
    @IBAction func backBtn(_ sender: Any) {
        //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        node.stop()
        node.clearLinks()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func emojiBtn(_ sender: Any) {
        
        //emojiBtn.tag if 1 emoji input else normal input
        if emojiBtn.tag == 0 {
            emojiBtn.tag = 1
            let emojiView = ISEmojiView()
            emojiView.delegate = self
            msgBox.inputView = emojiView
            msgBox.becomeFirstResponder()
            emojiBtn.image = UIImage(named: "arrow_down")
           
        } else {
            emojiBtn.tag = 0
            msgBox.resignFirstResponder()
            
        }
    }
    
    
    @IBAction func sendBtn(_ sender: Any) {
        if msgBox.text != nil && msgBox.text!.characters.count > 0 {
         //   if mChat?.messages == nil {
        //        mChat?.messages. Message(id: "-1", text: msgBox.text!, peerName: "None", isItMyMsg: true, time:  Date()
        //    }
            let mMessage = Message(id: "-1", text: msgBox.text!, peerName: UIDevice.current.name, isItMyMsg: true, time:  Date())
            
            let jsonDic = ["id":mMessage.id,"text":mMessage.text,"peerName":mMessage.peerName ,"isItMyMsg":true,"time":Int(round(mMessage.time.timeIntervalSince1970))] as [String : AnyObject]
            print(Int(round(mMessage.time.timeIntervalSince1970)))
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: jsonDic,
                options: []) {
                let theJSONText = String(data: theJSONData,
                                         encoding: .ascii)
                
                let jsonData = theJSONText?.data(using: .utf16)
                mChat?.messages.append(mMessage)
                //Maybe it's better too send theJSONData but i think it's encoding is .ascii and we need .utf-8 for parsing in android
                node.broadcastFrame(frameData(jsonData!))
                msgTableView.reloadData()
                updateTableContentInset()
                msgBox.text = nil
            }
            

        }
    }
    
    @IBAction func sendLongBtn(_ sender: Any) {
   //     mChat?.messages.append(Message(id: "+1", text: msgBox.text!, peerName: "None", isItMyMsg: false, time:  Date()))
   //     msgTableView.reloadData()
   //     updateTableContentInset()
    }
    
    
    //MARK: Data source
    //MARK: Chat TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mChat?.messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if mChat!.messages[indexPath.row].isItMyMsg {
            let myMsgCell = tableView.dequeueReusableCell(withIdentifier: "MyMsgCell") as! MyMSGTableViewCell
            myMsgCell.myMsgTxt.text = mChat!.messages[indexPath.row].text
            return myMsgCell
        } else {
            let yourMsgCell = tableView.dequeueReusableCell(withIdentifier: "YourMsgCell") as! YourMSGTableViewCell
            yourMsgCell.YourMsgTxt.text = mChat!.messages[indexPath.row].text
            yourMsgCell.NameMsgTxt.text = mChat!.messages[indexPath.row].peerName
            return yourMsgCell
        }
    }
    
    
    //MARK: Delagate
    
    //MARK: ISEmojiViewDelegate implrmentaion
    
    // callback when tap a emoji on keyboard
    func emojiViewDidSelectEmoji(emojiView: ISEmojiView, emoji: String) {
        msgBox.insertText(emoji)
    }
    
    // callback when tap delete button on keyboard
    func emojiViewDidPressDeleteButton(emojiView: ISEmojiView) {
        msgBox.deleteBackward()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        emojiBtn.image = UIImage(named: "arrow_down")
        emojiBtn.tag = 1
        

    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        emojiBtn.image = UIImage(named: "emoji")
        emojiBtn.tag = 0

    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if msgBox.text != nil && msgBox.text!.characters.count > 0 {
            //   if mChat?.messages == nil {
            //        mChat?.messages. Message(id: "-1", text: msgBox.text!, peerName: "None", isItMyMsg: true, time:  Date()
            //    }
            let mMessage = Message(id: "-1", text: msgBox.text!, peerName: UIDevice.current.name, isItMyMsg: true, time:  Date())
            
            let jsonDic = ["id":mMessage.id,"text":mMessage.text,"peerName":mMessage.peerName ,"isItMyMsg":true,"time":Int(round(mMessage.time.timeIntervalSince1970))] as [String : AnyObject]
            print(Int(round(mMessage.time.timeIntervalSince1970)))
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: jsonDic,
                options: []) {
                let theJSONText = String(data: theJSONData,
                                         encoding: .ascii)
                
                let jsonData = theJSONText?.data(using: .utf16)
                mChat?.messages.append(mMessage)
                //Maybe it's better too send theJSONData but i think it's encoding is .ascii and we need .utf-8 for parsing in android
                node.broadcastFrame(frameData(jsonData!))
                msgTableView.reloadData()
                updateTableContentInset()
                msgBox.text = nil
            }
            
            
        }
        return true
    }
    
    
    func updateTableContentInset() {
        let numRows = tableView(self.msgTableView, numberOfRowsInSection: 0)
        var contentInsetTop = self.msgTableView.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.msgTableView.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
            }
        }
        self.msgTableView.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0)
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    //MARK: - Actions
    
    let bgqueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    
    func frameData(_ mData:Data) -> UDSource<NSData>
    {
        let future = UDFutureLazy<NSData, AnyObject>(queue: bgqueue) { (context) -> AnyObject in
            let mutableData = NSMutableData(data: mData)
            let data = mutableData.copy() as! NSData
            return data
        }
        
        /*let data = NSMutableData(length: dataLength);
         arc4random_buf(data!.mutableBytes, data!.length)
         let result = UDFutureKnown(data: data!)*/
        
        return UDSource(future: future)
    }
    

}





extension ChatViewController : ChatServiceManagerDelegate {
    func connectedDevicesChanged(manager: ChatServiceManager, connectedDevices: [String]) {
        print(connectedDevices.count)
    }
    
    func msgRecieved(manager: ChatServiceManager, message: Message) {
        print(message.text)
    }
    
    
}


extension ChatViewController : NodeDelegate {

    func connectedDevicesChanged(connectedDevices: [String : [UDLink]], peersCount: Int, linksCount: Int, peerThatChange: UDLink, isConnected: Bool) {
        if peersCount == 0 {
            navigationController?.popViewController(animated: true)
        } else {
            self.peersCountLabel.text = "\(peersCount)"
        }
        
    }
    
    
    func msgRecieved(manager: Node, message: Message) {
        print(message.text)
        self.mChat?.messages.append(message)
        self.msgTableView.reloadData()
        updateTableContentInset()
    }
    
}
