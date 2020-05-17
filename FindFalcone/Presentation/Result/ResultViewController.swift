//
//  ResultViewController.swift
//  FindFalcone
//
//  Created by Jacky Li on 17/5/20.
//  Copyright © 2020 Jacky Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var planetLabel: UILabel!

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    let viewModel = ResultViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Find Falcone!"
        navigationItem.hidesBackButton = true

        indicator.startAnimating()

        viewModel.findFalcone()
            .subscribe(onNext: { [weak self] result in
                self?.indicator.stopAnimating()
                print(result)
            })
            .disposed(by: disposeBag)
    }
}
