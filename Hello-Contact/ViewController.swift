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
    
    var contacts = [Contact]()

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
        
        
        contacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch).map { Contact (contact: $0)
        
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
        
        contact.fetchImageIfNeeded { image in
            cell.contactImage.image = image
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        let alertController = UIAlertController(title: "Contact tapped",
                                                message: "You tapped \(contact.givenName)", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: { action in
            tableView.deselectRow(at: indexPath, animated: true)
        })
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteHandler: UIContextualAction.Handler = { [weak self] action, view, callback in
            self?.contacts.remove(at: indexPath.row)
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            self?.tableView.endUpdates()
            callback(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete", handler: deleteHandler)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}



    extension ViewController: UITableViewDataSourcePrefetching {
        func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
            for indexPath in indexPaths {
                let contact = contacts[indexPath.row]
                contact.fetchImageIfNeeded()
              
            }
        }
    }

















