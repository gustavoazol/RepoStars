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
		let refreshTrigger: Observable<Void>
		let loadMoreTrigger: Observable<Void>
	}
	
	let repositories: Driver<[Repository]>
	let loadingList: Driver<Bool>
}

extension RepoListVM {
	init(input: Input, serviceProvider: GitHubServices = GitHubServices()) {
		let loading = PublishRelay<Bool>()
		let currentPage = BehaviorRelay<Int>(value: 0)
		let canLoadMore = BehaviorSubject<Bool>(value: true)
		let repositoryList = BehaviorRelay<[Repository]>(value: [])
		
		func loadPage(page: Int) -> Single<[Repository]> {
			return serviceProvider.getSwiftRepositories(page: page)
				.do(onSuccess: { response in
					if let lastPage = response.lastPage {
						canLoadMore.onNext(page < lastPage)
					}
					else {
						canLoadMore.onNext(!response.repositories.isEmpty)
					}
				})
				.map({ $0.repositories })
				.catchErrorJustReturn([])
		}


		// Fetch Calls
		let reloadCall = Observable.merge(input.viewLoadTrigger, input.refreshTrigger)
			.do(onNext: {
				currentPage.accept(1)
				canLoadMore.onNext(true)
				loading.accept(true)
			})
			.flatMapLatest({ loadPage(page: currentPage.value) })
			.do(onNext: { _ in loading.accept(false) })
		
		let loadMore = input.loadMoreTrigger
			.flatMapLatest({ loadPage(page: currentPage.value + 1) })
			.map({ repositoryList.value + $0 })
			.do(onNext: { _ in currentPage.accept(currentPage.value + 1)  })
		
		
		self.loadingList = loading.asDriver(onErrorJustReturn: false)
		self.repositories = Observable.merge(reloadCall, loadMore)
			.do(onNext: { repositoryList.accept($0) })
			.asDriver(onErrorJustReturn: [])
	}
}
