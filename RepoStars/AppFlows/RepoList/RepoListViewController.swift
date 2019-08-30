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
import Kingfisher


class RepoListViewController: UIViewController {
	let cellReuseId = "RepositoryCell"
	let bag = DisposeBag()
	
	var customView: RepoListView {
		return self.view as! RepoListView
	}
	
	override func loadView() {
		view = RepoListView()
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupViews()
		self.bindViewModel()
	}

	private func setupViews() {
		self.customView.titleLabel.text = "Top Repositories"
		self.customView.tableView.register(RepoTableViewCell.self, forCellReuseIdentifier: cellReuseId)
	}
	
	private func bindViewModel() {
		let didLoadObservable = BehaviorSubject<Void>(value: ())
		
		let refreshObservable = customView.refreshControl.rx
			.controlEvent(.valueChanged)
			.asObservable()
		
		let loadMore = customView.tableView.rx.contentOffset
			.map { [unowned self] (offset) -> Bool in
				let contentHeight = self.customView.tableView.contentSize.height
				let viewHeight = self.customView.tableView.bounds.height
				let inLastVisibleBound = offset.y >= (contentHeight - 2*viewHeight)
				return inLastVisibleBound
			}
			.distinctUntilChanged()
			.filter({ $0 })
			.map({_ in () })
		
		
		let inputs = RepoListVM.Input(
			viewLoadTrigger: didLoadObservable,
			refreshTrigger: refreshObservable,
			loadMoreTrigger: loadMore
		)
		
		
		let viewModel = RepoListVM(input: inputs)
		viewModel.loadingList
			.drive(onNext: { [weak self] loading in
				let refreshControl = self?.customView.tableView.refreshControl
				loading ? refreshControl?.beginRefreshing() : refreshControl?.endRefreshing()
			})
			.disposed(by: bag)
		
		
		viewModel.loadingMore
			.drive(onNext: { loading in
				print("Loading More: \(loading)")
			})
			.disposed(by: bag)

		
		viewModel.repositories
			.drive(customView.tableView.rx
				.items(cellIdentifier: cellReuseId, cellType: RepoTableViewCell.self)) { _ , repo, cell in
					cell.repoName.text = repo.name
					cell.repoAuthor.text = repo.owner.username
					cell.repoDescription.text = repo.description
					cell.repoRatingText.text = "\(repo.starsCount) stars"
					
					let url = URL(string: repo.owner.avatarUrl)
					cell.repoPhoto.kf.setImage(with: url)
				}
				.disposed(by: bag)
		
		
		viewModel.loadingList
			.drive(customView.refreshControl.rx.isRefreshing)
			.disposed(by: bag)
	}
}
