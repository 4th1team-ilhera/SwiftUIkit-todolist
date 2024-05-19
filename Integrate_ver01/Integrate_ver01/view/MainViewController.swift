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
 
    Detail :
        - 주요 변수, DB column
    Bundle : com.swiftlec.SQLiteTodoAdvanced

*/


import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tvListView: UITableView!
    var dataArray: [TodoList] = []
    
    //MARK: -- segue property정의
    var searchText = "" //검색어 입력시 검색 데이터를 담기위한 변수
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tvListView.dataSource = self
           tvListView.delegate = self
        
        
        reloadAction()
        print("검색 테스트")
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
        searchAction(searchText: searchText)
        tvListView.reloadData()
    }
    
  
    
}
extension MainViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = dataArray[indexPath.row].todoText
        content.image = UIImage(systemName: "pencil.circle")
        cell.contentConfiguration = content
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
}

extension MainViewController: QueryModelProtocol {
    func itemDownloaded(items: [TodoList]) {
        dataArray = items
        tvListView.reloadData()
    }
}

