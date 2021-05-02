//
//  FaovritesViewController.swift
//  findPill
//
//  Created by Cem on 2.05.2021.
//

import UIKit

class FavoritesViewController: UIViewController {
    let favorites = UserDefaults.standard
    var favoriteDrugs = FavoritesArray.shared.favoriteArray
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        getDataFromUserDefaults()
    }
    
    

    private func getDataFromUserDefaults(){
        
        do {
              favoriteDrugs = try favorites.getObject(forKey: "userFavorites", castTo: [String].self)
                
           
            tableView.reloadData()

        } catch {
            print(error.localizedDescription)
        }
    }
    @IBAction func deleteButtonClicked(_ sender: Any) {
        if favoriteDrugs.isEmpty{
            print("List is empyth")
        }else{
     
            favorites.removeObject(forKey: "userFavorites")
            favoriteDrugs.removeAll()
            tableView.reloadData()
            
        }
    }
}

extension FavoritesViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteDrugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesTableViewCell
        
        cell.textLabel?.text = favoriteDrugs[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.alpha = 0
            UIView.animate(withDuration: 1) {
                cell.alpha = 1.0
            }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
