//
//  DynamicNotification.m
//  Gym Diary
//
//  Created by Roman Klauke on 01.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "DynamicNotification.h"
#import "POP.h"

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
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.velocity = @(10);
    springAnimation.springBounciness = 4;
    springAnimation.springSpeed = 8;
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    springAnimation.toValue = @(-80);
    springAnimation.name = @"dismiss";
    springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {

        [self removeFromSuperview];
    };

    [self pop_addAnimation:springAnimation forKey:@"dismiss"];
}

+ (void)notificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle andNotificationStyle:(NotificationStyle)style {
    DynamicNotification *notification = [self DynamicNotification];
    [notification showNotificationWithTitle:title subTitle:subtitle withColor:[self colorForNotificationStyle:style] andAnimationDuration:.5 andVisibleTime:3];
}

+ (void)notificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle withDuration:(NotificationDuration)duration andNotificationStyle:(NotificationStyle)style {
    DynamicNotification *notification = [self DynamicNotification];
    [notification showNotificationWithTitle:title subTitle:subtitle withColor:[self colorForNotificationStyle:style] andAnimationDuration:.5 andVisibleTime:(float) duration];
}

+ (void)notificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle withDuration:(NotificationDuration)duration andAnimationDuration:(NotificationDuration)animationDuration andNotificationStyle:(NotificationStyle)style {
    DynamicNotification *notification = [self DynamicNotification];
    [notification showNotificationWithTitle:title subTitle:subtitle withColor:[self colorForNotificationStyle:style] andAnimationDuration:animationDuration andVisibleTime:duration];
}

+ (void)notificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle withCustomDuration:(float)duration andCustomAnimationDuration:(float)animationDuration andNotificationStyle:(NotificationStyle)style {
    DynamicNotification *notification = [self DynamicNotification];
    [notification showNotificationWithTitle:title subTitle:subtitle withColor:[self colorForNotificationStyle:style] andAnimationDuration:animationDuration andVisibleTime:duration];
}

+ (void)notificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle withCustomDuration:(float)duration andNotificationStyle:(NotificationStyle)style {
    DynamicNotification *notification = [self DynamicNotification];
    [notification showNotificationWithTitle:title subTitle:subtitle withColor:[self colorForNotificationStyle:style] andAnimationDuration:(float) NotificationNormal andVisibleTime:duration];
}

+ (DynamicNotification *)DynamicNotification {
    return [[DynamicNotification alloc] initWithFrame:CGRectMake(0, -85, [UIScreen mainScreen].bounds.size.width, 85)];
}


- (void)showNotificationWithTitle:(NSString *)title subTitle:(NSString *)subtitle withColor:(UIColor *)backgroundColor andAnimationDuration:(float)animationTime andVisibleTime:(float)visibleTime {
    self.title.text = title;
    self.subtitle.text = subtitle;

    self.backgroundColor = backgroundColor;
    self.animationTime = animationTime;
    self.visibleTime = visibleTime;

    UIWindow *window;
    if (!self.superview) {
        NSEnumerator *windows = [UIApplication sharedApplication].windows.reverseObjectEnumerator;
        for (window in windows)
            if (window.windowLevel == UIWindowLevelNormal) {
                if (!window.hidden) {
                    [window addSubview:self];

                    break;
                }
            }
    }

    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.velocity = @(10);
    springAnimation.springBounciness = 10;
    springAnimation.springSpeed = 8;
    springAnimation.name = @"dropdown";
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    springAnimation.toValue = @(40);

    [self pop_addAnimation:springAnimation forKey:@"dropdown"];
    [self performSelector:@selector(hide:) withObject:self afterDelay:self.visibleTime];
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
