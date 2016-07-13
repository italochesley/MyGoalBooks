//
//  BookRepository.swift
//  MyGoalBooks
//
//  Created by Italo Chesley on 7/13/16.
//  Copyright © 2016 Italo Chesley. All rights reserved.
//

import Foundation
class BookRepository {
    
    var DataBasePath = NSString()
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
    
    func getAll() -> [Book]
    {
        let booksDB = FMDatabase(path: DataBasePath as String)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
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
                let average = resultDB?.intForColumn("AVERAGE")
                
                let book = Book()
                book.Name = name!
                book.Pages = Int(pages!)
                book.PagesRead = Int(pagesRead!)
                book.ID = Int(bookID!)
                book.PercentageRead = percentageRead!
                book.Average = Int(average!)
                
                if let endDate = resultDB?.stringForColumn("DATEEND"){
                    book.DateEnd = dateFormatter.dateFromString(endDate)
                }
                
                result.append(book)
            }
        }
        
        return result
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
                let createTableBooks = "CREATE TABLE IF NOT EXISTS BOOKS(ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, PAGES INTEGER, PAGESREAD INTEGER DEFAULT 0, PERCENTAGEREAD REAL DEFAULT 0, DATEEND TEXT NULL, AVERAGE INTEGER NULL)"
                
                if !booksDB.executeStatements(createTableBooks) {
                    print("Error: \(booksDB.lastErrorMessage())")
                }
                booksDB.close()
            }
        }
    }
    
    func InsertOrUpdate(book: Book) -> Book
    {
        let booksDB = FMDatabase(path: DataBasePath as String)
        
        var sqlInsertUpdate: String = ""
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = .ShortStyle
        var strDateEnd = ""
        if book.DateEnd != nil {
            strDateEnd = dateFormatter.stringFromDate(book.DateEnd!)
        }
        
        if booksDB.open() {
            if book.ID == 0 {
                sqlInsertUpdate = "INSERT INTO BOOKS(NAME, PAGES, PAGESREAD, PERCENTAGEREAD,  DATEEND, AVERAGE) values ('\(book.Name)',\(book.Pages), \(book.PagesRead), \(book.PercentageRead),'\(strDateEnd)', \(book.Average))"
            }else
            {
                sqlInsertUpdate = "UPDATE BOOKS SET PAGES = \(book.Pages) ,PAGESREAD = \(book.PagesRead), PERCENTAGEREAD = \(book.PercentageRead), NAME = '\(book.Name)', DATEEND = '\(strDateEnd)', AVERAGE = \(book.Average) WHERE ID = \(book.ID)"
            }
            
            if !booksDB.executeStatements(sqlInsertUpdate) {
                print("Error: \(booksDB.lastErrorMessage())")
                return Book()
            }else
            {
                book.ID = getLastIdInserted(booksDB)
            }
        }
        
        return book
    }
    
    func delete(id:Int)
    {
        let booksDB = FMDatabase(path: DataBasePath as String)
        
        if booksDB.open() {
            let sqlDelete = "delete from BOOKS where id = \(id)"
            
            if !booksDB.executeStatements(sqlDelete) {
                print("Error: \(booksDB.lastErrorMessage())")
            }
        }
    }
    
    private func getLastIdInserted(booksDB: FMDatabase) -> Int
    {
        var retorno: Int32?
        
        let resultDB: FMResultSet? = booksDB.executeQuery("select max(id) as ID from BOOKS", withArgumentsInArray: nil)
        
        if (resultDB?.next() == true) {
            retorno = resultDB?.intForColumn("ID")
        }else
        {
            print(booksDB.lastError())
            retorno = 0
        }
        
        return Int(retorno!)
    }
    

}
