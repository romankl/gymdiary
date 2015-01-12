//
//  UIView+LayoutHelper.m
//  Gym Diary
//
//  Created by Roman Klauke on 11.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "UIView+LayoutHelper.h"

@implementation UIView (LayoutHelper)

- (void)showBorderOfViewWithColor:(UIColor *)color {
#if DEBUG
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = .5f;
#endif
}

@end
