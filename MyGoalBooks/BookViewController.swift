//
//  AddBookViewController.swift
//  MyGoalBooks
//
//  Created by Italo Chesley on 6/23/16.
//  Copyright © 2016 Italo Chesley. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var percentagePagesRead: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pagesTextBook: UITextField!
        {
        didSet{
            pagesTextBook.keyboardType = UIKeyboardType.NumberPad
        }
    }
    
    @IBOutlet weak var pagesReadTextField: UITextField!  {
        didSet{
            pagesReadTextField.keyboardType = UIKeyboardType.NumberPad
        }
    }
    
    @IBAction func cancelAddBook(sender: UIBarButtonItem) {
        let isPresentingInAddBookMode = presentingViewController is UINavigationController
        
        if isPresentingInAddBookMode {
            dismissViewControllerAnimated(true, completion: nil)
        }else
        {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    @IBOutlet weak var savePercentagePageSwitch: UISwitch!
    
    @IBAction func informPercentageSwitch(sender: UISwitch) {
        if sender.on {
            percentagePagesRead.text = "Percentage Read"
        }else
        {
            percentagePagesRead.text = "Pages Read"
        }
        
        pagesReadTextField.becomeFirstResponder()
    }
    
    var book: Book = Book()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender
        {
            let newBook =  Book()
            newBook.Name = nameTextField.text ?? ""
            newBook.Pages = Int(pagesTextBook.text!)!
            
            if savePercentagePageSwitch.on {
                newBook.PercentageRead = Double(pagesReadTextField.text!)!
            }else
            {
               newBook.PagesRead = Int(pagesReadTextField.text!)!
            }
            
            book.insert(newBook)
            book = newBook
        }
    }
    
}
