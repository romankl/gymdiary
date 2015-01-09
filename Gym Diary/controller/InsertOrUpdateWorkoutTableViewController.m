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

@interface InsertOrUpdateWorkoutTableViewController ()

@property(weak, nonatomic) IBOutlet UITextField *nameTextField;
@property(weak, nonatomic) IBOutlet UITextField *summaryTextField;

@end

@implementation InsertOrUpdateWorkoutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.workout) {
        self.summaryTextField.text = self.workout.summary;
        self.nameTextField.text = self.workout.name;
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

        NSError *error;
        if (![managedObjectContext save:&error]) {
            DDLogError(@"Error while saving: %@ %@", error.localizedDescription, error.localizedFailureReason);
        } else {
            [self dismiss];
        }
    } else {
        [DynamicNotification notificationWithTitle:@"Error" subTitle:@"The name of the workout is required" andNotificationStyle:NotificationStyleError];
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
}

- (NSManagedObjectContext *)context {
    return self.workout ? self.workout.managedObjectContext : ((AppDelegate *) [UIApplication sharedApplication].delegate).managedObjectContext;
}

@end
