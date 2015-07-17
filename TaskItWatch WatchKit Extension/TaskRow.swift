//
//  TaskRow.swift
//  TaskItWatch
//
//  Created by Tim Even on 16-07-15.
//  Copyright (c) 2015 evenwerk. All rights reserved.
//

import UIKit
import WatchKit

protocol TaskRowDelegate {
    func completedButtonWasTapped(tag: Int)
}

class TaskRow: NSObject {
    
    var completion: Bool!
    var tag: Int!
    
    var delegate:TaskRowDelegate?
    
    @IBOutlet weak var completionButton: WKInterfaceButton!
    @IBOutlet weak var textLabel: WKInterfaceLabel!
   
    @IBAction func completedButtonTapped() {
        
        if completion == true {
            self.completion = false
            self.completionButton.setBackgroundColor(UIColor.redColor())
            self.completionButton.setTitle("X")
        }
        else {
            self.completion = true
            self.completionButton.setBackgroundColor(UIColor.greenColor())
            self.completionButton.setTitle("✔️")
        }
        self.delegate?.completedButtonWasTapped(self.tag)
    }
}
