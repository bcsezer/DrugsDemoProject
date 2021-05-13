//
//  ApiManager.swift
//  findPill
//
//  Created by Cem on 13.05.2021.
//

import Foundation


protocol ApiManagerDelegate:AnyObject {
    func didSelectSideEffect()
}
class ApiManager{
    
    weak var delegate: ApiManagerDelegate?
    
    public func loadSideEffect(with drugName:String){

       let url = "https://api.fda.gov/drug/event.json?search=patient.drug.openfda.brand_name:\(drugName)&count=patient.reaction.reactionmeddrapt.exact"
       
     
           URLSession.shared.dataTask(with:URL(string: url)!) { (data, response, err) in

               if err != nil {

                   print(err!.localizedDescription)
                   
               }else {

                   do{
                       let data = try JSONDecoder().decode(DrugData.self, from: data!)
                    print(data.meta)
                      
                   }catch{
                       debugPrint(error)
                   }

               }


           }.resume()
    }
       
}
