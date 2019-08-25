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
		let didLoadObservable = BehaviorSubject<Void>(value: ())
		let refreshObservable = Observable<Void>.empty()
		let loadMore = Observable<Void>.empty()
		
		let inputs = RepoListVM.Input(
			viewLoadTrigger: didLoadObservable,
			refreshTrigger: refreshObservable,
			loadMoreTrigger: loadMore
		)
		
		let viewModel = RepoListVM(input: inputs)
		viewModel.loadingList
			.drive(onNext: { loading in
				print("Loading list: \(loading)")
			})
			.disposed(by: bag)
		
		viewModel.repositories
			.debug("Repositories", trimOutput: true)
			.drive(onNext: { repos in
				print("Repos received. Count: \(repos.count)")
			})
			.disposed(by: bag)
	}
}
