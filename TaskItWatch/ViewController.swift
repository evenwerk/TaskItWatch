//
//  ViewController.swift
//  TaskItWatch
//
//  Created by Tim Even on 25-06-15.
//  Copyright (c) 2015 evenwerk. All rights reserved.
//

import UIKit
import CoreDataShare
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var wormHole:MMWormhole!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupFetchedResultsController()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.wormHole = MMWormhole(applicationGroupIdentifier: "group.TaskItWatch.com.evenwerk", optionalDirectory: "wormhole")
        self.wormHole.listenForMessageWithIdentifier("taskChangeOnWatch", listener: { (objectPassed) -> Void in
            var fetchError: NSError?
            self.fetchedResultsController.performFetch(&fetchError)
            self.tableView.reloadData()
            println(objectPassed)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetailViewSegue" {
            var detailVC = segue.destinationViewController as! DetailViewController
            detailVC.task = sender as! Task
        }
    }

    @IBAction func addBarButtonItemPressed(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("toAddTaskSegue", sender: nil)
    }
    
    //MARK: - FetchedResultsControllerHelper
    
    func setupFetchedResultsController() {
        var fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!)
        
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = sortDescriptors
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController.delegate = self
        
        var error:NSError?
        
        if !self.fetchedResultsController.performFetch(&error) {
            println("An error occured \(error)")
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections! [section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        var task = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Task
        cell.textLabel!.text = task.titleName
        
        if task.isCompleted == true {
            cell.backgroundColor = UIColor.greenColor()
        }
        else {
            cell.backgroundColor = UIColor.redColor()
        }
        
        return cell
    }

    //MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var task = fetchedResultsController.objectAtIndexPath(indexPath) as! Task
        self.performSegueWithIdentifier("toDetailViewSegue", sender: task)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let task = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Task
            TaskHelper.sharedInstance.deleteTask(task)
        }
    }
    
    //MARK: - NSFetchedResultsDelegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
}

