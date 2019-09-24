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
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        collectionView.delegate = self
        collectionView.collectionViewLayout = ContactCollectionViewLayout()

        
        
        
        
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
        
        contacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            .map { Contact(contact: $0) }
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "ContactCollectionViewCell", for: indexPath) as! ContactCollectionViewCell
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = "\(contact.givenName) \(contact.familyName)"
        contact.fetchImageIfNeeded { image in
            cell.contactImage.image = image
        }
        
        return cell
    
    }
    

    
    

}
    
    
extension ViewController:UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let  width = floor((collectionView.bounds.width - 2) / 3)
        return CGSize(width: width, height: 90)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) ->
        
        CGFloat{
        let  availableWidthForCells = collectionView.bounds.width - 2
            let totalGutterSpace = availableWidthForCells.truncatingRemainder(dividingBy: 3)
            
            let cellSpacing = totalGutterSpace / 2
            
            return 1 + cellSpacing
    }
    
    
    
    
    
}


extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ContactCollectionViewCell
            else { return }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            cell.contactImage.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
                cell.contactImage.transform = .identity
            }, completion: nil)
        })
    }
}
    

