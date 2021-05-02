//
//  ViewController.swift
//  findPill
//
//  Created by Cem on 1.05.2021.
//AIzaSyAqD2uLHcqEMHM-9yA3MNDNY_8CVLaVfgk

import UIKit
import Vision

class HomeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var saveName: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    //Classes
    let textRecognitionManager = TextRecognizerManager()
    var loading = LoadingScreen()
    
    //MARK:FavoritesArray Singleton class
    var favoritesSkeleton = FavoritesArray.shared.favoriteArray
    
    //MARK: UserDefaults
    let favorites = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickImage))
        imageView.addGestureRecognizer(gesture)
        textRecognitionManager.delegate = self
        infoLabel.text = "Click on the picture icon above to get the name of the drug."
       
        // Do any additional setup after loading the view.
    }
    @objc func clickImage(){
        pickImage()
    }
    private func pickImage(){
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        saveName.isHidden = true
      
        
    }
    func setupButton(){
        saveName.isHidden = true
        saveName.layer.masksToBounds = true
        saveName.layer.cornerRadius = 5
        saveName.layer.borderWidth = 1
        saveName.layer.borderColor = #colorLiteral(red: 0.1269942271, green: 1, blue: 0.2875748878, alpha: 1)
    }
    @IBAction func addToFavoritesButtonClicked(_ sender: Any) {
        AlertView.instance.showAlert()
//        loadDataFromUserDefaults()
//        addNewItemsOnFavoriteArray()
    }
    private func loadDataFromUserDefaults(){
        do{
            //while the page is loading, I load array from Userdefaults
            favoritesSkeleton = try favorites.getObject(forKey: "userFavorites", castTo: [String].self)
           
        }catch{
            print(error.localizedDescription)
        }
       
    }
    private func addNewItemsOnFavoriteArray(){
     
            
            //Check array contains selected news
        if let text = textLabel.text{
        if favoritesSkeleton.contains(where: {$0 == text}) {
                
            } else {
                //If it is not, add selected news to favorite userDefaults object
                
                do {
                    favoritesSkeleton.append(text) //Firstly, add selected article array to singleton array
                    
                    try favorites.setObject(favoritesSkeleton, forKey: "userFavorites") //Than add to userDefaults
                    
                    
                }catch{
                    
                    
                    print(error.localizedDescription)
                }
            }
           
        }
    }
    
}

extension HomeViewController : TextRecognizerManagerDelegate{
    
    func didStartTextRecognition(detectedWord: String) {
        
        if  detectedWord != ""  {
            DispatchQueue.main.async {
                self.textLabel.text =  String(detectedWord.dropLast())
                self.loading.showUniversalLoadingView(false)
                self.saveName.isHidden = false
                self.infoLabel.text = "If you want you can add this drug to your favorites!"
                
            }
        }else{
            DispatchQueue.main.async {
                self.textLabel.text =  "Please try again. Make sure the camera is focused on the text."
                self.loading.showUniversalLoadingView(false)
                self.saveName.isHidden = true
                self.infoLabel.text = "Click on the picture icon above to get the name of the drug."
                
            }
        }
       
    }
    
    
}

extension HomeViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        // print out the image size as a test
        imageView.image = image
        textRecognitionManager.recognizeText(image: imageView.image)
    }
}

