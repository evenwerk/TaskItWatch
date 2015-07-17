//
//  TaskHelper.swift
//  TaskItWatch
//
//  Created by Tim Even on 13-07-15.
//  Copyright (c) 2015 evenwerk. All rights reserved.
//

import UIKit
import CoreData

public class TaskHelper: NSObject {
   
    public class var sharedInstance: TaskHelper {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : TaskHelper? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = TaskHelper()
        }
        return Static.instance!
    }
    
    public func insertNewObject(title: String, description: String, date:NSDate) {
        let context = CoreDataManager.sharedInstance.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: context!)
        let task = Task(entity: entityDescription!, insertIntoManagedObjectContext: context!)
        
        task.descriptionName = description
        task.titleName = title
        task.date = date
        task.isCompleted = false
        
        CoreDataManager.sharedInstance.saveContext()
    }
    
    public func switchCompletion(task: Task) {
        if task.isCompleted == true {
            task.isCompleted = false
        }
        else {
            task.isCompleted = true
        }
        
        
        CoreDataManager.sharedInstance.saveContext()
    }
    
    public func deleteTask(task: Task) {
        CoreDataManager.sharedInstance.managedObjectContext?.deleteObject(task)
        CoreDataManager.sharedInstance.saveContext()
    }
    
    public func getTasks() -> [AnyObject] {
        var request = NSFetchRequest()
        var entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!)
        
        request.entity = entityDescription
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        request.sortDescriptors = sortDescriptors
        
        var error:NSError? = nil
        var results = CoreDataManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: &error)
        
        return results!
    }
}
