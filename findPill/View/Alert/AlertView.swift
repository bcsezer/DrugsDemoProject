//
//  AlerView.swift
//  findPill
//
//  Created by Cem on 2.05.2021.
//

import Foundation
import UIKit

class AlertView: UIView {
    
    static let instance = AlertView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var drugName: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var categoriesArray = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        setupInıt()
        setupTextView()
        setupCategoryList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInıt(){
        
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 5
        
        parentView.frame = CGRect(x: 0, y: 0,
                                  width: UIScreen.main.bounds.width,
                                  height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        containerView.addGestureRecognizer(gesture)
        parentView.addGestureRecognizer(gesture)
        
    }
    
    @objc func dismissView(){
        self.endEditing(true)
    }
    
    private func setupTextView(){
        textView.layer.cornerRadius = 3
        textView.layer.masksToBounds = true
    }
    private func setupCategoryList(){
        pickerView.dataSource = self
        pickerView.delegate = self
        categoriesArray = ["Pain","Heart","Diabeties","Cold","Muscle Pain","Blood Tension","Antibiotic"]
    }
   public func showAlert(){
    
    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(parentView)
       
    }
    @IBAction func doneButtonCliked(_ sender: Any) {
        parentView.removeFromSuperview()
    }
}

extension AlertView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categoriesArray[row]
    }
}

