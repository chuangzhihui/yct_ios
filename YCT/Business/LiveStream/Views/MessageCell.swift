//
//  MessageCell.swift
//  YCT
//
//  Created by Lucky on 22/03/2024.
//

import Foundation

final class MessageCell: UITableViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    // MARK: - Constructors
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        self.contentView.addSubview(label)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
}
