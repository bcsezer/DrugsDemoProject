//
//  AlerView.swift
//  findPill
//
//  Created by Cem on 2.05.2021.
//

import Foundation
import UIKit
import SwiftGifOrigin

protocol UpdateUIDelegate:AnyObject {
    func didUpdateUI(label:String,InitialImage:String,button:Bool)
}
class AlertView: UIView {
    var mainImage:String!
    var textLabel:String!
    var favButton:Bool!
    static let instance = AlertView()
    //MARK:FavoritesArray Singleton class
    var favoritesSkeleton = FavoritesArray.shared.favoriteArray
    var nameLabel : String?
    //MARK: UserDefaults
    let favorites = UserDefaults.standard
    weak var delegate: UpdateUIDelegate?
    let vc = HomeViewController()
    
    @IBOutlet weak var checkImage: UIImageView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var drugName: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var checkContainer: UIView!
    
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
        checkContainer.layer.cornerRadius = 5
        checkContainer.layer.masksToBounds = true
        
    }
    
    private func setupTextView(){
        textView.layer.cornerRadius = 3
        textView.layer.masksToBounds = true
        closeButton.layer.cornerRadius = 0.5 * closeButton.bounds.size.width
            closeButton.clipsToBounds = true
    }
    private func setupCategoryList(){
        pickerView.dataSource = self
        pickerView.delegate = self
        textView.delegate  = self
        categoriesArray = ["Pain","Heart","Diabeties","Cold","Muscle Pain","Blood Tension","Antibiotic","Other"]
    }
    
   public func showAlert(){
    
    containerView.isHidden = false
    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(parentView)
    
    UIView.animate(withDuration: 0.3, animations: {
        self.parentView.alpha = 1
    })
   
   
       
    }
    
    @IBAction func doneButtonCliked(_ sender: Any) {
        loadDataFromUserDefaults()
        addNewItemsOnFavoriteArray()
        containerView.isHidden = true
        checkImage.loadGif(name: "giphy")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.clearUI()
            self.parentView.removeFromSuperview()
            
        }
       
        
    }
    @IBAction func closeButtonClicked(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.parentView.alpha = 0
        }) { (finished) in
            self.parentView.removeFromSuperview()
        }
       
    }
    func clearUI(){
        
        mainImage = "chooseAnImage"
        textLabel = "Click on the picture icon above to get the name of the drug."
        favButton = true
        
        self.delegate?.didUpdateUI(label: self.textLabel, InitialImage: self.mainImage, button: self.favButton)
        
      }
    
    private func loadDataFromUserDefaults(){
        do{
            //while the page is loading, I load array from Userdefaults
            favoritesSkeleton = try favorites.getObject(forKey: "userFavorites", castTo: [PillModel].self)
           
        }catch{
            print(error.localizedDescription)
        }
       
    }
    private func addNewItemsOnFavoriteArray(){
     
            
            //Check array contains selected news
        if let text = drugName.text{
            if favoritesSkeleton.contains(where: {$0.name == text}) {
                
            } else {
                //If it is not, add selected news to favorite userDefaults object
                
                do {
                    let data = PillModel(name: text, note: textView.text, category: categoryTextField.text)
                    favoritesSkeleton.append(data) //Firstly, add selected article array to singleton array
                    
                    try favorites.setObject(favoritesSkeleton, forKey: "userFavorites") //Than add to userDefaults
                    
                    
                }catch{
                    
                    
                    print(error.localizedDescription)
                }
            }
           
        }
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

extension AlertView: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
       if textView.text != ""{
        
            textView.text = ""
        
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"
            {
                textView.resignFirstResponder()
                return false
        }
            return true
    }
}
