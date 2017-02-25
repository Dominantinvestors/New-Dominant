//
//  DMLaunchViewController.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import MBProgressHUD

class DMLaunchViewController: DMViewController {

    @IBOutlet weak var backgroundImage   : UIImageView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    var progressHUD : MBProgressHUD!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        if (!checkOldAppMigration()) {
            launchApp()
        }
    }

    private func setupUI() {
        self.backgroundImage.image = self.DMAuthScreensBackground
        self.activityIndicator.startAnimating()
    }
    
    private func launchApp() {
        if (!DMAuthorizationManager.sharedInstance.isAuthorized()) {
            let auth = UIStoryboard(name: "Authorization", bundle: nil).instantiateInitialViewController()
            self.navigationController?.pushViewController(auth!, animated: true)
        } else {
            let tabBar = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController()
            self.navigationController?.pushViewController(tabBar!, animated: true)
        }
        progressHUD.hide(animated: true)
    }
    
    private func checkOldAppMigration() -> Bool {
        if let username = UserDefaults.standard.object(forKey: "kUsername") as! String! {
            if let password = UserDefaults.standard.object(forKey: "kPassword") as! String! {
               DMAuthorizationManager.sharedInstance.loginWith(login: username, password: password, completion: { (success, error) in
               })
            } else { return false }
        } else { return false }
        
        return true
    }
    
}
