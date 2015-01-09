//
//  ActivityCard.m
//  Gym Diary
//
//  Created by Roman Klauke on 09.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "ActivityCard.h"

@interface ActivityCard ()

@property(weak, nonatomic) IBOutlet UILabel *activityLabel;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ActivityCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *subViews = [[NSBundle mainBundle] loadNibNamed:@"ActivityCard" owner:self options:nil];
        UIView *mainView = subViews[0];

        [self addSubview:mainView];
    }

    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
