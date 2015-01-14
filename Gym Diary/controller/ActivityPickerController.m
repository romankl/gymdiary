//
//  ActivityPickerController.m
//  Gym Diary
//
//  Created by Roman Klauke on 11.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "ActivityPickerController.h"

@implementation ActivityPickerController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.choseActivity([self.fetchedResultsController objectAtIndexPath:indexPath]);
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
