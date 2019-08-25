//
//  RepoListView.swift
//  RepoStars
//
//  Created by Gustavo Azevedo de Oliveira on 25/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import UIKit
import Stevia

class RepoListView: UIView {
	let titleLabel = UILabel()
	let refreshControl = UIRefreshControl()
	let tableView = UITableView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		self.backgroundColor = .white
		
		titleLabel.backgroundColor = .purple
		titleLabel.textColor = .white
		titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
		titleLabel.textAlignment = .center
		
		tableView.refreshControl = self.refreshControl
		tableView.rowHeight = UITableView.automaticDimension
		
		// Layout
		sv(
			titleLabel,
			tableView
		)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		layout(
			safeAreaInsets.top,
			|titleLabel.height(60)|,
			10,
			|-tableView-|,
			safeAreaInsets.bottom
		)
	}
}
