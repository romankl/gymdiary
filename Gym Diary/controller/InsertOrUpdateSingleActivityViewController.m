//
//  InsertOrUpdateSingleActivityViewController.m
//  Gym Diary
//
//  Created by Roman Klauke on 01.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "InsertOrUpdateSingleActivityViewController.h"
#import "AppDelegate.h"
#import "Activity.h"
#import "DynamicNotification.h"

@interface InsertOrUpdateSingleActivityViewController ()
@property(weak, nonatomic) IBOutlet UITextField *nameTextField;
@property(weak, nonatomic) IBOutlet UITextField *descriptionTextField;

@end

@implementation InsertOrUpdateSingleActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Private
#pragma mark - Actions

- (IBAction)doneWithOperation:(id)sender {
    if (![self isTextFieldEmpty:self.nameTextField]) {
        NSManagedObjectContext *context = ((AppDelegate *) [UIApplication sharedApplication].delegate).managedObjectContext;
        Activity *activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:context];
        activity.name = self.nameTextField.text;
        activity.summary = self.descriptionTextField.text;

        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Error: %@ %@", error.localizedFailureReason, error.localizedDescription);
        } else {
            [self removeFromScreen];
        }
    } else {
        // alert
        [DynamicNotification notificationWithTitle:@"Error" subTitle:@"The name of the activity is required" andNotificationStyle:NotificationStyleError];
    }
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
