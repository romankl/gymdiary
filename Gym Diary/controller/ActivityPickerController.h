//
//  ActivityPickerController.h
//  Gym Diary
//
//  Created by Roman Klauke on 11.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "ActivityOverViewTableViewController.h"
#import "Activity.h"

@interface ActivityPickerController : ActivityOverViewTableViewController

@property(nonatomic, copy) void (^choseActivity)(Activity *chosenActivity);

@end
