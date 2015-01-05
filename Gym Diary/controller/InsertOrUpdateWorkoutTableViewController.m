//
//  InsertOrUpdateWorkoutTableViewController.m
//  Gym Diary
//
//  Created by Roman Klauke on 05.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "InsertOrUpdateWorkoutTableViewController.h"
#import "UITextField+TextHelper.h"
#import "DynamicNotification.h"
#import "Workout.h"
#import "AppDelegate.h"

@interface InsertOrUpdateWorkoutTableViewController ()

@property(weak, nonatomic) IBOutlet UITextField *nameTextField;
@property(weak, nonatomic) IBOutlet UITextField *summaryTextField;

@end

@implementation InsertOrUpdateWorkoutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        Workout *workout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext:managedObjectContext];
        workout.name = self.nameTextField.text;
        workout.summary = self.summaryTextField.text;

        workout.createdAt = [NSDate date];

        NSError *error;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Error while saving: %@ %@", error.localizedDescription, error.localizedFailureReason);
        } else {
            [self dismiss];
        }
    } else {
        [DynamicNotification notificationWithTitle:@"Error" subTitle:@"The name of the workout is required" andNotificationStyle:NotificationStyleError];
    }
}

- (NSManagedObjectContext *)context {
    return ((AppDelegate *) [UIApplication sharedApplication].delegate).managedObjectContext;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
