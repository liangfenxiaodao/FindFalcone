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

    let viewModel = ResultViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Find Falcone!"
        navigationItem.hidesBackButton = true

        viewModel.findFalcone()
            .subscribe(onNext: { result in
                print(result)
            })
            .disposed(by: disposeBag)
    }
}
