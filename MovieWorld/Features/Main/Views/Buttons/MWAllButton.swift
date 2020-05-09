//
//  MWAllButton.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/7/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import Foundation
import UIKit

class MWAllButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitle("All ", for: .normal)
        self.setImage(UIImage(named: "nextArrow"), for: .normal)
        self.semanticContentAttribute = .forceRightToLeft
        self.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        self.backgroundColor = UIColor(named: "mainAllButtonColor")
        self.layer.cornerRadius = 5
        self.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
