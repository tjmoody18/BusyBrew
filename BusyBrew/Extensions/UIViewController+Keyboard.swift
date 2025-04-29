//
//  UIViewController+Keyboard.swift
//  BusyBrew
//
//  Created by Nabil Chowdhury on 4/28/25.
//
import UIKit

extension UIViewController {
  func hideKeyboardOnTap() {
    let tap = UITapGestureRecognizer(
      target: self,
      action: #selector(dismissKeyboard)
    )
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
}
