//
//  accountSettings.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 1/14/24.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class accountSettings: UIViewController {

    

    
    @IBOutlet var tableView: UITableView!
    
    var image: UIImage?
    var username:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    

    
    func showSignOutAlert() {
         let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
             self?.performSignOut()
         }
         alert.addAction(cancelAction)
         alert.addAction(signOutAction)
         present(alert, animated: true, completion: nil)
     }
    
    func performSignOut() {
        authService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertCenter.showLogoutError(on: self, with: error)
                print("There was an error: \(error)")
                return
            }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
}


extension accountSettings: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = setSections(rawValue: section) else{ return 0}
        switch section{
        case .Profile:
            return profileGroup.allCases.count
        case .Account:
            return accountGroup.allCases.count
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return setSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileDetailCell") as! profileDetailCell
        guard let section = setSections(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .Profile:
            if profileGroup(rawValue: indexPath.row)?.description == "Profile" && indexPath.row == 0{
            
//            if indexPath.row == 0 { // First row in the Profile section
                // Add an image and text to the cell
        } else {
        // Handle other rows in the Profile section
        }
        case .Account:
        // Handle rows in the Account section
            if accountGroup(rawValue: indexPath.row)?.description == "Logout" && indexPath.row == 0{
                DispatchQueue.main.async {
                    let label = UILabel()
                    label.font = UIFont(name: "verdana-bold", size: 16)
                    label.textColor = .red
                    label.text = "Logout"
                    cell.contentView.addSubview(label)
                    // Adjust the layout constraints as needed
                    label.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor,constant: 15),
                    label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                    ])

                }

            }
            let dummy = "dummy"
//            cell.backgroundColor = .black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = setSections(rawValue: indexPath.section) else {return}
        switch section{
        case .Profile:
            let dummy = "dummy"
            if profileGroup(rawValue: indexPath.row)?.description == "Profile"{
//                performSegue(withIdentifier: "profileDetail", sender: (image,username))
            }
        case .Account:
            let dummy = "dummy"
            if accountGroup(rawValue: indexPath.row)?.description == "Logout"{
                self.showSignOutAlert()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let title = UILabel()
        title.font = UIFont(name: "verdana-bold", size: 20)
        title.textColor = .black
        title.text = setSections(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        return view
     }
    
}


