//
//  CodeCollectionViewCell.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 20.06.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit

class CodeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backGroudnView: UIView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var progressBarView: MBCircularProgressBarView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var codeBackGroundView: UIView!
    @IBOutlet weak var codeLabel: UILabel!
    
    var indexCell:Int = 0
    var actionOkButtonBlock : ((UIButton, Int) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.okButton.layer.masksToBounds = true
        self.okButton.layer.cornerRadius = 21.5
        
        self.backGroudnView.layer.masksToBounds = true
        self.backGroudnView.layer.cornerRadius = 10
        
        self.codeBackGroundView.layer.masksToBounds = true
        self.codeBackGroundView.layer.cornerRadius = 15
        self.codeBackGroundView.layer.borderWidth = 1
        self.codeBackGroundView.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func actionOkButton(_ sender: UIButton) {
        
        self.actionOkButtonBlock!(sender, self.indexCell)
    }
}
