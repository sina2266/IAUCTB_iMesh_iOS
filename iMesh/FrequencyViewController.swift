//
//  ViewController.swift
//  iMesh
//
//  Created by Sina Mirshafiei on 3/11/1397 AP.
//  Copyright © 1397 AP IAUCTB. All rights reserved.
//

import UIKit

class FrequencyViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var frequencyTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        frequencyTxtField.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startSearchingSG" {
            UnderdarkAppModel.shared.node.appId = Int32(frequencyTxtField.text!)!
        } else if segue.identifier == "startDefaultSearchingSG" {
            UnderdarkAppModel.shared.node.appId = 226600
        }
    }


}

