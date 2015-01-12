//
//  ActivityCard.m
//  Gym Diary
//
//  Created by Roman Klauke on 09.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <CocoaLumberjack/DDLog.h>
#import "ActivityCard.h"
#import "View+MASAdditions.h"
#import "defines.h"
#import "SetAndRepsInputRow.h"
#import "UIView+LayoutHelper.h"

static const int kInputRowSpacing = 2;

@interface ActivityCard ()

@property(strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ActivityCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, self.frame.size.width, 25)];
        self.activityLabel.numberOfLines = 1;
        self.activityLabel.textAlignment = NSTextAlignmentLeft;
        self.activityLabel.textColor = [UIColor blackColor];
        self.activityLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18];
        self.activityLabel.text = @"Test";
        [self addSubview:self.activityLabel];

        [self.activityLabel showBorderOfViewWithColor:[UIColor blueColor]];

        [self addSubview:self.activityLabel];
        [self addSubview:self.scrollView];

        int padding = 10;

        [self.activityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(padding);
            make.left.equalTo(self.mas_left).offset(padding);
            make.right.equalTo(self.mas_right).offset(-padding);
        }];

        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.activityLabel.mas_bottom).offset(padding);
            make.left.equalTo(self.mas_left).offset(padding);
            make.bottom.equalTo(self.mas_bottom).offset(-padding);
            make.right.equalTo(self.mas_right).offset(-padding);
        }];

        DDLogInfo(@"View created");
        [self initScrollView];
    }

    return self;
}

- (void)initScrollView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, 20);
    [button setTitle:@"Add sets/ reps" forState:UIControlStateNormal];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addRepsSets:)];
    [button addGestureRecognizer:tapGestureRecognizer];
    [self.scrollView addSubview:button];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, button.frame.size.height);

    [button showBorderOfViewWithColor:[UIColor purpleColor]];
}

- (void)addRepsSets:(id)addRepsSets {
    SetAndRepsInputRow *inputRow = [[SetAndRepsInputRow alloc] initWithFrame:CGRectMake(0, self.scrollView.contentSize.height + kInputRowSpacing, self.scrollView.bounds.size.width, 25)];

    [self.scrollView addSubview:inputRow];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.contentSize.height + inputRow.frame.size.height);
    [self.rows addObject:inputRow];

    [inputRow showBorderOfViewWithColor:[UIColor brownColor]];

    DDLogInfo(@"Reps/Sets added at position: %f", inputRow.frame.origin.y);
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 25, self.frame.size.width, self.frame.size.height)];
        [_scrollView showBorderOfViewWithColor:[UIColor greenColor]];
    }
    return _scrollView;
}

@end
