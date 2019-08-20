//
//  RepoListViewController.swift
//  RepoStars
//
//  Created by Gustavo Azevedo de Oliveira on 18/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepoListViewController: UIViewController {
	let viewModel = RepoListVM()
	let bag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = .blue
		self.viewModel.input.viewDidLoad.onNext(())
		
		self.viewModel.output.initialLoading.drive(onNext: { print($0)}).disposed(by: bag)
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
