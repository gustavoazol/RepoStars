//
//  RepoListVMRefreshTests.swift
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

class RepoListVMRefreshTests: QuickSpec {
	
	override func spec() {
		var stubServices: StubRefreshGitServices!
		var bag: DisposeBag!
		var scheduler: TestScheduler!
		var viewModel: RepoListVM!
		
		describe("RepoListVM") {
			beforeEach {
				scheduler = TestScheduler(initialClock: 0)
				bag = DisposeBag()
				stubServices = StubRefreshGitServices()
			}
			
			context("When pull to refresh, should reload repostirories") {
				beforeEach {
					let didLoad = BehaviorSubject<Void>(value: ())
					let didRefresh = scheduler.createColdObservable([ next(200, ()) ]).asObservable()
					let input = RepoListVM.Input(
						viewLoadTrigger: didLoad,
						refreshTrigger: didRefresh,
						loadMoreTrigger: Observable<Void>.empty()
					)
					
					viewModel = RepoListVM(input: input, serviceProvider: stubServices)
				}
				
				context("when request finish successfully") {
					beforeEach {
						stubServices.completeRequestWithSuccess = true
					}
					
					it("should update the repositories with new values") {
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
						expect(loading.events.compactMap{$0.value.element}).to(equal([false, true, false, true, false]))
						expect(result.events).to(equal([ next(0, 2), next(200, 4) ]))
					}
				}
				
				context("in case of request error") {
					beforeEach {
						stubServices.completeRequestWithSuccess = false
					}

					it("should return empty repositories list") {
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
						expect(loading.events.compactMap{$0.value.element}).to(equal([false, true, false, true, false]))
						expect(result.events).to(equal([ next(0, 2), next(200, 0) ]))
					}
				}
			}
		}
	}
}
