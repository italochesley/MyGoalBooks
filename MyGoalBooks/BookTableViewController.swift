//
//  ViewController.swift
//  MyGoalBooks
//
//  Created by Italo Chesley on 6/22/16.
//  Copyright © 2016 Italo Chesley. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {

    
    var allBooks: [Book] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        let book = Book()
        allBooks = book.getAll()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBooks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BooksTableViewCell", forIndexPath: indexPath) as! BooksTableViewCell
        
        let pages: String = String(allBooks[indexPath.row].Pages)
        let pagesRead: String = String(allBooks[indexPath.row].PagesRead)
        cell.bookName.text =  "\(allBooks[indexPath.row].Name)"
        
        cell.bookPagesRead.text = "\(Int(allBooks[indexPath.row].PercentageRead))% (\(pagesRead) of \(pages))"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        
        let averageForFinish: Int = allBooks[indexPath.row].getPagesToFinish(Int(pages)!, PagesRead: Int(pagesRead)!, FinishDate: allBooks[indexPath.row].DateEnd)
        
        var averages = "\(allBooks[indexPath.row].Average) pages"
        
        if averageForFinish > allBooks[indexPath.row].Average {
            averages = averages + " (you are late!)"
        }else if averageForFinish <  allBooks[indexPath.row].Average{
            averages = averages + " (you are ok!)"
        }
        
        
        if averageForFinish > allBooks[indexPath.row].Average {
            cell.averageaDay.textColor = UIColor.redColor()
        }else if averageForFinish > allBooks[indexPath.row].Average {
            cell.averageaDay.textColor = UIColor.blueColor()
        }
        
        cell.averageaDay.text = averages
        
        if let finishDate =  allBooks[indexPath.row].DateEnd {
            cell.finishDate.text = "Due Date: \(dateFormatter.stringFromDate(finishDate))"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let bookDetailViewIdentifier = segue.destinationViewController as! BookViewController
            
            if let selectedBook = sender as? BooksTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedBook)!
                let selectedBook = allBooks[indexPath.row]
                bookDetailViewIdentifier.book = selectedBook
            }
            
        }else if segue.identifier == "AddItem"
        {
            
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //deletar da base
            let idBookDelete = allBooks[indexPath.row].ID
            let book = Book()
            book.delete(idBookDelete)
            //deletar da lista
            allBooks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }else if editingStyle == .Insert
        {}
    }
    
    @IBAction func unwideToBookList(sender: UIStoryboardSegue)
        {
            if let sourceViewController = sender.sourceViewController as? BookViewController
            {
                let book = sourceViewController.book
                
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    allBooks[selectedIndexPath.row] = book!
                    tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Fade)
                    tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
                }else{
                let newIndexPath = NSIndexPath(forRow: allBooks.count, inSection: 0)
                allBooks.append(book!)
                    tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                    tableView.deselectRowAtIndexPath(newIndexPath, animated: true)
                }
            }
            
        
        }
    
}

