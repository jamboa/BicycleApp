//
//  MenuViewController.swift
//  telecycle
//
//  Created by yoojonghyun on 2018. 1. 5..
//  Copyright © 2018년 yoojonghyun. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var testLabel: UILabel!
    
//    static func instantiate() -> MenuViewController {
//        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        testLabel.text = "YoYo"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension MenuViewController : StoryboardInstantiable{
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "MenuViewController" }
}
