//
//  ViewController.swift
//  Superheroes
//
//  Created by Robin Macharg2 on 01/08/2021.
//

import Cocoa

class MainVC: NSViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var outlineView: NSOutlineView!
    @IBOutlet weak var historyTableView: NSTableView!

    // MARK: - Properties

    // Relatively expensive so create only once
    private let dateFormatter = DateFormatter()

    private var model: MainVCViewModel = MainVCViewModel()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "yyyy/MM/dd, HH:mm:ss"
    }

    // MARK: - Actions
    
    /**
     * Build and submit a request, updating the model on success
     */
    @IBAction func submitRequest(_ sender: Any) {

        DispatchQueue.global().async {
            let squads = Data.createSquads(maxSquads: 5, maxMembers: 5)
            let request = API.makeURLRequest(squads: squads)

            switch request {
            case .success(let urlRequest):
                let requestID = UUID()
                let request = Request(
                    id: requestID,
                    timestamps: Request.Timestamps(started: Date()),
                    squads: squads,
                    request: urlRequest,
                    state: .created)

                // Full MVVM would use a model method and have some observation mechanism on the history property
                self.model.history.append(request)

                // Update the history with the initial (unreturned) request
                self.reloadHistoryPreservingSelection()

                API.sendRequest(request) { [self] request in
                    if let request = self.model.history.filter({ $0.id == requestID }).first {
                        request.state = .completed
                        request.timestamps.completed = Date()
                    }

                    self.reloadHistoryPreservingSelection()
                }
            case .failure(let error):
                fatalError("unhandled: \(error.localizedDescription)")
            }
        }
    }

    /**
     * Preserve (and later restore) the user's selection
     */
    private func reloadHistoryPreservingSelection() {
        DispatchQueue.main.async {
            let selectedRowIndex = self.historyTableView.selectedRow
            self.historyTableView.reloadData()
            self.historyTableView.selectRowIndexes([selectedRowIndex], byExtendingSelection: false)
        }
    }
}

// MARK: - Shared UI Item Identifiers

extension MainVC {
    fileprivate enum CellIdentifiers {
        static let HistoryCellID = NSUserInterfaceItemIdentifier("HistoryCell")
        static let KeyCellID     = NSUserInterfaceItemIdentifier("KeyCell")
        static let KeyColumnID   = NSUserInterfaceItemIdentifier("KeyColumn")
        static let ValueColumnID = NSUserInterfaceItemIdentifier("ValueColumn")
    }
}

// MARK: - <NSTableViewDelegate>

extension MainVC: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // Only a single column, so dispense with any column filtering
        if let cell = tableView.makeView(
            withIdentifier: CellIdentifiers.HistoryCellID,
            owner: nil) as? HistoryCell
        {
            let item = self.model.history[row]

            var dateString = ""
            if let started = item.timestamps.started {
                dateString = "Started: \(dateFormatter.string(from: started))"
            }

            if let completed = item.timestamps.completed {
                dateString += " - Completed: \(dateFormatter.string(from: completed))"
            }

            cell.dateLabel?.stringValue = dateString

            let squadCountText = "\(item.squads.count) squad\((item.squads.count == 0 || item.squads.count > 1) ? "s" : "")"

            // Simpler than string interpolation
            var squadNames = ""
            if item.squads.count > 0 {
                squadNames = "(" + item.squads.map({ squad in squad.squadName }).joined(separator: ", ") + ")"
            }

            cell.detailsLabel?.stringValue = "\(squadCountText) \(squadNames)"
                //"\(item.squads.count) squad\((item.squads.count == 0 || item.squads.count > 1) ? "s" : "") (\(item)"

          return cell
        }
        return nil
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        if let selectedRow = historyTableView.selectedRowIndexes.first {
            model.currentRequest = model.history[selectedRow]
        }
        else {
            model.currentRequest = nil
        }

        DispatchQueue.main.async {
            self.outlineView.reloadData()
            self.outlineView.expandItem(nil, expandChildren: true)
        }
    }
}

// MARK: - <NSTableViewDataSource>

extension MainVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.model.history.count
    }
}

// MARK: - <NSOutlineViewDataSource>

extension MainVC: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {

        switch item {
        case nil:
            // Ensure that we only show /returned/ data
            return model.currentRequest?.returnedData?.count ?? 0
        case is SuperheroSquad:
            return 5 // hardcoded - could use a list of fields and build the list in the next function
        case let members as [Member]:
            return members.count
        case is Member:
            return 3 // Likewise, hardcoded
        default:
            return 0
        }
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        switch item {
        case let squad as SuperheroSquad:
            // This style vs. a switch... Undecided which is clearer
            return [
                ("id",        "\(squad.id)"),
                ("Home Town", "\(squad.homeTown)"),
                ("Formed in", "\(squad.formed)"),
                ("Active",    "\(squad.active ? "Yes" : "No")"),
                squad.members,
            ][index]

        case let members as [Member]:
            return members[index]

        case let member as Member:
            return [
                ("Age",             "\(member.age) years old"),
                ("Secret Identity", "\(member.secretIdentity)"),
                // Explicitly avoiding another level of outline since we're quite deep already.
                // Hopefully this delegate code shows off the idea sufficiently
                ("Powers",          member.powers.joined(separator: ", ")),
            ][index]

        default:
            return model.currentRequest?.squads[index] as Any
        }
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return item is SuperheroSquad
            || item is [Member]
            || item is Member
        // If we were to expand the 'powers' field we'd pick it up here
    }
}

// MARK: - <NSOutlineViewDelegate>

extension MainVC: NSOutlineViewDelegate {

    // A convenience tuple for passing (key, value)s around
    typealias StringKeyValue = (String, String)

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let columnIdentifier = tableColumn?.identifier else {
            return nil
        }

        // A sensible default value to clear unused cells
        var textFieldValue = ""

        if let view = outlineView.makeView(
            withIdentifier: CellIdentifiers.KeyCellID,
            owner: self) as? NSTableCellView
        {
            switch item {
            case let squad as SuperheroSquad:
                if columnIdentifier == CellIdentifiers.KeyColumnID {
                    textFieldValue = squad.squadName
                }

            case is [Member]:
                if columnIdentifier == CellIdentifiers.KeyColumnID {
                    textFieldValue = "Members"
                }

            case let member as Member:
                if columnIdentifier == CellIdentifiers.KeyColumnID {
                    textFieldValue = "\(member.name)"
                }

            // Using StringKeyValue allows generic reuse
            case let (key, value) as StringKeyValue:
                // An explicit switch is clearer and more extensible than e.g. a presumptive ternary that assumes only two columns
                switch columnIdentifier {
                case CellIdentifiers.KeyColumnID:
                    textFieldValue = key
                case CellIdentifiers.ValueColumnID:
                    textFieldValue = value
                default:
                    break
                }

            default:
                break
            }

            view.textField?.stringValue = textFieldValue

            return view
        }

        return nil
    }
}
