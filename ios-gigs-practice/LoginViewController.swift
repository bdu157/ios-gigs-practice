//
//  LoginViewController.swift
//  ios-gigs-practice
//
//  Created by Dongwoo Pae on 6/13/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

enum LoginType: String {
    case SignUp
    case LogIn
}


class LoginViewController: UIViewController {

    var gigController: GigController!
    var loginType = LoginType.SignUp
    
    @IBOutlet weak var signUpLogInControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwrodTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        if signUpLogInControl.selectedSegmentIndex == 0 {
            self.loginType = .SignUp
            self.button.setTitle("Sign Up", for: .normal)
        } else {
            self.loginType = .LogIn
            self.button.setTitle("Log In", for: .normal)
        }
        
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let gigController = gigController else {return}
            if let username = self.usernameTextField.text,
                !username.isEmpty,
                let password = self.passwrodTextField.text,
                !password.isEmpty {
                let user = User(username: username, password: password)
                
                if loginType == .SignUp {
                    gigController.signUp(with: user) { (error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up", message: "Successful", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginType = .LogIn
                                self.signUpLogInControl.selectedSegmentIndex = 1
                                self.button.setTitle("Log In", for: .normal)
                            })
                        }
                    }
                } else {
                    gigController.logIn(with: user) { (error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
        }
    }
}
