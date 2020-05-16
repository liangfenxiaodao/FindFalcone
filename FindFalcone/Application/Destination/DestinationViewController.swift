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
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Find Falcone!"
        button.isEnabled = false

        setupDataBinding()
        setupActionBinding()
    }

    private func setupDataBinding() {
        viewModel.getAvailablePlanets()
            .bind(to: planetPickerView.rx.itemTitles) { _, planet in
                return planet.name
            }
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

        viewModel.destinationLabelText
            .bind(to: destinationLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.buttonText
            .bind(to: button.rx.title())
            .disposed(by: disposeBag)

        viewModel.timeTakenText
            .subscribe (onNext: { [weak self] timeTaken in
                self?.timeTakenLabel.isHidden = timeTaken == nil
                self?.timeTakenLabel.text = timeTaken
            })
            .disposed(by: disposeBag)
    }

    private func setupActionBinding() {
        planetPickerView.rx.itemSelected
            .subscribe(onNext: { [weak self] row, component in
                self?.viewModel.selectPlanet(index: row)
            })
            .disposed(by: disposeBag)

        vehiclePickerView.rx.itemSelected
            .subscribe(onNext: { [weak self] row, component in
                self?.viewModel.selectVehicle(index: row)
                self?.button.isEnabled = true
            })
            .disposed(by: disposeBag)
    }
}
