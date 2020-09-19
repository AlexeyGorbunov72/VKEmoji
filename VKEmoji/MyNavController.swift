//
//  MyNavController.swift
//  VKEmoji
//
//  Created by Alexey on 19.09.2020.
//  Copyright © 2020 Alexey. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController, UINavigationControllerDelegate {

    
    override func viewDidLoad() {
           super.viewDidLoad()
           self.delegate = self
       }

       func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
           let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
           viewController.navigationItem.backBarButtonItem = item
       }
    


}
