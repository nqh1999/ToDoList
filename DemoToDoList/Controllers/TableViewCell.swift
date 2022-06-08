//
//  TableViewCell.swift
//  DemoToDoList
//
//  Created by Nguyen Quang Huy on 24/05/2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var incompleteButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var taskTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        completeButton.isHidden = true
        taskTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
    }
    @IBAction func incompleteButtonTapped(_ sender: Any) {
        completeButton.isHidden = false
        incompleteButton.isHidden = true
        strikethroughStyle(isDone: true)
    }
    @IBAction func completeButtonTapped(_ sender: Any) {
        incompleteButton.isHidden = false
        completeButton.isHidden = true
        strikethroughStyle(isDone: false)
    }
    
    func strikethroughStyle(isDone: Bool) {
        let attributeString = NSMutableAttributedString(string: taskTextField.text!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: isDone ? 1 : 0, range: NSRange(location: 0, length: attributeString.length))
        taskTextField.textColor = isDone ? .darkGray : .black
        taskTextField.isEnabled = isDone ? false : true
        taskTextField.attributedText = attributeString
    }
}

extension TableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
