//
//  ActivityCell.h
//  Gym Diary
//
//  Created by Roman Klauke on 04.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface ActivityCell : UITableViewCell

@property(weak, nonatomic) Activity *activity;

@end
