//
//  ViewController.swift
//  FindFalcone
//
//  Created by Jacky Li on 15/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import UIKit
import RxSwift

class DestinationViewController: UIViewController {
    private var viewModel: DestinationViewModel = DestinationViewModel()
    private var disposeBag = DisposeBag()

    @IBOutlet weak var planetPickerView: UIPickerView!
    @IBOutlet weak var vehiclePickerView: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Find Falcone!"
        navigationItem.hidesBackButton = true

        planetPickerView.delegate = self
        planetPickerView.dataSource = self

        vehiclePickerView.delegate = self
        vehiclePickerView.dataSource = self

        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(goToNextStep), for: .touchUpInside)

        destinationLabel.text = viewModel.destinationLabelText
        nextButton.setTitle(viewModel.buttonText, for: .normal)

        setupDataBinding()
    }

    private func setupDataBinding() {
        viewModel.loadAvailablePlanets()
            .subscribe(onNext: { [weak self] _ in
                self?.reloadPlanetPickerView()
            })
            .disposed(by: disposeBag)

        viewModel.loadAvailableVehicles()
            .subscribe(onNext: { [weak self] _ in
                self?.reloadVehiclePickerView()
            })
            .disposed(by: disposeBag)

        viewModel.timeTakenText
            .subscribe (onNext: { [weak self] timeTaken in
                self?.timeTakenLabel.isHidden = timeTaken == nil
                self?.timeTakenLabel.text = timeTaken
            })
            .disposed(by: disposeBag)
    }

    private func reloadPlanetPickerView() {
        planetPickerView.reloadAllComponents()
        planetPickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView(planetPickerView, didSelectRow: 0, inComponent: 0)
    }

    private func reloadVehiclePickerView() {
        vehiclePickerView.reloadAllComponents()
        vehiclePickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView(vehiclePickerView, didSelectRow: 0, inComponent: 0)
        nextButton.isEnabled = vehiclePickerView.numberOfRows(inComponent: 0) != 0
    }

    @objc private func goToNextStep() {
        disposeBag = DisposeBag()
        guard let next = viewModel.goToNextStep() else { return }
        route(to: next)
    }
}

extension DestinationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == planetPickerView {
            return viewModel.avaiablePlanets.count
        } else {
            return viewModel.avaiableVehicles.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == planetPickerView {
            return viewModel.avaiablePlanets[row].name
        } else {
            return viewModel.avaiableVehicles[row].displayName
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == planetPickerView {
            viewModel.selectPlanet(index: row)
        } else {
            viewModel.selectVehicle(index: row)
        }
    }
}
