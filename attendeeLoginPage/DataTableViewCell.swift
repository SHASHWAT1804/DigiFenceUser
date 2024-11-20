//
//  DataTableViewCell.swift
//  EP
//
//  Created by admin85 on 04/11/24.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    @IBOutlet weak var activatePassButton: UIButton!
    @IBOutlet weak var Locate: UIButton!
    
    @IBOutlet weak var epassCardView: UIView!
    @IBOutlet weak var infotapped: UIButton!
}
