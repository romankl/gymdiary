//
// Created by Roman Klauke on 04.04.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//

import Foundation


enum Theme: Int {
    case Light = 0, Dark, Blue, Green

    init(key: Int) {
        switch key {
        case 1: self = .Light
        case 2: self = .Dark
        case 3: self = .Blue
        case 4: self = .Green
        default: self = .Dark
        }
    }

    func apply() -> Void {

    }

    static func descriptionForThemes() -> [String] {
        return [
                NSLocalizedString("Light", comment: "Light theme key"),
                NSLocalizedString("Dark", comment: "Dark theme key"),
                NSLocalizedString("Blue", comment: "Blue theme key"),
                NSLocalizedString("Green", comment: "Green theme key"),
        ]
    }
}

struct UIKitTheming {
    static func applyNavbarTheme(barColor: UIColor, textColor: UIColor, buttonColor: UIColor) -> Void {
        UINavigationBar.appearance().barTintColor = barColor
        UINavigationBar.appearance().tintColor = buttonColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: textColor]
    }

    static func applyNavBarButtonTheme(buttonColor: UIColor) -> Void {
        UIButton.appearanceWhenContainedInInstancesOfClasses([UINavigationBar.self]).setTitleColor(buttonColor,
                forState: .Normal)

    }

    static func applyTabBarTheme(barColor: UIColor, textColor: UIColor) -> Void {
        UITabBar.appearance().barTintColor = barColor
        UITabBar.appearance().tintColor = textColor
    }

    static func applyButtonTheme(buttonColor: UIColor) -> Void {
        UIButton.appearance().setTitleColor(buttonColor, forState: .Normal)
    }

    static func applyTableViewTheme(backgroundColor: UIColor) -> Void {
        UITableView.appearance().backgroundColor = backgroundColor
    }

    static func applyTableViewCellTheme(backgroundColor: UIColor, titleColor: UIColor, subTitleColor:
            UIColor) -> Void {
        UITableViewCell.appearance().backgroundColor = backgroundColor
        UITableViewCell.appearance().textLabel?.textColor = titleColor
        UITableViewCell.appearance().detailTextLabel?.textColor = subTitleColor
    }
}
