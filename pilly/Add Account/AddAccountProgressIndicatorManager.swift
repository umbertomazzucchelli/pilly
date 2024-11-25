//
//  AddAccountProgressIndicatorManager.swift
//  pilly
//
//  Created by Belen Tesfaye on 11/24/24.
//

import Foundation
extension AddAccountViewController:ProgressSpinnerDelegate{
    func showActivityIndicator(){
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}
