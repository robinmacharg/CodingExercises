//
//  AccountsViewController.swift
//  MoneyBox
//
//  Created by Robin Macharg on 26/09/2023.
//

import UIKit
import Networking
import Combine

class AccountsViewController: UIViewController {
    
    struct SegueInfo {
        let account: String
        let planValue: Double
        let moneybox: Double
        let id: Int
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var planValue: UILabel!
    @IBOutlet weak var planValueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    // MARK: - Properties
    
    private var model = AccountsViewModel(dataProvider: DataProvider())
    private var bindings = Set<AnyCancellable>()
    
    /// Information to be passed to the account details screen
    private var segueInfo: SegueInfo?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
        name.text = ""
        planValue.text = ""
        planValueLabel.isHidden = true
        name.isHidden = true
        errorLabel.isHidden = true
        tryAgainButton.isHidden = true
        setBusy(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        loadData()
    }
    
    private func setUpBindings() {
        model.$state
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                case .initial:
                    break
                    
                case .loading:
                    self.errorLabel.isHidden = true
                    self.tryAgainButton.isHidden = true
                    self.setBusy(true)
                    
                case .loaded:
                    self.name.text = "Hello \(self.model.user?.firstName ?? "")!"
                    self.planValue.text = self.model.totalPlanValue?.asCurrency() ?? "0.00"
                    self.planValueLabel.isHidden = false
                    self.name.isHidden = false
                    self.setBusy(false)
                    self.tableView.reloadData()
                    
                case .error:
                    self.setBusy(false)
                    self.tableView.isHidden = true
                    self.errorLabel.isHidden = false
                    self.tryAgainButton.isHidden = false
                }
            }
            .store(in: &bindings)
    }
    
    // MARK: - Actions
    
    @IBAction func tryAgain(_ sender: Any) {
        loadData()
    }
    
    
    //  MARK: - Methods
    
    func loadData() {
        setBusy(true)
        model.loadData()
    }
    
    func setBusy(_ busy: Bool) {
        if busy {
            self.errorLabel.isHidden = true
            self.tryAgainButton.isHidden = true
            self.tableView.layer.opacity = 0.5
            self.tableView.isUserInteractionEnabled = false
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        else {
            self.tableView.layer.opacity = 1.0
            self.tableView.isUserInteractionEnabled = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Navigation

extension AccountsViewController {
    
    /**
     * Called by ancestors to load data.  Proxies to the model.
     */
    func configure(user: LoginResponse.User) {
        model.configure(user: user)
    }
    
    /**
     * Load the account details into the details view controller
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "accounts_details":
            if let segueInfo {
                (segue.destination as? AccountDetailsViewController)?.configure(
                    account: segueInfo.account,
                    planValue: segueInfo.planValue,
                    moneybox: segueInfo.moneybox,
                    id: segueInfo.id
                )
            }
        default:
            break
        }
    }
}

// MARK: - <UITableViewDataSource>

extension AccountsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.productResponses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "account", for: indexPath) as? AccountCell
        {
            if let product = model.productResponses?[indexPath.row],
               let planValue = product.planValue,
               let moneybox = product.moneybox,
               let name = product.product?.friendlyName,
               let id = product.id
            {
                cell.configure(
                    id: id,
                    accountName: name,
                    planValue: planValue,
                    moneybox: moneybox,
                    delegate: self)
                return cell
            }
            else {
                return tableView.dequeueReusableCell(withIdentifier: "error", for: indexPath)
            }
        }
        
        // In a real app we'd create a generic error cell by hand and return that
        fatalError("Can't dequeue cell")
    }
}

// MARK: - <AccountCellDelegate>

extension AccountsViewController: AccountCellDelegate {
    
    /**
     * Called by the cell when tapped
     */
    func tapped(segueInfo: SegueInfo) {
        self.segueInfo = segueInfo
        self.performSegue(withIdentifier: "accounts_details", sender: self)
    }
}
