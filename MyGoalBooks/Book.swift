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
                let createTableBooks = "CREATE TABLE IF NOT EXISTS BOOKS(ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, PAGES INTEGER, PAGESREAD INTEGER DEFAULT 0, PORCENTAGEMREAD REAL DEFAULT 0, DATEBEGIN TEXT NULL, DATEEND TEXT NULL)"
                
                if !booksDB.executeStatements(createTableBooks) {
                    print("Error: \(booksDB.lastErrorMessage())")
                }
                
                let insertItem = "INSERT INTO BOOKS(NAME, PAGES) values ('Fast and Slow',10)"
                if !booksDB.executeStatements(insertItem) {
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
                result.append(Book(name: name!, pages: Int(pages!) ))
            }
        }
        
        return result
    }
    
    func insert(book: Book) -> Bool
    {
        let booksDB = FMDatabase(path: DataBasePath as String)
        
        if booksDB.open() {
            let insertItem = "INSERT INTO BOOKS(NAME, PAGES, PAGESREAD, PORCENTAGEMREAD) values ('\(book.Name)',\(book.Pages), \(book.PagesRead), \(book.PercentageRead))"
            
            if !booksDB.executeStatements(insertItem) {
                print("Error: \(booksDB.lastErrorMessage())")
                return false
            }
        }
        
        return true
    }
    
    func getPercentageRead() -> Double?
    {
        self.PercentageRead = Double((self.PagesRead * 100) / self.Pages)
        return self.PercentageRead
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
