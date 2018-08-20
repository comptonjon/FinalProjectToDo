//
//  TaskCell.swift
//  FinalProjectToDo
//
//  Created by Jonathan Compton on 8/19/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

let CORNER_RADIUS : CGFloat = 8

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = CORNER_RADIUS
        cellContainerView.layer.cornerRadius = CORNER_RADIUS
        cellContainerView.layer.shadowRadius = 4
        cellContainerView.layer.shadowOpacity = 0.4
        cellContainerView.layer.shadowOffset = CGSize(width: 4, height: 4)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
