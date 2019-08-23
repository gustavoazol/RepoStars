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
	let bag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .blue
		self.bindViewModel()
	}

	private func bindViewModel() {
		let didLoadObservable = Observable<Void>.just(())
		let inputs = RepoListVM.Input(viewLoadTrigger: didLoadObservable)
		
		let viewModel = RepoListVM(input: inputs)
		viewModel.loadingList
			.drive(onNext: { loading in
				print("Loading list: \(loading)")
			})
			.disposed(by: bag)
		
		viewModel.respositories
			.drive(onNext: { repos in
				print("Repos received. Count: \(repos.count)")
			})
			.disposed(by: bag)
	}
}
