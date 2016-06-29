//
//  ViewController.swift
//  MyGoalBooks
//
//  Created by Italo Chesley on 6/22/16.
//  Copyright © 2016 Italo Chesley. All rights reserved.
//

import UIKit

class BookTableViewController: UIViewController, UITableViewDataSource {

    
    @IBOutlet weak var booksTableView: UITableView!
    var allBooks: [Book] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let book = Book(name: "", pages: 0)
        allBooks = book.getAll()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBooks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BooksTableViewCell", forIndexPath: indexPath) as! BooksTableViewCell
        
        let pages: String = String(allBooks[indexPath.row].Pages)
        cell.bookName.text =  "\(allBooks[indexPath.row].Name)(\(pages) pages)"
        
        cell.bookPagesRead.text = "\(allBooks[indexPath.row].PercentageRead)%"
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let bookDetailViewIdentifier = segue.destinationViewController as! BookViewController
            
            if let selectedBook = sender as? BooksTableViewCell {
                let indexPath = booksTableView.indexPathForCell(selectedBook)!
                let selectedBook = allBooks[indexPath.row]
                bookDetailViewIdentifier.book = selectedBook
            }
            
        }else if segue.identifier == "AddItem"
        {
            
        }
    }
    
    @IBAction func unwideToBookList(sender: UIStoryboardSegue)
        {
            if let sourceViewController = sender.sourceViewController as? BookViewController
            {
                let book = sourceViewController.book
                
                if let selectedIndexPath = booksTableView.indexPathForSelectedRow {
                    allBooks[selectedIndexPath.row] = book!
                    booksTableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Fade)
                }else{
                let newIndexPath = NSIndexPath(forRow: allBooks.count, inSection: 0)
                allBooks.append(book!)
                    booksTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)}
            }
        
        }
    
}

