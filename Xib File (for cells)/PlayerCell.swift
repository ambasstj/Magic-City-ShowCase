//
//  PlayerCell.swift
//  Magic City Showcase
//
//  Created by Tevin Jones on 3/27/23.
//

import UIKit

class PlayerCell: UITableViewCell {
    
    @IBOutlet weak var playerschool: UILabel!
    
    
    @IBOutlet weak var addPhoto: UIButton!
    
    @IBOutlet weak var playerlocation: UILabel!
    
    
    @IBOutlet weak var playername: UILabel!
    
    
    @IBOutlet weak var position: UILabel!
    
    
    @IBOutlet weak var numberonChest: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var playerSnapshot: UIImageView!
    
    @IBOutlet weak var graduatingClass: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    playerSnapshot.layer.cornerRadius = frame.size.height / 8
        
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    
    
    
}


 


