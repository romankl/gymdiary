//
//  BaseFetchController.h
//  Gym Logger
//
//  Created by Roman Klauke on 20.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreData;
@import UIKit;

@interface BaseFetchController : UITableViewController <NSFetchedResultsControllerDelegate>

@property(strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end