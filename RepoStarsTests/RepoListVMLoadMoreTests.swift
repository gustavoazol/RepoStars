//
//  RepoListVMLoadMoreTests.swift
//  RepoStarsTests
//
//  Created by Gustavo Azevedo de Oliveira on 24/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxTest
import RxCocoa
@testable import RepoStars

class RepoListVMLoadMoreTests: QuickSpec {
	
	override func spec() {
		let stubServices = StubDidLoadGitServices()
		var bag: DisposeBag!
		var scheduler: TestScheduler!
		var viewModel: RepoListVM!
		
		describe("RepoListVM") {
			beforeEach {
				scheduler = TestScheduler(initialClock: 0)
				bag = DisposeBag()
			}
			
			context("When nearly reach end of list") {
				beforeEach {
					let loadMore = scheduler.createColdObservable([ next(200, ()) ]).asObservable()
					
					let input = RepoListVM.Input(
						viewLoadTrigger: Observable.just(()),
						refreshTrigger: Observable<Void>.empty(),
						loadMoreTrigger: loadMore
					)
					viewModel = RepoListVM(input: input, serviceProvider: stubServices)
				}
				
				it("should fetch next repositories page batch") {
					let loading = scheduler.createObserver(Bool.self)
					viewModel.loadingList
						.drive(loading)
						.disposed(by: bag)
					
					let result = scheduler.createObserver(Int.self)
					viewModel.repositories
						.map({$0.count})
						.drive(result)
						.disposed(by: bag)
					
					scheduler.start()
					expect(loading.events.compactMap{$0.value.element}).to(equal([true, false]))
					expect(result.events).to(equal([ next(0, 2), next(200, 4) ]))
				}
			}
		}
	}
}
