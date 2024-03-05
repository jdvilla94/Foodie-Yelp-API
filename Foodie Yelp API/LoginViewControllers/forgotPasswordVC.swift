//
//  forgotPasswordVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/6/23.
//

import UIKit

class forgotPasswordVC: UIViewController {
    
    @IBOutlet var sendLinkButton: UIButton!
    @IBOutlet var emailTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sendLinkButton.layer.cornerRadius = 15
        
    
    }
    
    @IBAction func sendLinkTapped(_ sender: UIButton) {
        let email = self.emailTF.text ?? ""
        
        if !validator.isValidEmail(for: email){
            print("NO valid email found for this acccount")
            AlertCenter.showInvalidEmailAlert(on: self)
            return
        }
        
        authService.shared.forgotPassword(with: email) { [weak self] error in
            guard let self = self else {return}
            if let error = error {
                AlertCenter.showErrorSendingPasswordReset(on: self, with: error)
                print("we have an error sending the link")
                return
            }else{
                AlertCenter.showPasswordResetSent(on: self)
                print("succes on sending link")
                self.navigationController?.popViewController(animated: true)
            }
//            AlertCenter.showPasswordResetSent(on: self)
//            print("succes on sending link")
        }
    }
}
