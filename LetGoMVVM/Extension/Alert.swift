//
//  Alert.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 29.08.2023.
//

import UIKit

extension UIViewController
{
    func showAlert(title : String, message : String, ButtonTitle : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: ButtonTitle, style: UIAlertAction.Style.default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
