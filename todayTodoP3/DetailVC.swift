//
//  DetailVC.swift
//  todayTodoP3
//
//  Created by 82205 on 2023/08/03.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var timeDatePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    var delegate:sendDataProtocol?
    var todo:Todo?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        guard let t = self.titleTextField.text, t.isEmpty == false else {
            showAlert("제목을 입력하세요")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let formattedTime = formatter.date(from: formatter.string(from: self.timeDatePicker.date)), formattedTime > formatter.date(from: formatter.string(from: Date.now))! else {
            showAlert("현재시간보다 나중 시간을 입력하세요")
            return
        }
        
        self.todo = Todo(title: t, time: formattedTime)
        
        guard let td = self.todo else {return}
        delegate?.receiveData(Response: td)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: td.time)
        UNUserNotificationCenter.current().addNotificationRequest(by: components, id: UUID().uuidString, todo : td)
        
        self.dismiss(animated: true)
    }

    func showAlert(_ msg:String,_ handler:(() -> Void)? = nil) {
        let alert = UIAlertController(title: "알림", message: msg, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { action in
            handler?()
        }
        alert.addAction(confirm)
        present(alert, animated: false)
    }

}

extension UNUserNotificationCenter {
    func addNotificationRequest(by date: DateComponents, id: String, todo : Todo) {
        
        // content 만들기
        let content = UNMutableNotificationContent()
        content.title = todo.title
        content.body = "알림 바디 부분" + "\(todo.time)"
        content.sound = .default
        content.badge = 1
        
        // trigger 만들기
//        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: todo.time)
//        print("comps : \(comps)")
        let trigger = UNCalendarNotificationTrigger(dateMatching:  date , repeats: false)
        
        // request 만들기
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        self.add(request, withCompletionHandler: nil)
    }
}
