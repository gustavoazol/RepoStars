//
//  RepoListVMTests.swift
//  RepoStarsTests
//
//  Created by Gustavo Azevedo de Oliveira on 18/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxTest
import RxCocoa
@testable import RepoStars

class RepoListVMTests: QuickSpec {
	
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
			
			context("When controller loads, should try to fetch repostirories") {
				beforeEach {
					let didLoad = scheduler.createColdObservable([ next(0, ()) ]).asObservable()
					
					let input = RepoListVM.Input(
						viewLoadTrigger: didLoad,
						refreshTrigger: Observable<Void>.empty(),
						loadMoreTrigger: Observable<Void>.empty()
					)
					viewModel = RepoListVM(input: input, serviceProvider: stubServices)
				}
				
				context("when request finish successfully") {
					beforeEach {
						stubServices.completeRequestWithSuccess = true
					}
					
					it("should return the correct number of repositories") {
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
						expect(loading.events.compactMap{$0.value.element}).to(equal([false, true, false]))
						expect(result.events).to(equal([ next(0, 2) ]))
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
						expect(loading.events.compactMap{$0.value.element}).to(equal([false, true, false]))
						expect(result.events).to(equal([ next(0, 0) ]))
					}
				}
			}
		}
	}
}
