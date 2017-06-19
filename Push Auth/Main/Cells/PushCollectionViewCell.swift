//
//  PushCollectionViewCell.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 16.06.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit

class PushCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backGroudnView: UIView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var progressBarView: MBCircularProgressBarView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var indexCell:Int = 0
    var actionYesButtonBlock : ((UIButton, Int) -> Void)? = nil
    var actionNoButtonBlock : ((UIButton, Int) -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()

        self.yesButton.layer.masksToBounds = true
        self.yesButton.layer.cornerRadius = 21.5
        
        self.noButton.layer.masksToBounds = true
        self.noButton.layer.cornerRadius = 21.5
        
        self.backGroudnView.layer.masksToBounds = true
        self.backGroudnView.layer.cornerRadius = 10
    }
    
    @IBAction func actionYesButton(_ sender: UIButton) {
        
        self.actionYesButtonBlock!(sender, self.indexCell)
    }
    
    @IBAction func actionNoButton(_ sender: UIButton) {
        
        self.actionNoButtonBlock!(sender, self.indexCell)
    }
}
