//
//  OverlayView.swift
//  findPill
//
//  Created by Cem on 19.05.2021.
//

import Foundation
import UIKit


class OverlayView: UIViewController {
    var mainImage:String!
    var textLabel:String!
    var favButton:Bool!
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    @IBOutlet weak var slideIdicator: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak  var drugName: UILabel!
   
    

    
    //MARK:FavoritesArray Singleton class
    var favoritesSkeleton = FavoritesArray.shared.favoriteArray
    //MARK: UserDefaults
    let favorites = UserDefaults.standard
    
    var categoriesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        noteTextView.delegate = self
        slideIdicator.roundCorners(.allCorners, radius: 10)
        doneButton.roundCorners(.allCorners, radius: 10)
        setupCategoryList()
        print(view.frame.size.height)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
     
    }
    private func setupCategoryList(){
        pickerView.dataSource = self
        pickerView.delegate = self
       
        categoriesArray = ["Pain","Heart","Diabeties","Cold","Muscle Pain","Blood Tension","Antibiotic","Anxiety","Other"]
    }
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @IBAction func doneButtonClicked(_ sender: Any) {
        loadDataFromUserDefaults()
        addNewItemsOnFavoriteArray()
       
    
    }
    private func setupTextView(){
        noteTextView.layer.cornerRadius = 3
        noteTextView.layer.masksToBounds = true
        
    }
  
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        let halfOfTheScreen = UIScreen.main.bounds.height/2
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            
            if (view.frame.origin.y > halfOfTheScreen) || dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
                
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
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
              
                SecondTypeAlert.showAlert(on: self, with: "Error", Message: "sex")
            } else {
                //If it is not, add selected news to favorite userDefaults object
                
                do {
                    let data = PillModel(name: text, note: noteTextView.text, category: categoryTextField.text)
                    favoritesSkeleton.append(data) //Firstly, add selected article array to singleton array
                    
                    try favorites.setObject(favoritesSkeleton, forKey: "userFavorites") //Than add to userDefaults
                  
                    self.dismiss(animated: true, completion: nil)
                    
                }catch{
                    
                    
                    print(error.localizedDescription)
                }
            }
           
        }
    }
}
extension OverlayView: UIPickerViewDataSource, UIPickerViewDelegate {
    
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

extension OverlayView: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
       if noteTextView.text != ""{
        
        noteTextView.text = ""
        
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"
            {
            noteTextView.resignFirstResponder()
                return false
        }
            return true
    }
}
