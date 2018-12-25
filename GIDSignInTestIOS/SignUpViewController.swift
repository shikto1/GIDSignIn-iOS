//
//  SignUpViewController.swift
//  GIDSignInTestIOS
//
//  Created by Developer Shishir on 12/25/18.
//  Copyright © 2018 Shishir. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameT: UITextField!
    @IBOutlet weak var emailT: UITextField!
    @IBOutlet weak var passwordT: UITextField!
    var dbRef: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpBtnDidTapped(_ sender: Any){
        let name = nameT.text
        let email = emailT.text
        let password = passwordT.text
        
        Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
            if let error = error{
                print(error.localizedDescription)
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .invalidEmail:
                        print("/////////////////////INVALID EMAIL>>>>>>>>>>>>>>")
                    case .missingEmail:
                        print("//////////////////////// NO EMAIL FOUND >>>>>>>>>>>>>>>")
                    case .emailAlreadyInUse:
                        print("/////////////////////EMAIL ALREADY IN USE>>>>>>")
                    case .weakPassword:
                        print("///////////////////// WEAK PASSWORD >>>>>>>>>>>>")
                    default:
                        print("Create User Error: \(error)")
                    }
                }
            }else{
                let userID = authResult?.user.uid
                self.dbRef = Database.database().reference().child("Walletmix Pay").child("users")
                .child(userID!)
                let data = ["name": name,
                            "email": email,
                            "phoneNumber": ""]
                self.dbRef?.setValue(data)
                self.gotoHome()
            }
            
        }
    }
    
    func gotoHome(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "home_root")
        present(viewController, animated: true, completion: nil)
    }
    
}
