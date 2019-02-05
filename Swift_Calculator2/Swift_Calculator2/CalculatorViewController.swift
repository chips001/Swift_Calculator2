//
//  ViewController.swift
//  Swift_Calculator2
//
//  Created by 一木 英希 on 2019/01/24.
//  Copyright © 2019 一木 英希. All rights reserved.
//

import UIKit
import Foundation

class CalculatorViewController: UIViewController {
    
    var kind: InputType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    private func setupViews() {
        guard let kind = self.kind else { return }
        self.descriptionLabel.text = kind.viewParams.descriptionLabelText
        self.baseView.isHidden = kind.viewParams.allButtonHidden
        self.calculateButton.setTitle(kind.viewParams.buttonTitle, for: .normal)
        self.setupDefaultValue()
    }
    
    private func setupDefaultValue() {
        guard let kind = self.kind else { return }
        switch kind {
        case .price, .percent:
            self.outputTextField.text = "0"
        case .result:
            if let price = InputParamsManager.shared.price, let percent = InputParamsManager.shared.percent {
                let percentValue = Float(percent) / 100
                let calcPrice = Float(price) * percentValue
                let resultPrice = price - Int(calcPrice)
                self.outputTextField.text = "\(resultPrice)"
            }
        }
    }

    @IBAction func tapedNumberButtonsHandler(_ sender: UIButton) {
        guard let price = self.outputTextField.text else { return }
        switch sender.tag {
        case -1:
            self.outputTextField.text = "0"
        case 10:
            let value = price + "00"
            if let value = Int(value) {
                self.outputTextField.text = "\(value)"
            }
        default:
            let value = price + "\(sender.tag)"
            if let value = Int(value) {
                self.outputTextField.text = "\(value)"
            }
        }
    }
    
    @IBAction func tapedCalculateButtonHandler(_ sender: UIButton) {
        guard let kind = self.kind else { return }
        let controller = CalculatorViewController.instantiateFromStoryboard()
        switch kind {
        case .price:
            guard let price = self.outputTextField.text else { return }
            InputParamsManager.shared.price = Int(price)
            controller.kind = .percent
            self.navigationController?.pushViewController(controller, animated: true)
        case .percent:
            guard let percent = self.outputTextField.text else { return }
            InputParamsManager.shared.percent = Int(percent)
            controller.kind = .result
            self.navigationController?.pushViewController(controller, animated: true)
        case .result:
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBOutlet weak var outputTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var baseView: UIView!
}

final class InputParamsManager {
    
    static let shared = InputParamsManager()
    var price: Int?
    var percent: Int?
}

enum InputType {
    case price
    case percent
    case result
    
    struct  ViewParams {
        let descriptionLabelText: String
        let buttonTitle: String
        let zeroZeroButtonHidden: Bool
        let allButtonHidden: Bool
    }
    
    var viewParams: ViewParams {
        switch self {
        case .price:
            return ViewParams(
                descriptionLabelText: "金額を入力して下さい",
                buttonTitle: "割引％を入力する",
                zeroZeroButtonHidden: false,
                allButtonHidden: false)
        case .percent:
            return ViewParams(
                descriptionLabelText: "割引%を入力して下さい",
                buttonTitle: "計算する",
                zeroZeroButtonHidden: true,
                allButtonHidden: false)
        case .result:
            return ViewParams(
                descriptionLabelText: "計算結果",
                buttonTitle: "他の計算をする",
                zeroZeroButtonHidden: true,
                allButtonHidden: true)
        }
    }
}

