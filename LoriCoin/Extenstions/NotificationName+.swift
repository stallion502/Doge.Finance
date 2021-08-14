//
//  NotificationName+.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import Foundation
import Foundation

extension NSNotification.Name {
    // MARK: - Core

    static let selectedSafeChanged = NSNotification.Name("selectedSafeChanged")
    static let selectedSafeUpdated = NSNotification.Name("selectedSafeUpdated")

    static let networkInfoChanged = NSNotification.Name("networkInfoChanged")

    static let ownerKeyImported = NSNotification.Name("ownerKeyImported")
    static let ownerKeyRemoved = NSNotification.Name("ownerKeyRemoved")
    static let ownerKeyUpdated = NSNotification.Name("ownerKeyUpdated")

    static let transactionDataInvalidated = NSNotification.Name("transactionDataInvalidated")

    static let incommingTxNotificationReceived = NSNotification.Name("incommingTxNotification")
    static let queuedTxNotificationReceived = NSNotification.Name("queuedTxNotificationReceived")
    static let confirmationTxNotificationReceived = NSNotification.Name("confirmationTxNotificationReceived")

    static let biometricsActivated = NSNotification.Name("biometricsActivated")

    // MARK: - WalletConnect

    static let wcConnectingServer = NSNotification.Name("wcConnectingServer")
    static let wcDidFailToConnectServer = NSNotification.Name("wcDidFailToConnectServer")
    static let wcDidConnectServer = NSNotification.Name("wcDidConnectServer")
    static let wcDidDisconnectServer = NSNotification.Name("wcDidDisconnectServer")

    static let wcDidFailToConnectClient = NSNotification.Name("wcDidFailToConnectClient")
    static let wcDidConnectClient = NSNotification.Name("wcDidConnectClient")
    static let wcDidDisconnectClient = NSNotification.Name("wcDidDisconnectClient")

    // MARK: - Passcode

    static let passcodeCreated = NSNotification.Name("passcodeCreated")
    static let passcodeDeleted = NSNotification.Name("passcodeDeleted")

    // MARK: - Networking

    static let networkHostReachable = NSNotification.Name("networkHostReachable")
    static let networkHostUnreachable = NSNotification.Name("networkHostUnreachable")

    // MARK: - Fiat

    static let selectedFiatCurrencyChanged = NSNotification.Name("selectedFiatCurrencyChanged")

    // MARK: - Experemental

    static let updatedExperemental = NSNotification.Name("updatedExperemental")
}
