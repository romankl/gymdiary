//
//  WorkoutOverViewTableViewController.m
//  Gym Diary
//
//  Created by Roman Klauke on 04.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "WorkoutOverViewTableViewController.h"
#import "Workout.h"

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workoutCell" forIndexPath:indexPath];
    Workout *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = workout.name;

    return cell;
}


#pragma mark - private

- (NSManagedObjectContext *)context {
    return ((AppDelegate *) [UIApplication sharedApplication].delegate).managedObjectContext;
}


@end
