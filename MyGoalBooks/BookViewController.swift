//
//  AddBookViewController.swift
//  MyGoalBooks
//
//  Created by Italo Chesley on 6/23/16.
//  Copyright © 2016 Italo Chesley. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Variaveis
    var book: Book?
    var percentageRead: Double = 0
    var pagesRead: Int = 0
    var endDate: NSDate?
    
    override func viewDidLoad() {
        pagesReadTextField.delegate = self
        pagesReadTextField.addTarget(self, action: #selector(BookViewController.updateDueDate), forControlEvents: UIControlEvents.EditingChanged)
        pagesTextBook.addTarget(self, action: #selector(BookViewController.updateDueDate), forControlEvents: UIControlEvents.EditingChanged)
        
        if let selectedBook = book {
            nameTextField.text = selectedBook.Name
            pagesTextBook.text = String(selectedBook.Pages)
            
            percentagePagesSegmenteControle.selectedSegmentIndex = 0
            pagesReadTextField.text = String(selectedBook.PagesRead)
            
            incrementerPages.maximumValue = Double((book?.Pages)! - (book?.PagesRead)!)
            incrementerPages.value = Double(selectedBook.Average)
            showNumberOfPagesADayLabel.text = String(selectedBook.Average)
            
            setFinishDate(selectedBook.Average)
            
            pagesReadTextField.becomeFirstResponder()
        }else
        {
            nameTextField.becomeFirstResponder()
        }
    }
    
    func updateDueDate(textEditor: UITextField) {
        if book?.ID == nil{
            setFinishDate(Int(showNumberOfPagesADayLabel.text!)!)
        }
        
    }
   
    
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
    @IBOutlet weak var pagesReadADay: UITextField!
        {
        didSet{
            pagesReadADay.keyboardType = UIKeyboardType.NumberPad
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
    
    @IBOutlet weak var dateToFinalRead: UILabel!
    @IBAction func calculatePercentagePage(sender: UISegmentedControl) {
        setPercentagePagesRead(sender.selectedSegmentIndex != 1)
            }
    
    private func setPercentagePagesRead(presentingPercentage: Bool)
    {
        if pagesReadTextField.text != "" && pagesTextBook.text != "" {
            let oldValue:Double = Double(pagesReadTextField.text!)!
            let numberOfPages:Double = Double(pagesTextBook.text!)!
            
            if !presentingPercentage {
                //calculate parcentage read
                percentageRead = Double((oldValue*100)/numberOfPages)
                self.pagesRead = Int(oldValue)
                pagesReadTextField.text = String(Int(round(percentageRead)))
            }
            else
            {
                //calculate pages read
                self.pagesRead = Int((oldValue*numberOfPages)/100)
                self.percentageRead = oldValue
                pagesReadTextField.text = String(pagesRead)
            }
        }
    }
   
    @IBOutlet weak var showNumberOfPagesADayLabel: UILabel!
  
    @IBOutlet weak var incrementerPages: UIStepper!
    
    @IBAction func incrementerPagesStep(sender: UIStepper) {
        let numberOfPages = Int(sender.value)
        showNumberOfPagesADayLabel.text = String(numberOfPages)
        setFinishDate(numberOfPages)
    }
    
    func setFinishDate(numberOfPages: Int)
    {
        if pagesTextBook.text != "" && pagesReadTextField.text != "" {
            incrementerPages.minimumValue = 1
            let totalPages = Int(pagesTextBook.text!)!
            let pagesRead = Int(pagesReadTextField.text!)!
            incrementerPages.maximumValue = Double(totalPages - pagesRead)
            
            let book = Book()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            endDate = book.GetFinalDate(numberOfPages, TotalPages:totalPages , PagesRead: pagesRead)!
            
            let finishDate:String = dateFormatter.stringFromDate(endDate!)
            let result = "Finish on \(finishDate)"
            
            dateToFinalRead.text = result
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender
        {
            if book == nil
            {
                book = Book()
            }
            
            setPercentagePagesRead(percentagePagesSegmenteControle.selectedSegmentIndex==1)
            
            self.book!.Name = nameTextField.text ?? ""
            self.book!.Pages = Int(pagesTextBook.text!)!
            self.book!.PercentageRead = round(self.percentageRead) 
            self.book!.PagesRead = self.pagesRead
            self.book!.DateEnd = self.endDate
            self.book!.Average = Int(showNumberOfPagesADayLabel.text!)!
            
            let newBook = Book()
            book? = newBook.InsertOrUpdate(book!)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
