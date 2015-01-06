//
//  WorkoutOverViewTableViewController.m
//  Gym Diary
//
//  Created by Roman Klauke on 04.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "WorkoutOverViewTableViewController.h"
#import "Workout.h"
#import "WorkoutCell.h"
#import "InsertOrUpdateWorkoutTableViewController.h"

@interface WorkoutOverViewTableViewController ()

@property(weak, nonatomic) NSManagedObjectContext *context;

@end

@implementation WorkoutOverViewTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Workout"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"active = TRUE"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workoutCell" forIndexPath:indexPath];
    Workout *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = workout.name;
    cell.workout = workout;

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Workout *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSError *error;

        [self.context deleteObject:workout];
        if (![self.context save:&error]) {
            NSLog(@"Error while saving: %@ %@", error.localizedDescription, error.localizedFailureReason);
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWorkout"]) {
        UINavigationController *destinationViewController = segue.destinationViewController;
        if ([sender isKindOfClass:[WorkoutCell class]]) {
            ((InsertOrUpdateWorkoutTableViewController *) destinationViewController.viewControllers.firstObject).workout = ((WorkoutCell *) sender).workout;
        }
    }
}

#pragma mark - private
#pragma mark - Actions

- (IBAction)edit:(id)sender {
    if (self.tableView.editing) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(edit:)];
    }
}

- (NSManagedObjectContext *)context {
    return ((AppDelegate *) [UIApplication sharedApplication].delegate).managedObjectContext;
}

@end
