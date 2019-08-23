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
import RxSwiftExt

struct RepoListVM {
	struct Input {
		let viewLoadTrigger: Observable<Void>
	}
	
	let respositories: Driver<[Repository]>
	let loadingList: Driver<Bool>
}

extension RepoListVM {
	init(input: Input, serviceProvider: GitHubServices = GitHubServices()) {
		let loading = PublishRelay<Bool>()
		self.loadingList = loading.asDriver(onErrorJustReturn: false)
		
		self.respositories = input.viewLoadTrigger
			.do(onNext: { loading.accept(true) })
			.flatMapLatest({
				serviceProvider.getSwiftRepositories()
					.catchErrorJustReturn(GitHubResponse(repositories: []))
			})
			.debug()
			.map({ $0.repositories })
			.catchErrorJustReturn([])
			.do(onNext: { _ in loading.accept(false) })
			.asDriver(onErrorJustReturn: [])
	}
}
