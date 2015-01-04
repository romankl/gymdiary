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
    if (![self isTextFieldEmpty:self.nameTextField]) {
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
        NSLog(@"Error while saving: %@ %@", error.localizedDescription, error.localizedFailureReason);
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
        NSLog(@"Error: %@ %@", error.localizedFailureReason, error.localizedDescription);
    } else {
        [self removeFromScreen];
    }
}

- (NSManagedObjectContext *)getContext {
    NSManagedObjectContext *context = ((AppDelegate *) [UIApplication sharedApplication].delegate).managedObjectContext;
    return context;
}

- (IBAction)cancel:(id)sender {
    [self removeFromScreen];
}

- (BOOL)isTextFieldEmpty:(UITextField *)textfield {
    return textfield.text.length == 0;
}

- (void)removeFromScreen {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
