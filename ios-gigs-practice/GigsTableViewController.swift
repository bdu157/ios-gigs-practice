//
//  GigsTableViewController.swift
//  ios-gigs-practice
//
//  Created by Dongwoo Pae on 6/13/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    var gigController = GigController()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "ToLoginVC", sender: self)
        } else {
            self.gigController.fetchGigs { (error) in
                if let error = error {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.gigController.gigs.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let gig = self.gigController.gigs[indexPath.row]
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        cell.detailTextLabel?.text = df.string(from: gig.dueDate)
        cell.textLabel?.text = gig.title
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLoginVC" {
            guard let destVC = segue.destination as? LoginViewController else {return}
                destVC.gigController = self.gigController
        } else if segue.identifier == "AddGig" {
            guard let destVC = segue.destination as? GigsDetailViewController else {return}
                destVC.gigController = self.gigController
        } else if segue.identifier == "ShowGig" {
            guard let destVC = segue.destination as? GigsDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else {return}
                let selectedGig = self.gigController.gigs[indexPath.row]
                destVC.gigController = self.gigController
                destVC.gig = selectedGig
        }
    }
}
