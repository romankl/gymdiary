//
// Created by Roman Klauke on 23.02.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//

import Foundation
import UIKit


@objc
public class ColorPickerCell: UITableViewCell {

    @IBOutlet weak var colorCollectionView: UICollectionView!

    public func setCollectionViewDelegateAndDataSource<A:protocol<UICollectionViewDelegate,
                                                          UICollectionViewDataSource>>(target: A) -> Void {

        colorCollectionView.delegate = target
        colorCollectionView.dataSource = target
    }

    public func setOffSetAndReloadData() -> Void {
        colorCollectionView.setContentOffset(colorCollectionView.contentOffset, animated: false)
        colorCollectionView.reloadData()
    }

    public var collectionViewOffset: CGFloat {
        set {
            colorCollectionView.contentOffset.x = newValue
        }

        get {
            return colorCollectionView.contentOffset.x
        }
    }
}
