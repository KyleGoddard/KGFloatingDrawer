//
//  KGDrawerWebViewViewController.swift
//  KGDrawerViewController
//
//  Created by Kyle Goddard on 2015-02-16.
//  Copyright (c) 2015 Kyle Goddard. All rights reserved.
//

import UIKit

class KGDrawerWebViewViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url: URL = URL(string: "https://github.com/KyleGoddard/KGFloatingDrawer")!
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func toggleLeftDrawer(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.toggleLeftDrawer(sender, animated: false)
    }
    
    @IBAction func toggleRightDrawer(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.toggleRightDrawer(sender, animated: true)
    }
}
