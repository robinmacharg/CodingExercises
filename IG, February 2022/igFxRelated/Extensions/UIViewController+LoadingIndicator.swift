//
//  UIViewController+Loading.swift
//  igFxRelated
//
//  Created by Robin Macharg on 20/02/2022.
//

import UIKit

/**
 * Functions to show and hide a busy/loading indicator.
 * The assumption is that the caller will handle persistence of the alert controller.
 */
extension UIViewController {
    
    func showBusyIndicator(message: String = "Please wait...") -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        return alert
    }
    
    func hideBusyIndicator(loader : UIAlertController?) {
        DispatchQueue.main.async {
            loader?.dismiss(animated: true, completion: nil)
        }
    }
}
