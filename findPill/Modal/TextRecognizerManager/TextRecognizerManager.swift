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
    func errorOccurs(error:String)
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
            
           
            guard let name = textArray.first(where:{$0.contains("®")}) else {
                self.delegate?.errorOccurs(error: "Error")
                return
            }
            print(name,"Name")
            self.delegate?.didStartTextRecognition(detectedWord: self.removeCharactersFromString(textFromResult: name))
        }
        
        //PRocess Request
        do{
            try handler.perform([request])
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func removeCharactersFromString(textFromResult:String)-> String{
        self.text = textFromResult
        let ignoredStrings: Set<Character> = ["%", "®", "1", "2", "3","4","6","5","7","8","9","0"]
        
        self.text.removeAll(where: { ignoredStrings.contains($0) })
        print(text,"removedan sonra")
        self.text = self.text.replacingOccurrences(of: "Mg", with: "").replacingOccurrences(of: "mg", with: "").replacingOccurrences(of: "MG", with: "")
        print(text,"replace den sonra")
        
        return self.text
    }
    
}
