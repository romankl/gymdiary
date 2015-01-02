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

typedef NS_ENUM(NSInteger, NotificationDuration) {
    NotifcationShort = 1,
    NotificationNormal,
    NotificationLong
};


+ (void)notificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle andNotificationStyle:(NotificationStyle)style;

+ (void)notificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle withDuration:(NotificationDuration)duration andNotificationStyle:(NotificationStyle)style;

+ (void)notificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle withDuration:(NotificationDuration)duration andAnimationDuration:(NotificationDuration)animationDuration andNotificationStyle:(NotificationStyle)style;

+ (void)notificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle withCustomDuration:(float)duration andCustomAnimationDuration:(float)animationDuration andNotificationStyle:(NotificationStyle)style;

+ (void)notificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle withCustomDuration:(float)duration andNotificationStyle:(NotificationStyle)style;

- (void)showNotificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle withColor:(UIColor *)backgroundColor andAnimationDuration:(float)animationTime andVisibleTime:(float)visibleTime;

@end
