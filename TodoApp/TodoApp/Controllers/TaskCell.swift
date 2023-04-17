//
//  TaskCell.swift
//  TodoApp
//
//  Created by Ola Łuczywek on 14/04/2023.
//

import UIKit
import CoreData

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskBuble: UIView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var taskCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskBuble.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setName(text: String) {
        taskName.text = text
    }
    
    func setDate (date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        taskDate.text = dateFormatter.string(from: date)
    }
    
    func setCategory (category: String) {
        taskCategory.text = category
    }
}
