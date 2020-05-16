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

        setupDataBinding()

        planetPickerView.delegate = self
        planetPickerView.dataSource = self

        vehiclePickerView.delegate = self
        vehiclePickerView.dataSource = self
    }

    private func setupDataBinding() {
        viewModel.loadAvailablePlanets()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.planetPickerView.reloadAllComponents()
                self.planetPickerView.selectRow(0, inComponent: 0, animated: true)
                self.pickerView(self.planetPickerView, didSelectRow: 0, inComponent: 0)
                self.vehiclePickerView.reloadAllComponents()
                self.vehiclePickerView.selectRow(0, inComponent: 0, animated: true)
                self.pickerView(self.vehiclePickerView, didSelectRow: 0, inComponent: 0)
            })
            .disposed(by: disposeBag)

        viewModel.loadAvailableVehicles()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.vehiclePickerView.reloadAllComponents()
                self.vehiclePickerView.selectRow(0, inComponent: 0, animated: true)
                self.pickerView(self.vehiclePickerView, didSelectRow: 0, inComponent: 0)
            })
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