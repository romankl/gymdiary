//
//  ActivityOverViewTableViewController.m
//  Gym Diary
//
//  Created by Roman Klauke on 31.12.14.
//  Copyright (c) 2014 Roman Klauke. All rights reserved.
//

#import "ActivityOverViewTableViewController.h"
#import "AppDelegate.h"

@interface ActivityOverViewTableViewController ()

@end

@implementation ActivityOverViewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Activity"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];

    NSManagedObjectContext *context = ((AppDelegate *) [UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchedResultsController *fetchedResultsController1 = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:context
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
