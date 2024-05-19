// MARK: Description
/*
    Description : View Model
    Date : 2024.5. 10
    Author : Ilhera
    Updates :
         2024.05.10  by pdg :
            - DB 삭제 function 부활 시킴 db 이름 todoList (L 대문자임!!)
            - compledate : todo 완료 일자임.
            - delete function return 수정
         2024.05.11 by pdg :
            - insert 쿼리 완성
            - delete 쿼리 완성
            - update 쿼리 완성
 
            
    Detail :
            - DB Columns
                id,text,insertdate,compledate,status,seq

    Bundle : com.swiftlec.SQLiteTodoAdvanced

*/

import Foundation
import SQLite3
import UIKit

protocol QueryModelProtocol {
    func itemDownloaded(items: [TodoList])
}


//self.todoText = todoText
//self.insertDate = insertDate
//self.compleDate = compleDate
//self.status = status
//self.seq = seq

class TodoListDB{
    var db: OpaquePointer?
    var todoList: [TodoList] = []
    var delegate: QueryModelProtocol!
    
    init() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: "todoList.sqlite")
        
        if sqlite3_open(fileURL.path(percentEncoded: true), &db) != SQLITE_OK{
            print("error opening database")
        }
        
        // Table 만들기
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS todoList (id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, insertdate TEXT, compledate TEXT, status INTEGER, seq INTEGER)", nil, nil, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table :\(errMsg)")
        }
    }
    
    // todo insert
    // insertdate : 입력날짜
    // compledate : 완료된 날짜 => 처음 insert 시에는 compledate는 널값 처리
    func insertDB(text: String, insertdate: String, compledate: String, status: Int, seq: Int) -> Bool{
        
            var stmt: OpaquePointer?
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            let queryString = "INSERT INTO todoList ( text, insertdate, compledate, status, seq) VALUES (?,?,?,?,?)"
        var result : Bool = true
            sqlite3_prepare(db, queryString, -1, &stmt, nil)
            
            sqlite3_bind_text(stmt, 1, text, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 2, insertdate, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 3, compledate, -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(stmt, 4, Int32(status))
            sqlite3_bind_int(stmt, 5, Int32(seq))
        
            if sqlite3_step(stmt) == SQLITE_DONE {
                 result = true
            }else{
                 result = false
            }
        
        return result
    }
    
    // 조회
    func queryDB(){
        var stmt: OpaquePointer?
        let queryString = "SELECT * FROM todoList ORDER BY insertdate"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select : \(errMsg)")
            return
        }

        while(sqlite3_step(stmt) == SQLITE_ROW){
            // DB colums
            let id = Int(sqlite3_column_int(stmt, 0))
            let text = String(cString: sqlite3_column_text(stmt, 1))
            let insertdate = String(cString: sqlite3_column_text(stmt, 2))
            let compledate = String(cString: sqlite3_column_text(stmt, 3))
            let status = Int(sqlite3_column_int(stmt, 4))
            let seq = Int(sqlite3_column_int(stmt, 5))
            
            // insert into model from fetched date
            todoList.append(TodoList(
                id: id,
                todoText: text,
                insertDate: insertdate,
                compleDate: compledate,
                status: status,
                seq: seq
            ))
        }
        
        self.delegate.itemDownloaded(items: todoList)
    }
    
    
    // 삭제
    func deleteDB(id: Int) -> Bool{
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM todoList WHERE id = ?"
        var result = true
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_int(stmt, 1, Int32(id))

        if sqlite3_step(stmt) == SQLITE_DONE{
            result = true
        }else{
            result = false
        }
        
    return result
    }
    
    // 수정  id,text,insertdate,compledate,status,seq
    func updateDB(id: Int, text: String, status: Int, seq: Int) -> Bool{
        //
        print("-- UpdateDB query start operation ---")
        print(" parameter check  \n id : \(id) \n text: \(text) \n status: \(status) \n seq: \(seq))")
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        var result = true
        let queryString = "UPDATE todoList SET text = ?, status = ?, seq = ?  WHERE id = ?"
       
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_text(stmt, 1, text, -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 2, Int32(status))
        sqlite3_bind_int(stmt, 3, Int32(seq))
        sqlite3_bind_int(stmt, 4, Int32(id))
        
        print(" ->Query String : \(queryString)")
        if sqlite3_step(stmt) == SQLITE_DONE{
            print("수정 완료")
            result =  true
        }else{
            print("수정 실패")
            result =  false
        }
        return result
    }
}
