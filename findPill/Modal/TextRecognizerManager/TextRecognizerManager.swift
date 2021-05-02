//
//  TextRecognizerManager.swift
//  findPill
//
//  Created by Cem on 1.05.2021.
//

import Foundation
import Vision
import UIKit

protocol  TextRecognizerManagerDelegate:AnyObject{
    func didStartTextRecognition(detectedWord:String)
}


class TextRecognizerManager{
    var loading = LoadingScreen()
    
    weak var delegate:TextRecognizerManagerDelegate?
    

    var text = ""
     func recognizeText(image:UIImage?){
        loading.showUniversalLoadingView(true)
        guard let cgImage = image?.cgImage else {
            fatalError("Could not get image")
        }
        //Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        //Request
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            let textArray = observations.compactMap({
                $0.topCandidates(1).first?.string
            })
            
            for name in textArray{
                if name.contains("®"){
                    self.text = name
                }else{
                   print(name)
                }
            }
            
            self.delegate?.didStartTextRecognition(detectedWord: self.text)
        }
        
        //PRocess Request
        do{
            try handler.perform([request])
        }catch{
            print(error.localizedDescription)
        }
    }
    
}
