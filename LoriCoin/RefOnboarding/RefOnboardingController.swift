//
//  RefOnboardingController.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/18/21.
//

import UIKit

class RefOnboardingController: UIViewController {

    @IBOutlet weak var walletAddressTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        walletAddressTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter wallet adress", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.75)]
        ) 
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
