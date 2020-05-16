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

        planetPickerView.rx.itemSelected
            .subscribe(onNext: { [weak self] row, component in
                self?.viewModel.selectPlanet(index: row)
            })
            .disposed(by: disposeBag)

        viewModel.getAvailableVehicles()
            .subscribe(onNext: { [weak self] vehicles in
                self?.vehiclePickerView.isHidden = vehicles.isEmpty
            })
        .disposed(by: disposeBag)

        viewModel.getAvailableVehicles()
            .bind(to: vehiclePickerView.rx.itemTitles) { _, vehicle in
                return vehicle.name
            }
            .disposed(by: disposeBag)
    }
}
