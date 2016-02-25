//
// Created by Roman Klauke on 23.02.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//

import Foundation
import UIKit

@objc
public class ColorCell: UICollectionViewCell {
    public var circleColor: UIColor! {
        didSet {
            self.circleView.backgroundColor = circleColor
        }
    }
    var circleView: UIView!

    public var marked = false {
        didSet {
            if marked {
                self.circleView.backgroundColor = .redColor()
            } else {

            }
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundColor = .whiteColor()

        circleView = UIView(frame: frame)
        circleView.backgroundColor = circleColor
        circleView.backgroundColor = circleColor
        circleView.layer.cornerRadius = frame.width / 2

        addSubview(circleView)
    }

}
