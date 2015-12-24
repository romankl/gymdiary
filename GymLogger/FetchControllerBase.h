//
// Created by Roman Klauke on 24.12.15.
// Copyright (c) 2015 Roman Klauke. All rights reserved.

#import <Foundation/Foundation.h>

@import CoreData;
@import UIKit;

@interface FetchControllerBase : UITableViewController <NSFetchedResultsControllerDelegate>

@property(strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
