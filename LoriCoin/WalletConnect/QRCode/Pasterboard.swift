//
//  Pasterboard.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import Foundation
import UIKit

class Pasteboard {

    static var string: String? {
        get { UIPasteboard.general.string }
        set { UIPasteboard.general.string = newValue }
    }

}
