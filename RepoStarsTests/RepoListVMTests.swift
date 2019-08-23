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
		let stubServices = StubGitServices()
		var bag: DisposeBag!
		var scheduler: TestScheduler!
		
		describe("RepoListVM") {
			beforeEach {
				scheduler = TestScheduler(initialClock: 0)
				bag = DisposeBag()
			}
			
			context("When controller loads, should try to load repostirories") {
				var viewModel: RepoListVM!
				
				beforeEach {
					let didLoad = scheduler.createColdObservable([ next(0, ()) ]).asObservable()
					let input = RepoListVM.Input(viewLoadTrigger: didLoad)
					viewModel = RepoListVM(input: input, serviceProvider: stubServices)
				}
				
				it("should show and hide load during fetch") {
					let loading = scheduler.createObserver(Bool.self)
					viewModel.loadingList
						.drive(loading)
						.disposed(by: bag)
					
					viewModel.respositories
						.drive()
						.disposed(by: bag)
					
					scheduler.start()
					expect(loading.events.compactMap{$0.value.element}).to(equal([true, false]))
				}
				
				context("when request finish successfully") {
					beforeEach {
						stubServices.completeRequestWithSuccess = true
					}
					
					it("should return the correct number of repositories") {
						let result = scheduler.createObserver(Int.self)
						
						viewModel.respositories
							.map({$0.count})
							.drive(result)
							.disposed(by: bag)
			
						scheduler.start()
						expect(result.events).to(equal([ next(0, 2) ]))
					}
				}
				
				context("in case of request error") {
					beforeEach {
						stubServices.completeRequestWithSuccess = false
					}
					
					it("should return empty repositories list") {
						let result = scheduler.createObserver(Int.self)
						viewModel.respositories
							.map({$0.count})
							.drive(result)
							.disposed(by: bag)
						
						scheduler.start()
						expect(result.events).to(equal([ next(0, 0) ]))
					}
				}
			}
		}
	}
}


class StubGitServices: GitHubServices {
	enum StubError: Error {
		case requesFailed
	}
	
	var completeRequestWithSuccess = true
	
	private func createStubRepo() -> Repository {
		let jsonData = StubRepoJson.asData()
		let repository = try! JSONDecoder().decode(Repository.self, from: jsonData)
		return repository
	}
	
	override func getSwiftRepositories() -> Single<GitHubResponse> {
		if completeRequestWithSuccess {
			let repo = createStubRepo()
			let response = GitHubResponse(repositories: [repo, repo])
			return Observable.just(response).asSingle()
		}
		else {
			return Single<GitHubResponse>.error(StubError.requesFailed)
		}
	}
}
