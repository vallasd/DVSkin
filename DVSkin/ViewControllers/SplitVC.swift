//
//  SplitViewController.swift
//  ComcastCore
//
//  Created by David Vallas on 7/17/19.
//  Copyright © 2019 David Vallas. All rights reserved.
//

import UIKit

public class SplitVC: UISplitViewController, UISplitViewControllerDelegate {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            // defaults to root view controller for iphones
            self.delegate = self
            self.preferredDisplayMode = .allVisible
        } else {
            self.preferredDisplayMode = .primaryOverlay
        }
    }
    
    public func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
    
}

/// will dismissn (animate removal) the root view controller from an iPad
extension UISplitViewController {
    func toggleRootView() {
        if (UIDevice.current.userInterfaceIdiom == .phone ||
            UIDevice.current.orientation.isLandscape) { return } // we do nothing if this is an iphone || landscape
        let barButtonItem = self.displayModeButtonItem
        UIApplication.shared.sendAction(barButtonItem.action!, to: barButtonItem.target, from: nil, for: nil)
    }
}
