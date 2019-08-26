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
	let loadingMore: Driver<Bool>
}

extension RepoListVM {
	init(input: Input, serviceProvider: GitHubServices = GitHubServices()) {
		let loadingList = BehaviorSubject<Bool>(value: false)
		let loadingMore = BehaviorRelay<Bool>(value: false)
		
		let currentPage = BehaviorRelay<Int>(value: 1)
		let canLoadMore = BehaviorSubject<Bool>(value: false)
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
				},
					 onError: { _ in
						canLoadMore.onNext(false)
				})
				.map({ $0.repositories })
				.catchErrorJustReturn([])
		}


		// Fetch Calls
		let reloadCall = Observable.merge(input.viewLoadTrigger, input.refreshTrigger)
			.do(onNext: {
				currentPage.accept(1)
				loadingList.onNext(true)
				canLoadMore.onNext(false)
			})
			.flatMapLatest({ loadPage(page: currentPage.value) })
			.do(onNext: { repos in loadingList.onNext(false) })
		
		
		let loadMore = input.loadMoreTrigger
			.debug("LoadMoreTrigger Received", trimOutput: true)
			.filter({ !loadingMore.value })
			.withLatestFrom(canLoadMore)
			.filter({ $0 })
			.debug("LoadMoreTrigger Passed", trimOutput: true)
			.do(onNext: { _ in loadingMore.accept(true) })
			.flatMapLatest({ _ -> Single<[Repository]> in
				let nextPage = currentPage.value + 1
				return loadPage(page: nextPage)
			})
			.map({ repositoryList.value + $0 })
			.debug("DidLoadMore", trimOutput: true)
			.do(onNext: { _ in
				loadingMore.accept(false)
				currentPage.accept(currentPage.value + 1)
			})
		
		
		self.loadingList = loadingList
			.distinctUntilChanged()
			.asDriver(onErrorJustReturn: false)
		
		self.loadingMore = loadingMore
			.distinctUntilChanged()
			.asDriver(onErrorJustReturn: false)
		
		self.repositories = Observable.merge(reloadCall, loadMore)
			.do(onNext: { repositoryList.accept($0) })
			.asDriver(onErrorJustReturn: [])
	}
}
