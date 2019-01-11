![platform](https://img.shields.io/badge/platform-iOS11-blue.svg)
![language](https://img.shields.io/badge/language-swift4.2-green.svg)
![twitter](https://img.shields.io/badge/twitter-@yfujiki-blue.svg)

## Summary
There are many options you can tweak and hide around `UINavigationController`. For example, calling `UINavigationController.setNavigationBarHidden(true:, animated: true)` will hide navigation bar. Or, `UINavigationController.hidesBarsOnTap = true` will hide both navigation bar and bottom tool bar (if present) when you tap on the main view.

This repo demonstrates those hide actions. 

Example actions : 
![Demo](./hideBars.gif)

## Hide items
### `UINavigationController.setNavigationBarHidden(:, animated:)`
You can hide navigation bar by calling `navigationController?.setNavigationBarHidden(true, animated: true)`.

### `UINavigationController.setToolBarHidden(:, animated:)`
You can hide tool bar on the bottom by calling `navigationController?.setToolbarHidden(true, animated: true)`.

The toolbar is hidden by default though. In order to show toolbar, you need to set `BarButtonItems` into the toolbar. e.g.,

```
let actionItem = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
toolbarItems = [actionItem, spacerItem, saveItem]

navigationController?.setToolbarHidden(false, animated: false)
```

### `UINavigationController.hidesBarsOnTap`
If you tap on the main view after setting `navigationController?.hidesBarsOnTap = true`, then both navigation bar and tool bar will toggle.

### `UINavigationController.hidesOnSwipe`
If you swipe up from the bottom of the screen after setting `navigationController?.hidesOnSwipe = true`, then both navigation bar and tool bar will hide. However, contrary to the expectation, swiping down does not bring the bars back. Once you hide the bars with swipe, those bars are basically gone. Not sure if this is an expected behavior or a bug, but there are quite a few Stackoverflow post that complains about it. (e.g, https://stackoverflow.com/questions/32992897/hidesbarsonswipe-does-not-show-navigationbar-when-scrolling-up-to-the-top-slowly)

One work-around is to show them again when the first row became visible. 

```
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            navigationController?.hidesBarsOnSwipe = false
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.setToolbarHidden(false, animated: true)
        } else {
            navigationController?.hidesBarsOnSwipe = true
        }
    }
```

### `UINavigationController.hidesBarsWhenVerticallyCompact`
If you rotate your device to landscape orientation after setting `navigationController?.hidedsBarsWhenVerticallyCompact = true`, then both navigation bar and tool bar will hide. Rotating back to the portrait orientation will bring them back.

### `UINavigationController.hidesBarsWhenKeyboardAppears`
If you bring on the keyboard after setting `navigationController?.hidesBarsWhenKeyboardAppears = true`, then both navigation bar and tool bar will hide. However, contrary to expectation, dismissing keyboard will not bring them back. In this demo, we capture `UITextFieldDelegate.textFieldShouldReturn(_:)` and bringing the bars back manually.

```
    navigationController?.setNavigationBarHidden(false, animated: true)
    navigationController?.setToolbarHidden(false, animated: true)
```

Another pitfall, which I think is a bug of iOS: Once you set this flag to `true`, the behavior persists even after setting it to `false`. I guess it is not very common to switch this settings within the lifetime of a `UIViewController`, so it is practically ok.

Also, don't tap on the search bar under navigation bar when this flag is ON. The search bar is part of the navigation bar, so when you tap on the search bar and bring up the keyboard, the search bar itself will be hidden. 

### `UINavigationBar.hidesSearchBarWhenScrolling`
If you scroll up the table view after setting `navigationItem.hidesSearchBarWhenScrolling = true`, the search bar under navigation bar will collapse. It will expand to show up again when you scroll down the table view.

### `UISearchController.hidesNavigationBarDuringPresentation`
If you tap on the search bar after setting `searchController.hidesNavigationBarDuringPresentation = true`, then navigation bar will hide and only search bar will occupy the top portion.

### `UIViewController.prefersStatusBarHidden`
If you override this method and return `true`, status bar will be hidden.

```

var statusBarHidden = false

override var prefersStatusBarHidden: Bool {
    return statusBarHidden
}

...

    statusBarHidden = true
    setNeedsStatusBarAppearanceUpdate()
```

It doesn't do anything on edge-to-edge device like iPhone X. I guess it doesn't make sense to hide status bar because stauts bar is basically occupying notch area.

### `UIViewController.homeIndicatorAutoHidden`
If you override this method and return `true`, the thin white bar that indicates the home button on edge-to-edge screen, will fade away. 

```

var homeIndicatorAutoHidden = false

override var prefersHomeIndicatorAutoHidden: Bool {
    return homeIndicatorAutoHidden
}

...

    homeIndicatorAutoHidden = true
    setNeedsUpdateOfHomeIndicatorAutoHidden()
```

### `UINavigationBar.prefersLargeTitle`
You set `self.navigationController?.navigationBar.prefersLargeTitles = true` and scroll up and down the table view. When you scroll up, you will see small navigation bar, and large navigation bar on scrolling down.
