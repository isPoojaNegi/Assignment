//
//  WelcomeViewController.swift
//  TestApp
//
//  Created by Pooja on 26/06/23.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
  
    
    @IBAction func assignment1BtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as? PostDetailViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func assignment2BtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let vc = storyboard.instantiateViewController(withIdentifier: "VideoCompressorViewController") as? VideoCompressorViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
