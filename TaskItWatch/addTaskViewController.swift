//
//  addTaskViewController.swift
//  TaskItWatch
//
//  Created by Tim Even on 26-06-15.
//  Copyright (c) 2015 evenwerk. All rights reserved.
//

import UIKit
import CoreDataShare

class addTaskViewController: UIViewController {

    @IBOutlet weak var titleTextview: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonItemTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveBarButtonItemTapped(sender: UIBarButtonItem) {
        TaskHelper.sharedInstance.insertNewObject(self.titleTextview.text, description: self.bodyTextView.text, date: NSDate())
        self.navigationController?.popViewControllerAnimated(true)
    }
}
