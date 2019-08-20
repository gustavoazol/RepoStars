//
//  RepoListVM.swift
//  RepoStars
//
//  Created by Gustavo Azevedo de Oliveira on 18/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class RepoListVM: ViewModel {
	struct RepoListInput {
		let viewDidLoad: AnyObserver<Void>
	}

	struct RepoListOutput {
		let respositories: Driver<[Repository]>
		let initialLoading: Driver<Bool>
	}

	let input: RepoListInput
	let output: RepoListOutput

	private let services: GitHubServices
	
	init(serviceProvider: GitHubServices = GitHubServices()) {
		self.services = serviceProvider
		
		let didLoadPublisher = PublishSubject<Void>()
		
		// INPUT
		self.input = RepoListInput(
			viewDidLoad: didLoadPublisher.asObserver()
		)
		
		// OUTPUT
		let loading = BehaviorRelay(value: false)
		
		let reposDriver = didLoadPublisher
			.do(onNext: { loading.accept(true) })
			.flatMapLatest({
				serviceProvider.getSwiftRepositories()
			})
			.map({ $0.repositories })
			.do(onNext: { _ in loading.accept(false) })
			.asDriver(onErrorJustReturn: [])
		
		self.output = RepoListOutput(
			respositories: reposDriver,
			initialLoading: loading.asDriver()
		)
	}
}
