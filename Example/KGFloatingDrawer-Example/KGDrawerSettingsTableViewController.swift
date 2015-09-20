//
//  KGDrawerSettingsTableViewController.swift
//  KGDrawerViewController
//
//  Created by Kyle Goddard on 2015-02-16.
//  Copyright (c) 2015 Kyle Goddard. All rights reserved.
//

import UIKit
import KGFloatingDrawer

class KGDrawerSettingsTableViewController: UITableViewController {
    
    let resetRowIndex:Int = 4

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var springVelocityLabel: UILabel!
    @IBOutlet weak var springDampingLabel: UILabel!
    
    var animator: KGDrawerSpringAnimator?
    
    var defaultDuration: NSTimeInterval?
    var defaultDelay: NSTimeInterval?
    var defaultSpringVelocity: CGFloat?
    var defaultSpringDamping: CGFloat?
    
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var springVelocitySlider: UISlider!
    @IBOutlet weak var springDampingSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            animator = appDelegate.drawerViewController.animator
            captureDefaultValues(animator!)
            reset()
        }
    }
    
    func captureDefaultValues(animator:KGDrawerSpringAnimator) {
        defaultDuration = animator.animationDuration
        defaultDelay = animator.animationDelay
        defaultSpringVelocity = animator.initialSpringVelocity
        defaultSpringDamping = animator.springDamping
    }
    
    func reset() {
        updateAnimator()
        updateSliders()
        updateLabels()
    }
    
    func updateAnimator() {
        if let currentAnimator = animator {
            currentAnimator.animationDuration = NSTimeInterval(defaultDuration!)
            currentAnimator.animationDelay = NSTimeInterval(defaultDelay!)
            currentAnimator.initialSpringVelocity = defaultSpringVelocity!
            currentAnimator.springDamping = defaultSpringDamping!
        }
    }
    
    func updateSliders() {
        durationSlider.value = Float(defaultDuration!)
        delaySlider.value = Float(defaultDelay!)
        springVelocitySlider.value = Float(defaultSpringVelocity!)
        springDampingSlider.value = Float(defaultSpringDamping!)
    }
    
    func updateLabels() {
        durationLabel.text = String(format: "%.2f", durationSlider.value)
        delayLabel.text = String(format: "%.2f", delaySlider.value)
        springVelocityLabel.text = String(format: "%.2f", springVelocitySlider.value)
        springDampingLabel.text = String(format: "%.2f", springDampingSlider.value)
    }
    
    @IBAction func durationSliderChanged(sender: UISlider) {
        durationLabel.text = String(format: "%.2f", sender.value)
        animator?.animationDuration = NSTimeInterval(sender.value)
    }
    
    @IBAction func delaySliderChanged(sender: UISlider) {
        delayLabel.text = String(format: "%.2f", sender.value)
        animator?.animationDelay = NSTimeInterval(sender.value)
    }
    
    @IBAction func springVelocitySliderChanged(sender: UISlider) {
        springVelocityLabel.text = String(format: "%.2f", sender.value)
        animator?.initialSpringVelocity = CGFloat(sender.value)
    }
    
    @IBAction func springDampingSliderChanged(sender: UISlider) {
        springDampingLabel.text = String(format: "%.2f", sender.value)
        animator?.springDamping = CGFloat(sender.value)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleLeftDrawer(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.toggleLeftDrawer(sender, animated: false)
    }
    
    @IBAction func toggleRightDrawer(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.toggleRightDrawer(sender, animated: true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRowIndex:Int = indexPath.section
        if selectedRowIndex == resetRowIndex {
            reset()
        }
    }
}
