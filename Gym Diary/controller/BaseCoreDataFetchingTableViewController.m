//
//  BaseCoreDataFetchingTableViewController.m
//  Gym Diary
//
//  Created by Roman Klauke on 31.12.14.
//  Copyright (c) 2014 Roman Klauke. All rights reserved.
//

#import "BaseCoreDataFetchingTableViewController.h"

@interface BaseCoreDataFetchingTableViewController ()

@end

@implementation BaseCoreDataFetchingTableViewController

- (void)performFetch {
    if (self.fetchedResultsController) {
        NSError *error;
        if (![self.fetchedResultsController performFetch:&error]) {
            NSLog(@"Error:%@ %@", error.localizedDescription, error.localizedFailureReason);
        }
    }
    [self.tableView reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
    NSFetchedResultsController *oldController = _fetchedResultsController;
    if (fetchedResultsController != oldController) {
        _fetchedResultsController = fetchedResultsController;
        fetchedResultsController.delegate = self;
        if ([self.title isEqualToString:oldController.fetchRequest.entity.name]) {
            if (!self.navigationController || !self.navigationItem.title) {
                self.title = fetchedResultsController.fetchRequest.entity.name;
            }
        }
        else {
            if (!self.navigationController || !self.navigationItem.title) {
                if (!self.title) {
                    self.title = fetchedResultsController.fetchRequest.entity.name;
                }
            }
        }

        if (fetchedResultsController) {
            [self performFetch];
        } else {
            [self.tableView reloadData];
        }
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = [[self.fetchedResultsController sections] count];
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.fetchedResultsController sections][(NSUInteger) section] name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][(NSUInteger) section];
        rows = [sectionInfo numberOfObjects];
    }
    return rows;
}


@end
