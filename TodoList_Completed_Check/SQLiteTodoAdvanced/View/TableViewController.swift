// MARK: Description
/*
    Description : Table View Controller
    Date : 2024.5. 10
    Author : Ilhera
    Updates :
         2024.05.10  by pdg :
            - project 생성, 주석 처리
 
         2024.05.11 by pdg :
            - insert 기능 완성
            - inser date 를 시간 분단위로 기록 할 것인가? -> 나중 생각..
            - 주석 생성
            - 수정기능 구현 완료
 
         2024.05.13. (Mon) by kgy :
            - TodoList Completed Check Alert Basic UI
 
    Detail : 
        - 주요 변수, DB column
    Bundle : com.swiftlec.SQLiteTodoAdvanced

*/

import UIKit

class TableViewController: UITableViewController {
  //MARK: -- UI interfaces
  @IBOutlet var tvListView: UITableView!
  
  
  //MARK: -- Property
  var dataArray: [TodoList] = []

  // MARK: --- LongPress Functions ----
  @objc func longPress(sender: UILongPressGestureRecognizer) {

    if sender.state == UIGestureRecognizer.State.began {
      
      let touchPoint = sender.location(in: tableView)
      
      if let indexPath = tableView.indexPathForRow(at: touchPoint) {
        
        // your code here, get the row for the indexPath or do whatever you want
        print("Long press Pressed:)")
        
        // Query Model instance
        let todolistDB = TodoListDB()
        
        // Alert Controller
        let completedCheckAlert = UIAlertController(
          title: "Todo List",
          message: "해당 항목을 작업 완료로 설정하시겠습니까?",
          preferredStyle: .alert
        )
        
        // TodoList의 해당 Cell 내용을 Alert의 TextField로 불러오기 위한 로직
        completedCheckAlert.addTextField { textField in
          textField.text = self.dataArray[indexPath.row].todoText
          
          // TextField를 ReadOnly로 설정
          textField.isUserInteractionEnabled = false
        } // end of closure add.TextField(textField in)
        
        // 취소 Action
        let cancelAction = UIAlertAction(title: "취소" , style: .cancel)
        
        // 완료 Action
        let completedAction = UIAlertAction(title: "완료", style: .default, handler: { ACTION in
          print("완료 ACTION")
          
          // 완료 부분 로직 추가 예정
          
          
//          // guard let Text 내용 fetch
//          guard let  inputEditedText = completedCheckAlert.textFields?.first?.text else {return}
//
//          
//          let result = todolistDB.updateDB(
//            id:         self.dataArray[indexPath.row].id,
//            text:       inputEditedText,
//            status:     self.dataArray[indexPath.row].status,
//            seq:        self.dataArray[indexPath.row].seq
//          )
//          
//          if result {
//            // 수정이 완료 되었을때
//            let completeAlert = UIAlertController(title: "결과", message: "수정이 완료 되었습니다.", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "확인", style: .default)
//            
//            completeAlert.addAction(okAction)
//            self.present(completeAlert, animated: true)
//            self.reloadAction()
//              
//          } else {
//            // 수정에 문제가 있을때
//            let insertFailAlert = UIAlertController(title: "결과", message: "수정에 실패 했습니다.", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "확인", style: .default)
//            
//            insertFailAlert.addAction(okAction)
//            self.present(insertFailAlert, animated: true)
//            self.reloadAction()
//            
//          } // if result - else
          
        })  // end of closure handler(ACTION in)
        
        // 미완료 Action
        let nonCompletedAction = UIAlertAction(title: "미완료", style: .default	, handler: { ACTION in
          print("미완료 ACTION")
          
          // 미완료 부분 로직 추가 예정
          
        })  // end of closure UIAlertAction(handler(ACTION in))
        
        completedCheckAlert.addAction(nonCompletedAction)
        completedCheckAlert.addAction(completedAction)
        completedCheckAlert.addAction(cancelAction)
        
        // 미완료 Action을 기본 작업으로 설정
        completedCheckAlert.preferredAction = nonCompletedAction
        
        present(completedCheckAlert,animated: true)
        
        
      } // end of if let indexPath
      
    } // end of if sender.state

  } // end of Object C functions longPress(UILongPressGestureRecognizer)
  
  
  // MARK: -- View Init
  override func viewDidLoad() {
    super.viewDidLoad()
    reloadAction()
    
    // TableView Cell Longpress 로직
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
    tableView.addGestureRecognizer(longPress)
  } // end of functions viewDidLoad()
  
  override func viewWillAppear(_ animated: Bool) {
    reloadAction() // DB data 다시 불러오기
  } // end of functions viewWillAppear()
  
  // MARK: -- Functions
  
  // MARK: Reload data
  func reloadAction() {
    let todoList = TodoListDB()
    dataArray.removeAll()
    todoList.delegate = self
    todoList.queryDB()
    tvListView.reloadData()
  } // end of functions reloadAction()
  
