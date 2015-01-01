//
//  InsertOrUpdateSingleActivityViewController.m
//  Gym Diary
//
//  Created by Roman Klauke on 01.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "InsertOrUpdateSingleActivityViewController.h"

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
    if (![self isTextFieldEmpty:self.descriptionTextField] && ([self isTextFieldEmpty:self.nameTextField])) {

    } else {
        // alert
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
