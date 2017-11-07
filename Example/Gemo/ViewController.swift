//
//  ViewController.swift
//  Gemo
//  Created by gemgemo on 08/02/2017.
//  Copyright (c) 2017 gemgemo. All rights reserved.
//

import UIKit
import Gemo

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Gemo.request(link: "", method: .get)
            .response(Person.self) { (res) in
                switch res {
                case .success(_):
                    print("success")
                case .failure(_):
                    print("fail")
                case .jsonString(_):
                    print("string")
                case .response(_):
                    print("response")
                }
        }
    }

    

}




struct Person: Codable {
    
}
