//
//  AddBookViewController.swift
//  MyGoalBooks
//
//  Created by Italo Chesley on 6/23/16.
//  Copyright © 2016 Italo Chesley. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        if let selectedBook = book {
            nameTextField.text = selectedBook.Name
            pagesTextBook.text = String(selectedBook.Pages)
            
            if selectedBook.PagesRead == 0 {
                pagesReadTextField.text = String(selectedBook.PercentageRead)
                percentagePagesSegmenteControle.selectedSegmentIndex = 1
            }
            else
            {
                pagesReadTextField.text = String(selectedBook.PagesRead)
                percentagePagesSegmenteControle.selectedSegmentIndex = 0
            }
            
            pagesReadTextField.becomeFirstResponder()
        }else
        {
            nameTextField.becomeFirstResponder()
        }
    }
    // MARK: Variaveis
    var book: Book?
    
    // MARK: OutLets
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
    
    @IBOutlet weak var percentagePagesSegmenteControle: UISegmentedControl!
    @IBAction func cancelAddBook(sender: UIBarButtonItem) {
        let isPresentingInAddBookMode = presentingViewController is UINavigationController
        
        if isPresentingInAddBookMode {
            dismissViewControllerAnimated(true, completion: nil)
        }else
        {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender
        {
            let newBook =  Book()
            if book != nil {
                newBook.ID = (book?.ID)!
            }
            
            newBook.Name = nameTextField.text ?? ""
            newBook.Pages = Int(pagesTextBook.text!)!
            
            if percentagePagesSegmenteControle.selectedSegmentIndex == 1 {
                newBook.PercentageRead = Double(pagesReadTextField.text!)!
            }else
            {
               newBook.PagesRead = Int(pagesReadTextField.text!)!
            }
            
            book = newBook
            book?.InsertOrUpdate(newBook)
        }
    }
    
}
