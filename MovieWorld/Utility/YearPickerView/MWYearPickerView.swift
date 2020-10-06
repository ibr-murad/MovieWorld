//
//  MWYearPickerView.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 9/24/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit

class MWYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Public Variables
    
    var didSelectedAtRow: ((Int) -> Void)?
    var year: Int = 0 {
        didSet {
            selectRow(self.years.firstIndex(of: year)!, inComponent: 0, animated: true)
        }
    }
    
    // MARK: - Private Variables
    
    private var years: [Int] = []
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        self.delegate = self
        self.dataSource = self
        
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...200 {
                years.append(year)
                year -= 1
            }
        }
        
        self.years = years
        self.year = 2017
    }
    
    // MARK: - UIPicker Delegate, Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(years[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = years[self.selectedRow(inComponent: 0)]
        self.year = year
        self.didSelectedAtRow?(year)
    }
    
}
