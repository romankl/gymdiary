//
//  SetAndRepsInputRow.m
//  Gym Diary
//
//  Created by Roman Klauke on 09.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "SetAndRepsInputRow.h"
#import "UIView+LayoutHelper.h"

@implementation SetAndRepsInputRow
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.repsTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 40, self.frame.size.height)];
        self.repsTextField.placeholder = @"Reps";
        self.repsTextField.borderStyle = UITextBorderStyleRoundedRect;

        [self.repsTextField showBorderOfViewWithColor:[UIColor orangeColor]];

        [self addSubview:self.repsTextField];

        self.setsTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.repsTextField.frame.size.width, 0, 40, self.frame.size.height)];
        self.setsTextField.placeholder = @"Sets";
        self.setsTextField.borderStyle = UITextBorderStyleRoundedRect;

        [self addSubview:self.setsTextField];
        [self.setsTextField showBorderOfViewWithColor:[UIColor cyanColor]];
    }

    return self;
}

@end
