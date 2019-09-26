//
//  ContactDetailViewController.swift
//  Hello-Contact
//
//  Created by Nadeem Akram on 2019-09-26.
//  Copyright © 2019 Nadeem Akram. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var contactImage: UIImageView!
    @IBOutlet var contactNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear),
                                               name: UIApplication.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIApplication.keyboardWillHideNotification,
                                               object: nil)
        
    }
    
    
    let views: [String: Any] = ["contactImage": contactImage, "contactNameLabel": contactNameLabel]
    
        var allConstraints = [NSLayoutConstraint]()
    
        compactWidthConstraint = contactImage.widthAnchor.constraint(equalToConstant: 60)
        compactHeightConstraint = contactImage.heightAnchor.constraint(equalToConstant: 60)
    
        regularWidthConstraint = contactImage.widthAnchor.constraint(equalToConstant: 120)
        regularHeightConstraint = contactImage.heightAnchor.constraint(equalToConstant: 120)
    
        let verticalPositioningConstraints = NSLayoutConstraint.constraints(
          withVisualFormat: "V:|-[contactImage]-[contactNameLabel]",
          options: [.alignAllCenterX], metrics: nil, views: views)
    
        allConstraints += verticalPositioningConstraints
    
        let centerXConstraint = contactImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
    
        allConstraints.append(centerXConstraint)
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
          allConstraints.append(regularWidthConstraint)
          allConstraints.append(regularHeightConstraint)
        } else {
          allConstraints.append(compactWidthConstraint)
          allConstraints.append(compactHeightConstraint)
        }
    
        NSLayoutConstraint.activate(allConstraints)
      }
    
    @objc func keyboardWillAppear(_ notification: Notification) {
      guard let userInfo = notification.userInfo,
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
      
      scrollViewBottomConstraint.constant = keyboardFrame.cgRectValue.size.height
      UIView.animate(withDuration: TimeInterval(animationDuration), animations: { [weak self ] in
        self?.view.layoutIfNeeded()
      })
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
      guard let userInfo = notification.userInfo,
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
      
      scrollViewBottomConstraint.constant = 0
      UIView.animate(withDuration: TimeInterval(animationDuration), animations: { [weak self ] in
        self?.view.layoutIfNeeded()
      })
    }

    

}
