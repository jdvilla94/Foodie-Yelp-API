//
//  loginVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/3/23.
//

import UIKit

class loginVC: UIViewController {
    
    
    @IBOutlet var usernameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
        

    
//        passwordTF.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor

        
        loginButton.layer.cornerRadius = 10
        
        
        
        
    }
    

    @IBAction func loginTapped(_ sender: UIButton) {
        let loginRequest = loginUserRequest(email: self.usernameTF.text ?? "",
                                            password: self.passwordTF.text ?? "")
        
        //check email
        if !validator.isValidEmail(for: loginRequest.email){
            AlertCenter.showInvalidEmailAlert(on: self)
            print("invalid email")
            return
        }
        
        //check password
        if !validator.isPasswordValid(for: loginRequest.password){
            AlertCenter.showInvalidPasswordAlert(on: self)
            print("invalid passsword")
            return
        }
        
        authService.shared.signIn(with: loginRequest) { [weak self] error in
            guard let self = self else {return}//stops retain cycles
            if let error = error {
                AlertCenter.showSignInErrorAlert(on: self, with: error)
                print("error signing into firestore")
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
                sceneDelegate.checkAuthentication()
            }else{
                print("we have an error with auth")
            }
        }
        
    }
    

}
