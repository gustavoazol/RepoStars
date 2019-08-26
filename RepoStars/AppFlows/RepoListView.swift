//
//  RepoListView.swift
//  RepoStars
//
//  Created by Gustavo Azevedo de Oliveira on 25/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import UIKit
import SnapKit

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
		self.backgroundColor = .purple
		
		titleLabel.backgroundColor = .purple
		titleLabel.textColor = .white
		titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
		titleLabel.textAlignment = .center
		
		tableView.refreshControl = self.refreshControl
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 100.0
		
		// Layout
		self.addSubview(titleLabel)
		self.addSubview(tableView)
		
		titleLabel.snp.makeConstraints { (maker) in
			maker.top.equalTo(safeAreaLayoutGuide.snp.top)
			maker.left.equalTo(safeAreaLayoutGuide.snp.left)
			maker.right.equalTo(safeAreaLayoutGuide.snp.right)
			maker.height.equalTo(50)
		}
		
		tableView.snp.makeConstraints { (maker) in
			maker.top.equalTo(titleLabel.snp.bottom)
			maker.left.equalTo(safeAreaLayoutGuide.snp.left)
			maker.right.equalTo(safeAreaLayoutGuide.snp.right)
			maker.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).priority(999)
		}
	}
}
