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
		self.customView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
	}
	
	private func bindViewModel() {
		let didLoadObservable = BehaviorSubject<Void>(value: ())
		
		let refreshObservable = customView.refreshControl.rx
			.controlEvent(.valueChanged)
			.asObservable()
		
		let loadMore = Observable<Void>.empty()
		
		let inputs = RepoListVM.Input(
			viewLoadTrigger: didLoadObservable,
			refreshTrigger: refreshObservable,
			loadMoreTrigger: loadMore
		)
		
		
		let viewModel = RepoListVM(input: inputs)
		viewModel.loadingList
			.debug("Loding List", trimOutput: true)
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
			.drive(customView.tableView.rx.items(cellIdentifier: cellReuseId)) { _ , repo, cell in
				cell.textLabel?.text = repo.name
				cell.detailTextLabel?.text = repo.description
				
				let url = URL(string: repo.owner.avatarUrl)
				cell.imageView?.kf.setImage(with: url)
			}
			.disposed(by: bag)
		
		
		viewModel.loadingList
			.filter({ !$0 })
			.drive(onNext: { [weak self] _ in
				self?.customView.refreshControl.endRefreshing()
			})
			.disposed(by: bag)
	}
}