  // MARK: -- Table view data source
  // Table Columns
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  } // end of functions numberOfSections()
  // Table Rows
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return dataArray.count
  } // end of functions tableView(numberOfRowsInSection)
  
  // Table Cell content 생성
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
    
    var content = cell.defaultContentConfiguration()
    content.text = dataArray[indexPath.row].todoText
    content.image = UIImage(systemName: "pencil.circle")
    cell.contentConfiguration = content
    
    return cell
  } // end of functions tableView(cellForRowAt)
  
  
  // MARK: -- Actions
  //
  // MARK: -- 1. Insert Action button
  @IBAction func btnInsert(_ sender: Any) {
    // Query Model instance
    let todolistDB = TodoListDB()
    // Alert Controller
    let addAlert = UIAlertController(title: "Todo List", message: "추가할 내용을 입력하세요.", preferredStyle: .alert)
    
    // todo list insert 할 내용 입력 tf
    addAlert.addTextField { textField in
      textField.placeholder = "내용을 입력하세요"
    }
    
    // 취소 action
    let cancelAction = UIAlertAction(title: "취소" , style: .cancel)
    
    // ADD action
    let addAction = UIAlertAction(title: "네", style: .default, handler: {ACTION in
      // guard let Text 내용 fetch
      guard let  inputTodoText = addAlert.textFields?.first?.text else {return}
      // todo 입력 일 생성
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      // 현재 일자
      let currentDate = Date()
      let insertDate = dateFormatter.string(from: currentDate)
      let isComplete = 0 // todo 완료 여부
      
      let result = todolistDB.insertDB(text: inputTodoText, insertdate: insertDate, compledate: "", status: isComplete, seq: 1)
      
      if result{
        // 입력이 완료 되었을때
        let completeAlert = UIAlertController(title: "결과", message: "입력이 완료 되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        
        completeAlert.addAction(okAction)
        self.present(completeAlert, animated: true)
        self.reloadAction()
          
      }else{
        // 입력에 문제가 있을때
        let insertFailAlert = UIAlertController(title: "결과", message: "입력에 실패 했습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        
        insertFailAlert.addAction(okAction)
        self.present(insertFailAlert, animated: true)
        self.reloadAction()
        
      } // if - esle
    }) // action closer end
    addAlert.addAction(cancelAction)
    addAlert.addAction(addAction)
    present(addAlert,animated: true)
    
  } // end of functions btnInsert()
  
  // Delete Action button
  // MARK: -- 2. Delete Cell
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        
      // SQLite 에서 삭제하는 쿼리 실행
      let todoListDB = TodoListDB()
      let result = todoListDB.deleteDB(id: dataArray[indexPath.row].id)
      if result{
          print("DB 에서 삭제 되었습니다.")
          //self.readValue()
      }
      
      // Delete the row from the data source
      dataArray.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      
    } else if editingStyle == .insert {
    }
    
  } // end of functions tableView(commit editingStyle, forRowAt)
  
  // delete swipe message
  override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "삭제!"
  } // end of functions tableView(titleForDeleteConfirmationButtonForRowAt)
  
  // MARK: -- 삭제 swife 후 목록 순서 바꾸기
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    // 이동할 item 의 복사
    let itemToMove = dataArray[fromIndexPath.row]
    // 이동할 item 의 삭제
    dataArray.remove(at: fromIndexPath.row)
    // 이동할 위치에 insert 한다.
    dataArray.insert(itemToMove, at: to.row)
  }
  
  // MARK: -- Cell Click 시 Actions (didselectrow)
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    // Query Model instance
    let todolistDB = TodoListDB()
    // Alert Controller
    let editAlert = UIAlertController(title: "Todo List", message: "수정할 내용을 입력하세요.", preferredStyle: .alert)
    
    // todo list insert 할 내용 입력 tf
    editAlert.addTextField { textField in
      textField.text = self.dataArray[indexPath.row].todoText
    }
    
    // 취소 action
    let cancelAction = UIAlertAction(title: "취소" , style: .cancel)
    
    // EDIT action
    let addAction = UIAlertAction(title: "네", style: .default, handler: {ACTION in
      // guard let Text 내용 fetch
      guard let  inputEditedText = editAlert.textFields?.first?.text else {return}

      
      let result = todolistDB.updateDB(
        id:         self.dataArray[indexPath.row].id,
        text:       inputEditedText,
        status:     self.dataArray[indexPath.row].status,
        seq:        self.dataArray[indexPath.row].seq
      )
      
      if result{
        // 수정이 완료 되었을때
        let completeAlert = UIAlertController(title: "결과", message: "수정이 완료 되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        
        completeAlert.addAction(okAction)
        self.present(completeAlert, animated: true)
        self.reloadAction()
          
      }else{
        // 수장에 문제가 있을때
        let insertFailAlert = UIAlertController(title: "결과", message: "수정에 실패 했습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        
        insertFailAlert.addAction(okAction)
        self.present(insertFailAlert, animated: true)
        self.reloadAction()
        
      } // if - esle
      
    }) // action closer end
    editAlert.addAction(cancelAction)
    editAlert.addAction(addAction)
    present(editAlert,animated: true)
    
  } // end of functions tableView(didSelectRowAt)
  
} // end of class TableViewController: UITableViewController


// MARK: -- Extensions
// todoList VM data download
extension TableViewController: QueryModelProtocol {
  func itemDownloaded(items: [TodoList]) {
    dataArray = items
    tvListView.reloadData()
  }
} // end of extension TableViewController: QueryModelProtocol
