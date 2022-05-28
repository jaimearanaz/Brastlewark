//
//  ViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 26/5/22.
//

import UIKit
import Combine

class GridViewController: BaseViewController {
    
    @IBOutlet weak var goToFilterBt: UIButton!

    var viewModel: GridViewModel? { didSet { baseViewModel = viewModel } }
    var navigationFlow: GridNavigationFlow?
    var subscribers = Set<AnyCancellable>()

    override func binds() {

        viewModel?.isLoading.bind({ isLoading in
            
            switch isLoading {
            case true:
                self.startLoading()
            case false:
                self.stopLoading()
                break
            }
        })
        
        viewModel?.errorMessage.bind({ errorMessage in
            DispatchQueue.main.async {
                self.showAlert(withMessage: errorMessage)
            }
        })
        
        viewModel?.characters.bind({ characters in
            print("characters \(characters.count)")
        })
        
        viewModel?.transitionTo.bind({ transitionTo in
            self.performSegue(withIdentifier: transitionTo.rawValue, sender: self)
        })
    }
    
    @IBAction func didSelectFilter() {
        viewModel?.didSelectFilter()
    }
    
    @IBAction func didSelectReset() {
        viewModel?.didSelectReset()
    }
    
    @IBAction func didSelectCharacter() {
        viewModel?.didSelectCharacter(id: 1)
    }
    
    func startLoading() {
        print("startLoading")
    }
    
    func stopLoading() {
        print("stopLoading")
    }
    
    private func showAlert(withMessage message: String) {
        
        let alert = UIAlertController(title: "ERROR_MESSAGE_TITLE".localized,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ERROR_MESSAGE_BUTTON".localized,
                                      style: .default,
                                      handler: nil))
        self.present(alert, animated: true)
    }
    
}