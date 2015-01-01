//
//  DynamicNotification.m
//  Gym Diary
//
//  Created by Roman Klauke on 01.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "DynamicNotification.h"

@interface DynamicNotification ()

@property(strong, nonatomic) UILabel *title;
@property(strong, nonatomic) UILabel *subtitle;
@property(nonatomic) float animationTime;
@property(nonatomic) float visibleTime;
@end

@implementation DynamicNotification

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, frame.size.width - (2 * 15), 31)];
        self.title.textColor = [UIColor whiteColor];
        self.title.font = [UIFont fontWithName:@"Avenir-Medium" size:14];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.numberOfLines = 1;
        [self addSubview:self.title];

        self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + self.title.bounds.size.height, frame.size.width - (2 * 15), 35)];
        self.subtitle.textColor = [UIColor whiteColor];
        self.subtitle.font = [UIFont fontWithName:@"Avenir-Light" size:12];
        self.subtitle.textAlignment = NSTextAlignmentCenter;
        self.subtitle.numberOfLines = 1;
        [self addSubview:self.subtitle];

        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
        [self addGestureRecognizer:gestureRecognizer];
    }

    return self;
}

- (void)hide:(UIView *)view {
    [UIView animateWithDuration:self.animationTime animations:^{
        CGRect frame = view.frame;
        frame.origin.y = -85;
        view.frame = frame;
    }                completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

+ (void)notificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle andNotificationStyle:(NotificationStyle)style {
    DynamicNotification *notification = [[DynamicNotification alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 85)];

    [notification showNotificationWithTitle:title subTitle:subtitle withColor:[self colorForNotificationStyle:style] andAnimationDuration:1.5 andVisibleTime:3];
}

- (void)showNotificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle withColor:(UIColor *)backgroundColor andAnimationDuration:(float)animationTime andVisibleTime:(float)visibleTime {
    self.title.text = title;
    self.subtitle.text = subtitle;

    self.backgroundColor = backgroundColor;
    self.animationTime = animationTime;
    self.visibleTime = visibleTime;

    if (!self.superview) {
        NSEnumerator *windows = [UIApplication sharedApplication].windows.reverseObjectEnumerator;

        for (UIWindow *window in windows)
            if (window.windowLevel == UIWindowLevelNormal) {
                if (!window.hidden) {
                    [window addSubview:self];

                    break;
                }
            }
    }
    [UIView animateWithDuration:self.animationTime animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    }                completion:^(BOOL finished) {
        [self performSelector:@selector(hide:) withObject:self afterDelay:self.animationTime + self.visibleTime];
    }];
}


+ (UIColor *)colorForNotificationStyle:(NotificationStyle)style {
    UIColor *colorToReturn;

    if (style == NotificationStyleInfo) {
        colorToReturn = [UIColor colorWithRed:25 / 255.0f green:118 / 255.0f blue:210 / 255.0f alpha:1.0f];
    } else if (style == NotificationStyleError) {
        colorToReturn = [UIColor colorWithRed:211 / 255.0f green:47 / 255.0f blue:47 / 255.0f alpha:1.0f];
    } else if (style == NotificationStyleSuccess) {
        colorToReturn = [UIColor colorWithRed:76 / 255.0f green:175 / 255.0f blue:80 / 255.0f alpha:1.0f];
    } else if (style == NotificationStyleWarning) {
        colorToReturn = [UIColor colorWithRed:255 / 255.0f green:193 / 255.0f blue:7 / 255.0f alpha:1.0f];
    }
    return colorToReturn;
}

@end
