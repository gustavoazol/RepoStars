//
//  RepoTableViewCell.swift
//  RepoStars
//
//  Created by Gustavo Azevedo de Oliveira on 25/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import UIKit
import SnapKit


class RepoTableViewCell: UITableViewCell {
	let repoPhoto = UIImageView()
	let repoName = UILabel()
	let repoAuthor = UILabel()
	let repoDescription = UILabel()
	let repoRatingText = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupLayout()
	}
	
	private func setupLayout() {
		self.addViewsAndSetPriorities()
		self.setStyles()
		
		let leftTextOffset: CGFloat = 10
		
		repoPhoto.snp.makeConstraints { (maker) in
			maker.top.left.equalTo(contentView).offset(10)
			maker.bottom.lessThanOrEqualToSuperview().offset(-10).priority(999)
			maker.size.equalTo(50)
		}
		
		repoName.snp.makeConstraints { (maker) in
			maker.top.equalTo(contentView).offset(10)
			maker.left.equalTo(repoPhoto.snp.right).offset(leftTextOffset)
		}
		
		repoAuthor.snp.makeConstraints { (maker) in
			maker.right.equalTo(contentView).offset(-10)
			maker.left.equalTo(repoName.snp.right).offset(leftTextOffset)
			maker.bottom.equalTo(repoName.snp.bottom)
		}
		
		repoDescription.snp.makeConstraints { (maker) in
			maker.top.equalTo(repoName.snp.bottom)
			maker.left.equalTo(repoPhoto.snp.right).offset(leftTextOffset)
			maker.right.equalTo(contentView).offset(-10)
		}
		
		repoRatingText.snp.makeConstraints { (maker) in
			maker.top.equalTo(repoDescription.snp.bottom).offset(5)
			maker.left.equalTo(repoPhoto.snp.right).offset(leftTextOffset)
			maker.right.equalTo(contentView).offset(-10)
			maker.bottom.equalTo(contentView).offset(-10).priority(998)
		}
	}
	
	private func addViewsAndSetPriorities() {
		contentView.addSubview(repoPhoto)
		contentView.addSubview(repoName)
		contentView.addSubview(repoAuthor)
		contentView.addSubview(repoDescription)
		contentView.addSubview(repoRatingText)
		
		repoName.setContentHuggingPriority(.required, for: .vertical)
		repoName.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		repoDescription.setContentHuggingPriority(.required, for: .vertical)
		repoRatingText.setContentHuggingPriority(.required, for: .vertical)
		
		repoName.setContentCompressionResistancePriority(.required, for: .vertical)
		repoDescription.setContentCompressionResistancePriority(.required, for: .vertical)
		repoRatingText.setContentCompressionResistancePriority(.required, for: .vertical)
	}
	
	private func setStyles() {
		repoPhoto.contentMode = .scaleAspectFill
		repoPhoto.clipsToBounds = true
		
		repoName.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		repoName.numberOfLines = 2
		
		repoAuthor.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
		repoAuthor.textColor = .lightGray
		
		repoDescription.font = UIFont.systemFont(ofSize: 15, weight: .regular)
		repoDescription.minimumScaleFactor = 0.8
		repoDescription.numberOfLines = 3
		
		repoRatingText.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
		let darkYellow = UIColor(red: 244.0/255, green: 160.0/255, blue: 0.0, alpha: 1.0)
		repoRatingText.textColor = darkYellow
	}
}
