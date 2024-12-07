//
//  SearchTableViewCell.swift

// Repurposed from: App14  created by Sakib Miazi on 6/14/23.
// pilly
import UIKit

class SearchTableViewCell: UITableViewCell {
    var wrapperCellView: UIView!
    var labelTitle: UILabel!
    var labelAddress: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWrapperCellVIew()
        setupLabelTitle()
        setupLabelAddress()
        initConstraints()
    }
    
    func setupWrapperCellVIew() {
        wrapperCellView = UITableViewCell()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelTitle() {
        labelTitle = UILabel()
        labelTitle.font = UIFont.boldSystemFont(ofSize: 16)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTitle)
    }
    
    func setupLabelAddress() {
        labelAddress = UILabel()
        labelAddress.font = UIFont.systemFont(ofSize: 14)
        labelAddress.textColor = .gray
        labelAddress.numberOfLines = 2
        labelAddress.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelAddress)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            labelTitle.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelTitle.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelTitle.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            
            labelAddress.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 4),
            labelAddress.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelAddress.trailingAnchor.constraint(equalTo: labelTitle.trailingAnchor),
            labelAddress.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8),
            
            wrapperCellView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
