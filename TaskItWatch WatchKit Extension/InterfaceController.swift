//
//  InterfaceController.swift
//  TaskItWatch WatchKit Extension
//
//  Created by Tim Even on 26-06-15.
//  Copyright (c) 2015 evenwerk. All rights reserved.
//

import WatchKit
import Foundation
import CoreDataShare

class InterfaceController: WKInterfaceController, TaskRowDelegate {

    @IBOutlet weak var table: WKInterfaceTable!
    
    var tasks: [AnyObject]!
    var wormHole: MMWormhole!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.wormHole = MMWormhole(applicationGroupIdentifier: "group.TaskItWatch.com.evenwerk", optionalDirectory: "wormhole")
        self.wormHole.listenForMessageWithIdentifier("taskChangeOnPhone", listener: { (objectPassed) -> Void in
            self.updateTasks()
            self.updateTable()
        })
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func updateTable () {
        if self.tasks.count != 0 {
            self.table.setNumberOfRows(self.tasks.count, withRowType: "TaskRow")
            for var index = 0; index < tasks.count; index++ {
                var theRow = self.table.rowControllerAtIndex(index) as! TaskRow
                let task = self.tasks[index] as! Task
                CoreDataManager.sharedInstance.managedObjectContext?.refreshObject(task, mergeChanges: true)
                theRow.textLabel.setText(task.titleName)
                theRow.completion = task.isCompleted as! Bool
                theRow.tag = index
                theRow.delegate = self
                
                if task.isCompleted == true {
                    theRow.completionButton.setBackgroundColor(UIColor.greenColor())
                }
                else {
                    theRow.completionButton.setBackgroundColor(UIColor.redColor())
                }
            }
        }
    }
    
    func updateTasks() {
        self.tasks = TaskHelper.sharedInstance.getTasks()
    }
    
    //MARK: - TaskRowDelegate
    
    func completedButtonWasTapped(tag: Int) {
        var task = self.tasks[tag] as! Task
        TaskHelper.sharedInstance.switchCompletion(task)
    }
}
