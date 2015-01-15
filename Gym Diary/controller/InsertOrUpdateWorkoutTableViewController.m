//
//  InsertOrUpdateWorkoutTableViewController.m
//  Gym Diary
//
//  Created by Roman Klauke on 05.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <CocoaLumberjack/DDLog.h>
#import "InsertOrUpdateWorkoutTableViewController.h"
#import "UITextField+TextHelper.h"
#import "DynamicNotification.h"
#import "AppDelegate.h"
#import "defines.h"
#import "Activity.h"
#import "ActivityPickerController.h"
#import "ActivityWorkoutMap.h"


@interface InsertOrUpdateWorkoutTableViewController ()

@property(strong, nonatomic) IBOutlet UITextField *nameTextField;
@property(strong, nonatomic) IBOutlet UITextField *summaryTextField;
@property(strong, nonatomic) NSMutableArray *items;

@property(weak, nonatomic) NSString *cellIdentifier;

@end

@implementation InsertOrUpdateWorkoutTableViewController

- (void)addActivity {
    [self performSegueWithIdentifier:@"addActivity" sender:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.workout) {
        self.summaryTextField.text = self.workout.summary;
        self.nameTextField.text = self.workout.name;
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(cancel:)];
    }

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    [button setTitle:@"Add activity" forState:UIControlStateNormal];

    [button addTarget:self action:@selector(addActivity) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = button;

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];

    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
    self.nameTextField.placeholder = @"Name";
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;

    [header addSubview:self.nameTextField];

    self.summaryTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,
            self.nameTextField.frame.size.height + 5,
            self.view.frame.size.width,
            25)];
    self.summaryTextField.placeholder = @"Summary";
    self.summaryTextField.borderStyle = UITextBorderStyleRoundedRect;

    [header addSubview:self.summaryTextField];

    self.tableView.tableHeaderView = header;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addActivity"]) {
        ((ActivityPickerController *) ((UINavigationController *) segue.destinationViewController).topViewController)
                .choseActivity = ^(Activity *chosenActivity) {
            // TODO: Add animation?
            [self.tableView reloadData];
            [self.items addObject:chosenActivity];
        };
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = ((Activity *) self.items[(NSUInteger) indexPath.row]).name;

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}


#pragma mark - Actions

- (IBAction)cancel:(id)sender {
    [self dismiss];
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    if (![self.nameTextField isEmpty]) {
        NSManagedObjectContext *managedObjectContext = [self context];
        if (!self.workout) {
            [self prepareForInsertion:managedObjectContext];
        } else {
            [self prepareForUpdate];
        }

        [self saveObjects:managedObjectContext];
        [self dismiss];
    } else {
        [DynamicNotification notificationWithTitle:@"Error"
                                          subTitle:@"The name of the workout is required"
                              andNotificationStyle:NotificationStyleError];
    }
}

- (void)saveObjects:(NSManagedObjectContext *)managedObjectContext {
    NSError *error;
    if (![managedObjectContext save:&error]) {
        DDLogError(@"Error while saving: %@ %@", error.localizedDescription, error.localizedFailureReason);
    }
}

- (void)prepareForUpdate {
    self.workout.updatedAt = [NSDate date];
    self.workout.name = self.nameTextField.text;
    self.workout.summary = self.summaryTextField.text;
}

- (void)prepareForInsertion:(NSManagedObjectContext *)managedObjectContext {
    Workout *workout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext:managedObjectContext];
    workout.name = self.nameTextField.text;
    workout.summary = self.summaryTextField.text;

    workout.createdAt = [NSDate date];

    for (Activity *activity in self.items) {
        ActivityWorkoutMap *map = [NSEntityDescription insertNewObjectForEntityForName:@"ActivityWorkoutMap"
                                                                inManagedObjectContext:managedObjectContext];
        map.inWorkout = workout;
        map.usesActitivity = activity;

        [workout addShouldUseObject:map];

        [self saveObjects:managedObjectContext];
    }
}

#pragma mark - Getter / setter

- (NSManagedObjectContext *)context {
    return self.workout ? self.workout.managedObjectContext : ((AppDelegate *) [UIApplication sharedApplication].delegate).managedObjectContext;
}

- (NSString *)cellIdentifier {
    if (!_cellIdentifier) _cellIdentifier = @"workoutCell";
    return _cellIdentifier;
}

- (NSMutableArray *)items {
    if (!_items) _items = [[NSMutableArray alloc] init];
    return _items;
}

@end
