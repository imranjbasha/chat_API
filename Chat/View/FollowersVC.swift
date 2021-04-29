//
//  FollowersVC.swift
//  Chat
//
//  Created by VEENA on 29/04/21.
//

import UIKit

class FollowersVC: UIViewController {
    
    
    @IBOutlet weak var tvFollowers: UITableView!
    
    @IBAction func onTappedClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
