//
//  DynamicNotification.h
//  Gym Diary
//
//  Created by Roman Klauke on 01.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicNotification : UIView

typedef NS_ENUM(NSInteger, NotificationStyle) {
    NotificationStyleError,
    NotificationStyleSuccess,
    NotificationStyleInfo,
    NotificationStyleWarning
};


+ (void)notificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle andNotificationStyle:(NotificationStyle)style;

- (void)showNotificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle withColor:(UIColor *)backgroundColor andAnimationDuration:(float)animationTime andVisibleTime:(float)visibleTime;

@end
