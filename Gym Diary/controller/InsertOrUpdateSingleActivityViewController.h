//
//  InsertOrUpdateSingleActivityViewController.h
//  Gym Diary
//
//  Created by Roman Klauke on 01.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
#import "Activity+ObjectOperations.h"

@import CoreData;

@interface InsertOrUpdateSingleActivityViewController : UITableViewController

@property(strong, nonatomic) Activity *activityToView;

@end
