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
   
    //MARK:Classes
    let textRecognitionManager = TextRecognizerManager()
    var loading = LoadingScreen()
    let overlayView = OverlayView()
    

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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("gidiyorum")
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
     
        showMiracle()
    }
    
    private func clearUI(){
    
        self.textLabel.text = ""
        self.infoLabel.text = "Click on the picture icon above to get the name of the drug."
        self.imageView.image = UIImage(named: "chooseAnImage")
        self.saveName.isHidden = true
       }
  
}


extension HomeViewController : TextRecognizerManagerDelegate{
    func errorOccurs(error: String) {
        
        DispatchQueue.main.async {
            self.textLabel.text =  "Please try again. Make sure the camera is focused on the text."
            self.loading.showUniversalLoadingView(false)
            self.saveName.isHidden = true
            self.infoLabel.text = "Click on the picture icon above to get the name of the drug."
            
        }
    }
    
    
    func didStartTextRecognition(detectedWord: String) {
        
       
            DispatchQueue.main.async {
                self.textLabel.text =  detectedWord
                self.loading.showUniversalLoadingView(false)
                self.saveName.isHidden = false
                self.infoLabel.text = "If you want you can add this drug to your favorites!"
                
            }
        
       
    }

    @objc func showMiracle() {
        let slideVC = overlayView
        pushModal.pushModal(viewController: slideVC ,animated: true, heightRatio: 0.9, isPan: true, isPanEnabled: true, navigation: self.navigationController!)
        
    }
    
    
}
extension HomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
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

