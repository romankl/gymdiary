//
//  ActivityCard.h
//  Gym Diary
//
//  Created by Roman Klauke on 09.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCard : UIView

@property(strong, nonatomic) UILabel *activityLabel;
@property(strong, nonatomic) NSMutableArray *rows;  // of SetAndRepInputRows

@end
