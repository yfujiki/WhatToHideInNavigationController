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

    private var statusBarHidden = false {
        didSet {
            if let items = hidingList["3. UIViewController"]  {
                items.forEach { (item) in
                    if item.title == "prefersStatusBarHidden (override)" {
                        item.switched = self.statusBarHidden
                    }
                }
            }
        }
    }

    private var homeIndicatorAutoHidden = false {
        didSet {
            if let items = hidingList["3. UIViewController"]  {
                items.forEach { (item) in
                    if item.title == "prefersHomeIndicatorAutoHidden (override)" {
                        item.switched = self.homeIndicatorAutoHidden
                    }
                }
            }
        }
    }

    @IBOutlet weak var tableView: UITableView!

    private var hidingList: [String: [Item]] = [
        "1. UINavigationItem": [
            Item("hidesSearchBarWhenScrolling", "Hides search bar on the bottom of navigation bar when scrolling the scrollview (hidden by default)", false)
        ],
        "2. UISearchController": [
            Item("hidesNavigationBarDuringPresentation", "Hides navigation bar when search is active (hidden by default)", false)
        ],
        "3. UINavigationBar": [
            Item("prefersLargeTitle", "Not exactly hiding anything, but the navigation shows in different size when you scroll to the top.", false)
        ],
        "4. UINavigationController": [
            Item("setNavigationBarHidden(:, animated:)", "Hides navigation bar.", false),
            Item("setToolBarHidden(:, animated:)", "Hides Toolbar (hidden by default)", false),
            Item("hidesBarsOnTap", "Hides Navigation/Toolbars when you tap on the main view", false),
            Item("hidesBarsOnSwipe", "Hides Navigation/Toolbars when you swipe up the scroll view from bottom", false),
            Item("hidesBarsWhenVerticallyCompact", "Hides Navigation/Toolbars on landscape view of the phone devices (except for plus and X devices)", false),
            Item("hidesBarsWhenKeyboardAppears", "Hides Navigation/Toolbars when keyboard appears", false)
        ],
        "5. UIViewController": [
            Item("prefersStatusBarHidden (override)", "Hides status bar when this view controller is visible", false),
            Item("prefersHomeIndicatorAutoHidden (override)", "Hides home indicator (existing only for edge to edge screen devices) when this view controller is shown", false)
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
        controller.hidesNavigationBarDuringPresentation = false
        return controller
    }()

    private func showSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func hideSearchBar() {
        navigationItem.searchController = nil
    }

    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return homeIndicatorAutoHidden
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

    // I don't know if this is a bug of UIScrollView or not, but we need this remedy to bring back bars after hiding bars with hidesBarsOnSwipe = true
    // https://stackoverflow.com/questions/32992897/hidesbarsonswipe-does-not-show-navigationbar-when-scrolling-up-to-the-top-slowly
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if (indexPath.section == 0 && indexPath.row == 0) {
//            navigationController?.hidesBarsOnSwipe = false
//            navigationController?.setNavigationBarHidden(false, animated: true)
//            navigationController?.setToolbarHidden(false, animated: true)
//        } else {
//            navigationController?.hidesBarsOnSwipe = true
//        }
//    }
}

extension ViewController: SwitchTableViewCellDelegate {
    func switched(isOn: Bool, for title: String?) {
        reset()

        var pushingNewViewController = false

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
            self.navigationItem.hidesSearchBarWhenScrolling = isOn
        case "hidesNavigationBarDuringPresentation":
            self.searchController.hidesNavigationBarDuringPresentation = isOn
        case "prefersStatusBarHidden (override)":
            if (isOn) {
                let viewControllerWithNoStatusBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                viewControllerWithNoStatusBar.statusBarHidden = true
                navigationController?.pushViewController(viewControllerWithNoStatusBar, animated: true)
                pushingNewViewController = true
            } else {
                navigationController?.popViewController(animated: true)
            }
        case "prefersHomeIndicatorAutoHidden (override)":
            if (isOn) {
                let viewControllerWithNoHomeIndicator = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                viewControllerWithNoHomeIndicator.homeIndicatorAutoHidden = true
                navigationController?.pushViewController(viewControllerWithNoHomeIndicator, animated: true)
                pushingNewViewController = true
            } else {
                navigationController?.popViewController(animated: true)
            }
        case "prefersLargeTitle":
            self.navigationController?.navigationBar.prefersLargeTitles = isOn
        default:
            break
        }

        if pushingNewViewController {
            tableView.reloadData()
            return
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

    private func reset() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.setToolbarHidden(false, animated: false)

        statusBarHidden = false
        homeIndicatorAutoHidden = false

        navigationController?.hidesBarsOnTap = false
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.hidesBarsWhenVerticallyCompact = false
        navigationController?.hidesBarsWhenKeyboardAppears = false
        navigationController?.navigationBar.prefersLargeTitles = false
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
