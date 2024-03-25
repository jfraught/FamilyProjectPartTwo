//
//  FamilyMemberTableViewController.swift
//  FamilyProjectPartTwo
//
//  Created by Jordan Fraughton on 3/24/24.
//

import UIKit

protocol FamilyMemberTableViewControllerDelegate: AnyObject {
    func familyMemberTableViewController(_ controller: FamilyTableViewController, didSave familyMember: FamilyMember)
}

class FamilyMemberTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var birthdayDatePicker: UIDatePicker!
    @IBOutlet var bioTextView: UITextView!
    @IBOutlet var imageNameLabel: UILabel!
    @IBOutlet var familyMemberImageView: UIImageView!
    @IBOutlet var saveButton: UIBarButtonItem!

    var isDatePickerHidden = true
    let birthdayLabelIndexPath = IndexPath(row: 1, section: 0)
    let birthdayDatePickerIndex = IndexPath(row: 2, section: 0)
    let bioTextViewIndexPath = IndexPath(row: 0, section: 1)
    let imageNameIndexPath = IndexPath(row: 0, section: 2)
    let imageViewIndexPath = IndexPath(row: 1, section: 2)

    var familyMember: FamilyMember?

    override func viewDidLoad() {
        super.viewDidLoad()

        let birthday: Date

        if let familyMember {
            navigationItem.title = familyMember.name
            nameTextField.text = familyMember.name
            birthday = familyMember.birthday ?? Date()
            bioTextView.text = familyMember.bio
            imageNameLabel.text = familyMember.photo?.description
            familyMemberImageView.image = familyMember.photo
        } else {
            birthday = birthdayDatePicker.date
            navigationItem.title = "New Family Member"
        }

        birthdayDatePicker.date = birthday
        updateBirthdayLabel(with: birthdayDatePicker.date)
        updateSaveButtonState()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case birthdayDatePickerIndex where isDatePickerHidden == true:
            return 0
        case bioTextViewIndexPath:
            return 200
        case imageViewIndexPath:
            return 400
        default:
            return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case birthdayDatePickerIndex:
            return 216
        case bioTextViewIndexPath:
            return 200
        case imageViewIndexPath:
            return 400
        default:
            return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == birthdayLabelIndexPath {
            isDatePickerHidden.toggle()
            updateBirthdayLabel(with: birthdayDatePicker.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath == imageNameIndexPath {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self

            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }

        familyMember?.photo = selectedImage
        familyMemberImageView.image = selectedImage
        imageNameLabel.text = selectedImage.description

        dismiss(animated: true, completion: nil)
    }

    func updateBirthdayLabel(with date: Date) {
        birthdayLabel.text = date.formatted(date: .abbreviated, time: .omitted)
    }

    func updateSaveButtonState() {
        let shouldSaveButtonBeEnabled = nameTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldSaveButtonBeEnabled
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard segue.identifier == "saveUnwind" else { return }

        let name = nameTextField.text!
        let birthday = birthdayDatePicker.date
        let bio = bioTextView.text!
        let photo = familyMemberImageView.image

        if familyMember != nil {
            familyMember?.name = name
            familyMember?.birthday = birthday
            familyMember?.bio = bio
            familyMember?.photo = photo!
        } else {
            familyMember = FamilyMember(name: name, birthday: birthday, bio: bio, photo: photo)
        }
    }

    @IBAction func nameTextEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }

    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    @IBAction func birthdayDatePickerChanged(_ sender: UIDatePicker) {
        updateBirthdayLabel(with: sender.date)
    }
}
