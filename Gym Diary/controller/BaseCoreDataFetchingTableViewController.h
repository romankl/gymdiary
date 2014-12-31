//
//  BaseCoreDataFetchingTableViewController.h
//  Gym Diary
//
//  Created by Roman Klauke on 31.12.14.
//  Copyright (c) 2014 Roman Klauke. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreData;

@interface BaseCoreDataFetchingTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property(strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
