//
//  AccountCell.swift
//  MoneyBox
//
//  Created by Robin Macharg on 26/09/2023.
//

import UIKit

class AccountCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var planValueLabel: UILabel!
    @IBOutlet weak var moneyboxAmountLabel: UILabel!
    
    // MARK: - Properties
    
    var id: Int?
    var delegate: AccountCellDelegate?
    var accountName: String?
    var planValue: Double?
    var moneybox: Double?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        layer.cornerRadius = 10
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AccountCell.didTapView(_:)))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Methods
    
    func configure(
        id: Int,
        accountName: String,
        planValue: Double,
        moneybox: Double,
        delegate: AccountCellDelegate)
    {
        self.delegate = delegate
        self.id = id
        self.accountName = accountName
        self.planValue = planValue
        self.moneybox = moneybox
        
        accountNameLabel.text = accountName
        planValueLabel.text = planValue.asCurrency()
        moneyboxAmountLabel.text = moneybox.asCurrency()
    }
    
    @objc
    func didTapView(_ sender: UITapGestureRecognizer) {
        if let accountName, let planValue, let moneybox, let id {
            delegate?.tapped(segueInfo: AccountsViewController.SegueInfo(
                account: accountName,
                planValue: planValue,
                moneybox: moneybox,
                id: id))
        }
    }
}
