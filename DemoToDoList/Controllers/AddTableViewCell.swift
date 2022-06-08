//
//  addTableViewCell.swift
//  DemoToDoList
//
//  Created by Nguyen Quang Huy on 08/06/2022.
//

import UIKit

class AddTableViewCell: UITableViewCell {

    @IBOutlet weak var addButton: UIButton!
    var taskProtocol: TaskProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        taskProtocol?.createTask(title: "Huy", isDone: false)
    }
}
