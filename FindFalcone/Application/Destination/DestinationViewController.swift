//
//  ViewController.swift
//  FindFalcone
//
//  Created by Jacky Li on 15/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DestinationViewController: UIViewController {
    private var viewModel: DestinationViewModel = DestinationViewModel()
    private let disposeBag = DisposeBag()

    @IBOutlet weak var planetPickerView: UIPickerView!
    @IBOutlet weak var vehiclePickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Find Falcone!"

        viewModel.getAvailablePlanets()
            .bind(to: planetPickerView.rx.itemTitles) { _, planet in
                return planet.name
            }
            .disposed(by: disposeBag)
    }
}
