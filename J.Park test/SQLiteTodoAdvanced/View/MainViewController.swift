//
//  MainViewController.swift
//  SQLiteTodoAdvanced
//
//  Created by 박동근 on 5/19/24.
//

import UIKit

class MainViewController: UIViewController {
    // UI interface
    @IBOutlet weak var tvList: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    
    // Propeties
    var dataArray : [TodoList] = []
    var searchText = "" //검색어 입력시 검색 데이터를 담기위한 변수

    override func viewDidLoad() {
        super.viewDidLoad()
        tvList.dataSource = self
        tvList.delegate = self
        reloadAction()
        print("검색 테스트")
    }
    // MARK: -- Functions
    func reloadAction() {
        let todoList = TodoListDB()
        dataArray.removeAll()
        todoList.delegate = self
        todoList.queryDB()
        tvList.reloadData()
    }
    //검색을 위한 함수
    func searchAction(searchText: String){
        let todoList = TodoListDB()
        dataArray.removeAll()
        todoList.delegate = self
        print("searchAction실행")
        todoList.searchQueryDB(searchText: searchText)
        tvList.reloadData()
    }

    // MARK: -- ACTIONS
    
    
    @IBAction func btnSearch(_ sender: UIButton) {
        print("검색버튼 실행됨")
        searchText = tfSearch.text ?? ""
        let todoList = TodoListDB()
        dataArray.removeAll()
        todoList.delegate = self
        print("searchAction실행")
        searchAction(searchText: searchText)
        tvList.reloadData()
    }
    
}
// MARK: Extension

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
        tvList.reloadData()
    }
}

