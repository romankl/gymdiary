//
//  InsertOrUpdateSingleActivityViewController.m
//  Gym Diary
//
//  Created by Roman Klauke on 01.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "InsertOrUpdateSingleActivityViewController.h"
#import "AppDelegate.h"
#import "DynamicNotification.h"
#import "UITextField+TextHelper.h"
#import "DDLog.h"
#import "defines.h"

@interface InsertOrUpdateSingleActivityViewController ()

@property(weak, nonatomic) IBOutlet UITextField *nameTextField;
@property(weak, nonatomic) IBOutlet UITextField *descriptionTextField;

@end

@implementation InsertOrUpdateSingleActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.activityToView) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    } else {
        self.nameTextField.text = self.activityToView.name;
        self.descriptionTextField.text = self.activityToView.summary;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Private
#pragma mark - Actions

- (IBAction)doneWithOperation:(id)sender {
    if (![self.nameTextField isEmpty]) {
        if (!self.activityToView) {
            [self insertNewActivity];
        } else {
            [self updateActivity];
        }

    } else {
        // alert
        [DynamicNotification notificationWithTitle:@"Error" subTitle:@"The name of the activity is required" andNotificationStyle:NotificationStyleError];
    }
}

- (void)updateActivity {
    self.activityToView.name = self.nameTextField.text;
    self.activityToView.summary = self.descriptionTextField.text;

    NSManagedObjectContext *context = [self getContext];
    NSError *error;
    if (![context save:&error]) {
        DDLogError(@"Error while saving: %@ %@", error.localizedDescription, error.localizedFailureReason);
    };
    [DynamicNotification notificationWithTitle:@"Success" subTitle:@"Updated the object with success" withDuration:NotificationNormal andNotificationStyle:NotificationStyleSuccess];
}

- (void)insertNewActivity {
    NSManagedObjectContext *context = [self getContext];
    Activity *activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:context];
    activity.name = self.nameTextField.text;
    activity.summary = self.descriptionTextField.text;

    NSError *error;
    if (![context save:&error]) {
        DDLogError(@"Error: %@ %@", error.localizedFailureReason, error.localizedDescription);
    } else {
        [self removeFromScreen];
    }
}

- (NSManagedObjectContext *)getContext {
    return self.activityToView ? self.activityToView.managedObjectContext : ((AppDelegate *) [UIApplication sharedApplication].delegate).managedObjectContext;
}

- (IBAction)cancel:(id)sender {
    [self removeFromScreen];
}

- (void)removeFromScreen {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
