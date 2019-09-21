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
        
        
    }
    
    func retrieveContacts(from store: CNContactStore) {
        let containerId = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                           CNContactFamilyNameKey as CNKeyDescriptor,
                           CNContactImageDataAvailableKey as CNKeyDescriptor,
                           CNContactImageDataKey as CNKeyDescriptor]
        
        
        
         let contacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
        
        print(contacts)
        
        }
        
        
    }


