 //
//  Book.swift
//  MyGoalBooks
//
//  Created by Italo Chesley on 6/23/16.
//  Copyright © 2016 Italo Chesley. All rights reserved.
//

import Foundation
import UIKit

class Book {
    var ID: Int = 0
    var Name:String = ""
    var Pages: Int = 0
    var PagesRead: Int = 0
    var PercentageRead: Double = 0.0
    var DateEnd: NSDate?
    var Average = 0

    var DataBasePath = NSString()
    let repository: BookRepository = BookRepository()
    
    init(name: String, pages: Int)
    {
        self.Name = name
        self.Pages = pages
        self.PagesRead = 0
        self.PercentageRead = 0.0
    }
    
    init()
    {
       
    }

    
    func getAll() -> [Book]
    {
        return repository.getAll()
    }
    
    func InsertOrUpdate(book: Book) -> Book
    {
        return repository.InsertOrUpdate(book)
    }
    
    func delete(id:Int)
    {
        repository.delete(id)
    }
    
    func GetFinalDate(PagesADay: Int, TotalPages: Int, PagesRead: Int) -> NSDate?
    {
        let numberOfPages = TotalPages - PagesRead
        let numberOfDays = numberOfPages / PagesADay
        
        let now = NSDate()
        let components = NSDateComponents()
        components.setValue(numberOfDays, forComponent: .Day)
        let result: NSDate? = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: now, options: NSCalendarOptions(rawValue: 0))
        
        return result
    }
    
    func getPagesToFinish(TotalPages: Int, PagesRead: Int, FinishDate: NSDate?) -> Int
    {
        var retorno:Int = 0
        
        if let finishDate = FinishDate {
            let numberOfPagesToFinish = TotalPages - PagesRead
            let calendarUnit:NSCalendarUnit = [.Day]
            let diference = NSCalendar.currentCalendar().components(calendarUnit, fromDate: NSDate(), toDate: finishDate, options: []).day
            
            if diference > 0 && numberOfPagesToFinish > 0 {
                retorno = numberOfPagesToFinish / diference
            }
            
            return retorno
        }
        
        return 0
    }
}

extension String {
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
}
