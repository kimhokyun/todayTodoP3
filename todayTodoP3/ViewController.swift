//
//  ViewController.swift
//  todayTodoP3
//
//  Created by 82205 on 2023/08/03.
//

import UIKit
protocol sendDataProtocol{
    func receiveData(Response:Todo)
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var todoList:[Todo] = []{
        didSet{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(self.todoList) {
                UserDefaults.standard.setValue(encoded, forKey: "todoList")
            }
            
            self.todoList = self.todoList.filter({$0.time > Date.now})
            self.todoList = self.todoList.sorted(by: {$0.time < $1.time})
            
            self.tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let decoder: JSONDecoder = JSONDecoder()
        if let data = UserDefaults.standard.object(forKey: "todoList") as? Data,
           let todoList = try? decoder.decode([Todo].self, from: data) {
            self.todoList = todoList
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(fromBg), name: Notification.Name("Refresh"), object: nil)
        
    }

    @IBAction func plusBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen // fullscreen으로 해야 viewWillAppear 을 호출함
        
        self.present(vc, animated: true)
    }
    
    @objc func fromBg(){
        self.todoList = self.todoList.filter({$0.time > Date.now})
    }
}

extension ViewController:sendDataProtocol{
    func receiveData(Response: Todo) {
        self.todoList.append(Response)
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let todo = self.todoList[indexPath.row]
        
        cell.titleLabel.text = todo.title
        cell.timeLabel.text = "[\(makeTimeFormat(format: "a hh:mm",date: todo.time))]"
        
        return cell
    }
    
    
    
}
