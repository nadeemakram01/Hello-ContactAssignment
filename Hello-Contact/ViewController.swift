//
//  ViewController.swift
//  Hello-Contact
//
//  Created by Nadeem Akram on 2019-09-21.
//  Copyright © 2019 Nadeem Akram. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    
    var contacts = [CNContact]()

    @IBOutlet var tableView: UITableView!

    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        let store = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        if authorizationStatus == .notDetermined {
            store.requestAccess(for: .contacts) { [weak self] didAuthorize, error in
                if didAuthorize {
                    self?.retrieveContacts(from: store)
                }
            }
        } else if authorizationStatus == .authorized  {
            retrieveContacts(from: store)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    func retrieveContacts(from store: CNContactStore) {
        let containerId = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                           CNContactFamilyNameKey as CNKeyDescriptor,
                           CNContactImageDataAvailableKey as CNKeyDescriptor,
                           CNContactImageDataKey as CNKeyDescriptor]
        
        //    let tmpcontacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
        
        
        contacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        
        
        
        
        
        
        
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        let contact = contacts[indexPath.row]
        
        cell.nameLabel.text = "\(contact.givenName) \(contact.familyName)"
        
        if  contact.imageDataAvailable == true, let imageData = contact.imageData {
            cell.contactImage.image = UIImage(data: imageData)
        }
        
        return cell
    }
}












extension ViewController: UITableViewDelegate{
    
    //extension implementation
}





