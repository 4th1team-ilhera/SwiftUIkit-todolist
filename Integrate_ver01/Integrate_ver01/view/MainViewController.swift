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
        2024.05.19 by pdg, pjh: vc 에서 기능구현 통합
            - vc 기능 테스트 -> 통합
            - 입력수정 삭제 기능 -> 통합
 
    Detail :
        - 주요 변수, DB column
    Bundle : com.swiftlec.SQLiteTodoAdvanced

*/


import UIKit

class MainViewController: UIViewController {
    //MARK: -- UI interfaces
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tvListView: UITableView!
    var dataArray: [TodoList] = []
    
    //MARK: -- segue property정의
    var searchText : String? //검색어 입력시 검색 데이터를 담기위한 변수
    
    
    // MARK: -- View DidInit
    override func viewDidLoad() {
        super.viewDidLoad()
        tvListView.dataSource = self
        tvListView.delegate = self
        reloadAction()
        print("검색 테스트")
    }
    // MARK: -- View Will Init
    override func viewWillAppear(_ animated: Bool) {
        if searchText == nil {
               reloadAction() // DB data 다시 불러오기(검색어 없는경우에만)
           }
        
    }
    func reloadAction() {
        let todoList = TodoListDB()
        dataArray.removeAll()
        todoList.delegate = self
        todoList.queryDB()
        tvListView.reloadData()
    }
    //검색을 위한 함수
    func searchAction(searchText: String){
        let todoList = TodoListDB()
        dataArray.removeAll()
        todoList.delegate = self
        print("searchAction실행")
        todoList.searchQueryDB(searchText: searchText)
        tvListView.reloadData()
    }
    
    @IBAction func btnInsertAction(_ sender: Any) {
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
            }// if - esle
        }) // action closer end
        addAlert.addAction(cancelAction)
        addAlert.addAction(addAction)
        present(addAlert,animated: true)
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        print("검색버튼 실행됨")
        searchText = tfSearch.text ?? ""
        let todoList = TodoListDB()
        dataArray.removeAll()
        todoList.delegate = self
        print("searchAction실행")
        searchAction(searchText: searchText!)
        tvListView.reloadData()
    }
    
  
    
}
// Extension Table view data source, delegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate{
    // Table columns
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    // Table rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    // table data source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = dataArray[indexPath.row].todoText
        content.image = UIImage(systemName: "pencil.circle")
        cell.contentConfiguration = content
        return cell
    }
    // Table row Delete Swife actions
    // Delete Action button
    // MARK: -- 2. Delete Cell
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    }
    // delete swipe message
     func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제!"
    }
    
    // MARK: -- 삭제 swife 후 목록 순서 바꾸기
     func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        // 이동할 item 의 복사
        let itemToMove = dataArray[fromIndexPath.row]
        // 이동할 item 의 삭제
        dataArray.remove(at: fromIndexPath.row)
        // 이동할 위치에 insert 한다.
        dataArray.insert(itemToMove, at: to.row)
    }
    // cell clikc 시 Actions (didselectrow)
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            }// if - esle
        }) // action closer end
        editAlert.addAction(cancelAction)
        editAlert.addAction(addAction)
        present(editAlert,animated: true)
        
    }
}

// DB Model Extension

extension MainViewController: QueryModelProtocol {
    func itemDownloaded(items: [TodoList]) {
        dataArray = items
        tvListView.reloadData()
    }
}

