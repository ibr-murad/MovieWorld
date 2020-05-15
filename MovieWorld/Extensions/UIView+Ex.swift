//
//  UIView+Ex.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/14/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}
