//
//  GigsDetailViewController.swift
//  ios-gigs-practice
//
//  Created by Dongwoo Pae on 6/13/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class GigsDetailViewController: UIViewController {

    var gigController: GigController!
    var gig: Gig?
    
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let titleInput = jobTextField.text,
            let dueDateInput = picker?.date,
            let descriptionInput = descriptionTextView.text else {return}
        self.gigController.createGigs(title: titleInput, description: descriptionInput, dueDate: dueDateInput) { (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
 
    
    func updateViews() {
        if let gig = gig {
            self.jobTextField.text = gig.title
            self.picker.date = gig.dueDate
            self.descriptionTextView.text = gig.description
            self.title = gig.title
        } else {
            self.title = "New Gig"
        }
    }
}
