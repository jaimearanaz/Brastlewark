//
//  GridRouter.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation
import UIKit

protocol GridNavigationFlow {
    func injectFilter(withSegue segue: UIStoryboardSegue)
}

extension GridViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        switch (segue.identifier) {
        case GridTransitions.toFilter.rawValue:
            navigationFlow?.injectFilter(withSegue: segue)
        default:
            break
        }
    }
}