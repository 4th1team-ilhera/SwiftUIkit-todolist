// MARK: Description
/*
    Description : Model  TodoList)
    Date : 2024.5. 10
    Author : Ilhera
    Updates :
         2024.05.10  by pdg
            - 주석 생성
        2024.04.11 by pdg
            - delete 시 필요한 id 가 없는 것을 확인..
            - 모델에 id 추가!!
    Detail : -
    Bundle : com.swiftlec.SQLiteTodoAdvanced

*/


struct TodoList {
    var id: Int // Auto increment id
    var todoText: String //a todo task
    var insertDate: String // insert date
    var compleDate: String // complete date(tdo 완료 일자)
    var status: Int // 0: 미완료, 1: 완료
    var seq: Int // table 순서 변경 을 위한 파라미터
    
    init(id: Int, todoText: String, insertDate: String, compleDate: String, status: Int, seq: Int) {
        self.id = id
        self.todoText = todoText
        self.insertDate = insertDate
        self.compleDate = compleDate
        self.status = status
        self.seq = seq
    }
}
