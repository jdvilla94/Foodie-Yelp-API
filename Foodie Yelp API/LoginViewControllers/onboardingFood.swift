//
//  onboardingFood.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/4/23.
//

import UIKit

class onboardingFood: UIViewController {


    @IBOutlet var continueButton: UIButton!
    
    @IBOutlet var collectionView: UICollectionView!
    var selectedIndexPath: IndexPath?
    
    var sendKeys:String?
    
    var foodArray: [String:UIImage] = Foods.allFoods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
    
        
        continueButton.layer.cornerRadius = 15
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! onboardingCity
        destVC.food = sender as? String
    }
    

    @IBAction func continueButtonTapped(_ sender: UIButton) {
        if selectedIndexPath != nil{
            performSegue(withIdentifier: "toCities", sender: sendKeys)
        }
    }
    


}

extension onboardingFood: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! foodCell
        let valuesArray = foodArray.values.map { $0 }
        let value = valuesArray[indexPath.row]
        let keysArray = foodArray.keys.map{ $0 }
        let keys = keysArray[indexPath.row]
        cell.foodImage.image = value
        
        if keys == "chicken_wings"{
            cell.foodLabel.text = "wings"
        }else if keys == "pastashops"{
            cell.foodLabel.text = "pasta"
        }else{
            cell.foodLabel.text = keys
        }
        
        // Reset the appearance of the cell's border
        cell.layer.borderWidth = 0.0
        cell.layer.borderColor = UIColor.clear.cgColor
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndexPath = selectedIndexPath {
            collectionView.deselectItem(at: selectedIndexPath, animated: true)
        }
        
        
        // Update the appearance of the selected item's border
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0  // Set the border width
        cell?.layer.borderColor = UIColor.gray.cgColor  // Set the border color
        cell?.layer.cornerRadius = 15

        // Save the selected index path for future reference
        selectedIndexPath = indexPath
        continueButton.alpha = 1
        let keysArray = foodArray.keys.map{ $0 }
        let keys = keysArray[indexPath.row]
        sendKeys = keys
//        performSegue(withIdentifier: "toCities", sender: keys)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Reset the appearance of the deselected item's border
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0.0  // Reset the border width
        cell?.layer.borderColor = UIColor.clear.cgColor  // Reset the border color
    }
    
    
}
