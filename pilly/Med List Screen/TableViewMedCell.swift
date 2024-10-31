//
//  TableViewMedCell.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/29/24.
//

import UIKit

class TableViewMedCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var labelTitle: UILabel!
    var labelDosage: UILabel!
    var labelTime: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWrapperCellView()
        setupLabelTitle()
        setupLabelDosage()
        setupLabelTime()
        initConstraints()
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelTitle(){
        labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTitle)
    }
    
    func setupLabelDosage(){
        labelDosage = UILabel()
        labelDosage.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelDosage)
    }
    
    func setupLabelTime(){
        labelTime = UILabel()
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTime)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            labelTitle.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 4),
            labelTitle.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 4),
            labelTitle.heightAnchor.constraint(equalToConstant: 20),
                
            labelDosage.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 4),
            labelDosage.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelDosage.heightAnchor.constraint(equalToConstant: 20),
            
            labelTime.topAnchor.constraint(equalTo: labelDosage.bottomAnchor, constant: 4),
            labelTime.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelTime.heightAnchor.constraint(equalToConstant: 20),
                
            wrapperCellView.heightAnchor.constraint(equalToConstant: 76)
            ])
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
