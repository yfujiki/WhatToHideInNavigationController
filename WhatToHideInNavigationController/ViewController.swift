//
//  ViewController.swift
//  WhatToHideInNavigationController
//
//  Created by Yuichi Fujiki on 1/10/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private class Item {
        var title: String
        var description: String
        var switched: Bool

        init(_ title: String, _ description: String, _ switched: Bool) {
            self.title = title
            self.description = description
            self.switched = switched
        }
    }

    @IBOutlet weak var tableView: UITableView!

    private var hidingList: [String: [Item]] = [
        "1. UINavigationItem": [
            Item("hidesSearchBarWhenScrolling", "Hides search bar on the bottom of navigation bar when scrolling the scrollview (hidden by default)", false)
        ],
        "2. UINavigationController": [
            Item("setNavigationBarHidden(:, animated:)", "Hides navigation bar.", false),
            Item("setToolBarHidden(:, animated:)", "Hides toolbar (hidden by default)", false),
            Item("hidesBarsOnTap", "Navigation/Toolbars hide when you tap on the main view", false),
            Item("hidesBarsOnSwipe", "Navigation/Toolbars hide when you swipe up/down the scroll view", false),
            Item("hidesBarsWhenVerticallyCompact", "Navigation/Toolbars hide when you rotate horizontally on the phone devices (except for plus and X devices)", false),
            Item("hidesBarsWhenKeyboardAppears", "Navigation/Toolbars hide when keyboard appears", false)
        ],
        "3. UIViewController": [
            Item("prefersStatusBarHidden (override)", "Hides status bar when this view controller is visible", false),
            Item("prefersHomeIndicatorAutoHidden (override)", "Hides home indicator (back button) when this view controller is shown", false),
            Item("hidesBottomBarWhenPushed", "Hides bottom bar when this view controller is visible", false)
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("What to hide around navigation controller", comment: "")
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switchTableViewCell")

        showSearchBar()
        prepareToolBar()
    }

    private func prepareToolBar() {
        let actionItem = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        toolbarItems = [actionItem, spacerItem, saveItem]

        navigationController?.setToolbarHidden(false, animated: false)
    }

    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        return controller
    }()

    private func showSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        NSLog("Content inset top : \(tableView.contentInset.top)")
    }

    private func hideSearchBar() {
        navigationItem.searchController = nil

        NSLog("Content inset top : \(tableView.contentInset.top)")
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return hidingList.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = Array(hidingList.keys.sorted())[section]
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let title = Array(hidingList.keys.sorted())[section]
        let listInSection = hidingList[title]!
        return listInSection.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionTitle = Array(hidingList.keys.sorted())[indexPath.section]
        let listInSection = hidingList[sectionTitle]!
        let rowItem = listInSection[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "switchTableViewCell") as! SwitchTableViewCell
        cell.titleLabel.text = rowItem.title
        cell.descriptionLabel.text = NSLocalizedString(rowItem.description, comment: "")
        cell.switch.isOn = rowItem.switched
        cell.delegate = self

        return cell
    }
}

extension ViewController: SwitchTableViewCellDelegate {
    func switched(isOn: Bool, for title: String?) {
        unhideBars()

        switch title {
        case "setNavigationBarHidden(:, animated:)":
            self.navigationController?.setNavigationBarHidden(isOn, animated: true)
        case "setToolBarHidden(:, animated:)":
            self.navigationController?.setToolbarHidden(isOn, animated: true)
        case "hidesBarsOnTap":
            self.navigationController?.hidesBarsOnTap = isOn
        case "hidesBarsOnSwipe":
            self.navigationController?.hidesBarsOnSwipe = isOn
        case "hidesBarsWhenVerticallyCompact":
            self.navigationController?.hidesBarsWhenVerticallyCompact = isOn
        case "hidesBarsWhenKeyboardAppears":
            self.navigationController?.hidesBarsWhenKeyboardAppears = isOn
        case "hidesSearchBarWhenScrolling":
            self.navigationItem.hidesSearchBarWhenScrolling = true

        default:
            break
        }

        hidingList.forEach { (_, items) in
            items.forEach({ (item) in
                if item.title == title {
                    item.switched = isOn
                }
                if item.switched && item.title != title {
                    item.switched = false
                }
            })
        }

        tableView.reloadData()
    }

    private func unhideBars() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        NSLog("Update search results.")
    }
}
