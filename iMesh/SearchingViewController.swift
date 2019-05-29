//
//  SearchingViewController.swift
//  iMesh
//
//  Created by Sina Mirshafiei on 3/12/1397 AP.
//  Copyright © 1397 AP IAUCTB. All rights reserved.
//

import UIKit
import Underdark


class SearchingViewController: UIViewController,NodeDelegate {
    
    

    
    @IBOutlet weak var gifImg: UIImageView!
    
    var node : Node?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frequencyGif = UIImage.gif(asset: "frequenc-gif")
        gifImg.image = frequencyGif
        
        node = UnderdarkAppModel.shared.node
        node?.delegate = self
        

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        node?.start()
        node?.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func connectedDevicesChanged(connectedDevices: [String : [UDLink]], peersCount: Int, linksCount: Int, peerThatChange: UDLink, isConnected: Bool) {
        if peersCount > 0 {
            performSegue(withIdentifier: "showChatSG", sender: nil)
        }
    }
    
    func msgRecieved(manager: Node, message: Message) {
        return
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
