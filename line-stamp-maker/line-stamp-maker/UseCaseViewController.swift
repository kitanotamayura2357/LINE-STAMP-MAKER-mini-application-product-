//
//  UseCaseViewController.swift
//  line-stamp-maker
//
//  Created by Takashi Imoto on 2019/06/25.
//  Copyright © 2019 Takashi Imoto. All rights reserved.
//

import UIKit

class UseCaseViewController: UIViewController {

    @IBOutlet weak var UseCaseLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UseCaseLabel.text = "Use case"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
