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
    var DateBegin: NSDate?
    var DateEnd: NSDate?

    var DataBasePath = NSString()
    
    init(name: String, pages: Int)
    {
        setDataBasePath()
        createDateBaseIfNotExists()
        
        self.Name = name
        self.Pages = pages
        self.PagesRead = 0
        self.PercentageRead = 0.0
    }
    
    init()
    {
        setDataBasePath()
        createDateBaseIfNotExists()
    }
    
    func setDataBasePath()
    {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0]
        
        DataBasePath = docsDir.stringByAppendingPathComponent("getGoalBooks.db")
        
    }
    
    func createDateBaseIfNotExists()
    {
        let filemgr = NSFileManager.defaultManager()
        print(DataBasePath)
        
        if !filemgr.fileExistsAtPath(DataBasePath as String) {
            let booksDB = FMDatabase(path: DataBasePath as String)
            
            if booksDB == nil
            {
                print("Error: \(booksDB.lastErrorMessage())")
            }
            
            if booksDB.open() {
                let createTableBooks = "CREATE TABLE IF NOT EXISTS BOOKS(ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, PAGES INTEGER, PAGESREAD INTEGER DEFAULT 0, PERCENTAGEREAD REAL DEFAULT 0, DATEBEGIN TEXT NULL, DATEEND TEXT NULL)"
                
                if !booksDB.executeStatements(createTableBooks) {
                    print("Error: \(booksDB.lastErrorMessage())")
                }
                
                    booksDB.close()
            }
        }
    }
    
    func getAll() -> [Book]
    {
        let booksDB = FMDatabase(path: DataBasePath as String)
        var result: [Book] = []
        
        if booksDB.open() {
            let querySQL = "SELECT * FROM BOOKS"
            
            let resultDB: FMResultSet? = booksDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            while resultDB?.next() == true {
                let name = resultDB?.stringForColumn("NAME")!
                let pages = resultDB?.intForColumn("PAGES")
                let pagesRead = resultDB?.intForColumn("PAGESREAD")
                let bookID = resultDB?.intForColumn("ID")
                let percentageRead = resultDB?.doubleForColumn("PERCENTAGEREAD")
                
                let book = Book()
                book.Name = name!
                book.Pages = Int(pages!)
                book.PagesRead = Int(pagesRead!)
                book.ID = Int(bookID!)
                book.PercentageRead = percentageRead!
                
                result.append(book)
            }
        }
        
        return result
    }
    
    func InsertOrUpdate(book: Book) -> Bool
    {
        book.setPercentageRead()
        
        let booksDB = FMDatabase(path: DataBasePath as String)
        
        var sqlInsertUpdate: String = ""
        
        if booksDB.open() {
            if book.ID == 0 {
                sqlInsertUpdate = "INSERT INTO BOOKS(NAME, PAGES, PAGESREAD, PERCENTAGEREAD) values ('\(book.Name)',\(book.Pages), \(book.PagesRead), \(book.PercentageRead))"
            }else
            {
                sqlInsertUpdate = "UPDATE BOOKS SET PAGESREAD = \(book.PagesRead), PERCENTAGEREAD = \(book.PercentageRead) WHERE ID = \(book.ID) "
            }
            
            if !booksDB.executeStatements(sqlInsertUpdate) {
                print("Error: \(booksDB.lastErrorMessage())")
                return false
            }
        }
        
        return true
    }
    
    private func setPercentageRead()
    {
        if self.PercentageRead == 0 {
            self.PercentageRead = Double((self.PagesRead * 100) / self.Pages)
        }else
        {
            self.PagesRead = 0
        }
    }
}

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}

extension String {
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
}
