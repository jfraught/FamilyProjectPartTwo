//
//  FamilyTableViewController.swift
//  FamilyProjectPartTwo
//
//  Created by Jordan Fraughton on 3/24/24.
//

import UIKit

class FamilyTableViewController: UITableViewController, FamilyMemberTableViewControllerDelegate {
    
    var familyMembers: [FamilyMember] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        familyMembers = FamilyMember.myFamily
        navigationItem.title = "Fraughton Family"
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return familyMembers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyMemberCell", for: indexPath)
        
        let familyMember = familyMembers[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = familyMember.name
        content.secondaryText = familyMember.birthday?.formatted(date: .abbreviated, time: .omitted) 
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            familyMembers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func familyMemberTableViewController(_ controller: FamilyTableViewController, didSave familyMember: FamilyMember) {
        if let indexPath = tableView.indexPathForSelectedRow {
            familyMembers.remove(at: indexPath.row)
            familyMembers.insert(familyMember, at: indexPath.row)
        } else {
            familyMembers.append(familyMember)
        }
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBSegueAction func familyMemberDetailVC(_ coder: NSCoder, sender: Any?) -> FamilyMemberTableViewController? {
        let familyMemberTableViewControllor = FamilyMemberTableViewController(coder: coder)
        
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return familyMemberTableViewControllor
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        familyMemberTableViewControllor?.familyMember = familyMembers[indexPath.row]
        
        return familyMemberTableViewControllor
    }
    
    @IBAction func unwindToFamilyVC(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! FamilyMemberTableViewController
        
        if let familyMember = sourceViewController.familyMember {
            if let indexOfFamilyMemebr = familyMembers.firstIndex(of: familyMember) {
                familyMembers[indexOfFamilyMemebr] = familyMember
                tableView.reloadRows(at: [IndexPath(row: indexOfFamilyMemebr, section: 0)], with: .automatic)
            } else {
                let newIndexPath = IndexPath(item: familyMembers.count, section: 0)
                familyMembers.append(familyMember)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
}
