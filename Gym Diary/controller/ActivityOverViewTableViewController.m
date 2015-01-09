//
//  ActivityOverViewTableViewController.m
//  Gym Diary
//
//  Created by Roman Klauke on 31.12.14.
//  Copyright (c) 2014 Roman Klauke. All rights reserved.
//

#import <CocoaLumberjack/DDLog.h>
#import "ActivityOverViewTableViewController.h"
#import "AppDelegate.h"
#import "Activity.h"
#import "InsertOrUpdateSingleActivityViewController.h"
#import "ActivityCell.h"
#import "defines.h"

@interface ActivityOverViewTableViewController ()

@property(weak, nonatomic) NSManagedObjectContext *context;

@end

@implementation ActivityOverViewTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Activity"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"active = TRUE"];

    NSManagedObjectContext *context = ((AppDelegate *) [UIApplication sharedApplication].delegate).managedObjectContext;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma mark - Private
#pragma mark - Actions

- (IBAction)addNewActivity:(id)sender {
}

- (IBAction)edit:(id)sender {
    if (!self.tableView.editing) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(edit:)];
        [self.tableView setEditing:YES animated:YES];
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
        [self.tableView setEditing:NO animated:YES];
    }
}

#pragma mark - UITableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    Activity *activity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = activity.name;
    cell.activity = activity;

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Activity *activity = [self.fetchedResultsController objectAtIndexPath:indexPath];
        activity.active = @NO;
        NSError *error;
        if (![self.context save:&error]) {
            DDLogError(@"Error while saving : %@ %@ ", error.localizedFailureReason, error.localizedDescription);
        }

        [self.tableView reloadData];
    }
}

#pragma mark - Getter / Setter

- (NSManagedObjectContext *)context {
    return ((AppDelegate *) [UIApplication sharedApplication].delegate).managedObjectContext;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showActivity"]) {
        UINavigationController *destinationViewController = segue.destinationViewController;
        if ([sender isKindOfClass:[ActivityCell class]]) {
            ((InsertOrUpdateSingleActivityViewController *) destinationViewController.viewControllers.firstObject).activityToView = ((ActivityCell *) sender).activity;
        }
    } else if ([segue.identifier isEqualToString:@"addActivity"]) {

    }
}


@end
