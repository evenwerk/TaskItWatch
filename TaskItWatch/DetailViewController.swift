//
//  DetailViewController.swift
//  TaskItWatch
//
//  Created by Tim Even on 26-06-15.
//  Copyright (c) 2015 evenwerk. All rights reserved.
//

import UIKit
import CoreDataShare

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    var task:Task!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViewWithTask()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonItemTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveBarButttonItemTapped(sender: UIBarButtonItem) {
        task.titleName = self.titleTextView.text
        task.descriptionName = self.titleTextView.text
        
        if task.isCompleted == true {
            doneButton.backgroundColor = UIColor.greenColor()
            doneButton.setTitle("X", forState: UIControlState.Normal)
        }
        else {
            doneButton.backgroundColor = UIColor.redColor()
            doneButton.setTitle("✔️", forState: UIControlState.Normal)
        }
        
        CoreDataManager.sharedInstance.saveContext()
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        TaskHelper.sharedInstance.switchCompletion(self.task)
        
        if task.isCompleted == true {
            doneButton.backgroundColor = UIColor.greenColor()
            doneButton.setTitle("✔️", forState: UIControlState.Normal)
        }
        else {
            doneButton.backgroundColor = UIColor.redColor()
            doneButton.setTitle("X", forState: UIControlState.Normal)
        }
    }
    
    func setupViewWithTask() {
        
        self.titleTextView.text = task.titleName
        self.bodyTextView.text = task.descriptionName
        
        if task.isCompleted == true {
            doneButton.backgroundColor = UIColor.greenColor()
            doneButton.setTitle("✔️", forState: UIControlState.Normal)
        }
        else {
            doneButton.backgroundColor = UIColor.redColor()
            doneButton.setTitle("X", forState: UIControlState.Normal)
        }
    }
}
