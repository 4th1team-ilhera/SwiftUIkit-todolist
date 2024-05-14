// MARK: Description
/*
    Description : Search Todo List View Controller
    Date : 2024.5. 11
    Author : Ilhera
    Updates :
         2024.05.11 by pdg : search todo list 작업
            - table search 기능 되는 view controller 생성
            - storyboard design 수정
            - container view 를 통한 tableview 가져오기 성공
            - insert 한후에 table view 를 reload 해주어야하는데 view controller
               self 를 사용할수 없는 문제 발생
            - 화면 내에서 수정, 삭제 기능 잘 됨..
    Detail :
        - 주요 변수, DB column
    Bundle : com.swiftlec.SQLiteTodoAdvanced

*/
import UIKit

class SearchTodoViewController: UIViewController {

    @IBOutlet weak var containerTableView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
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
//                self.reloadAction()
                
            }else{
                // 입력에 문제가 있을때
                let insertFailAlert = UIAlertController(title: "결과", message: "입력에 실패 했습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                
                insertFailAlert.addAction(okAction)
                self.present(insertFailAlert, animated: true)
//                self.reloadAction()
            }// if - esle
        }) // action closer end
        addAlert.addAction(cancelAction)
        addAlert.addAction(addAction)
        present(addAlert,animated: true)
    }
    
    @IBAction func btnSearch(_ sender: Any) {
    }
}
