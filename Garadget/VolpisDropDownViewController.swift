//
//  VolpisDropDownViewController.swift
//  Garadget
//
//  Created by Volpis on 10.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

protocol DropDownProtocol {
    func didAskUpdateData(value: String)
    func didAskCloseVC()
}

class VolpisDropDownViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var dataPickerView: UIPickerView!
    
    var delegate: DropDownProtocol? = nil
    var currentData: [String] = [String]()
    var currentParticleKey: String = ""
    var selectedValue: String = ""
    
    var keys: [String] = [String]()
    var values: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareData()
    }

    func prepareData() {
        var row: Int = 0
        for (index, item) in self.currentData.enumerated() {
            let arr = item.components(separatedBy: "|")
            self.keys.append(arr[0])
            self.values.append(arr[1])
            if arr[0] == self.selectedValue {
                row = index
            }
        }
        self.dataPickerView.selectRow(row, inComponent: 0, animated: true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // MARK: - UIPickerViewDelegate and UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.keys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.keys[row]
    }

    // MARK: - Actions
    @IBAction func didPressDoneButton(_ sender: Any) {
        self.delegate?.didAskUpdateData(value: "\(self.currentParticleKey)=\(self.values[self.dataPickerView.selectedRow(inComponent: 0)])")
    }

    @IBAction func didPressCancelButton(_ sender: Any) {
        self.delegate?.didAskCloseVC()
    }
}
