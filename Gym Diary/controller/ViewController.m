//
//  ViewController.m
//  Gym Diary
//
//  Created by Roman Klauke on 31.12.14.
//  Copyright (c) 2014 Roman Klauke. All rights reserved.
//


#import "ViewController.h"
#import "DynamicNotification.h"


@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)test:(id)sender {
    [DynamicNotification notificationWithTitle:@"test" subTitle:@"Subtitle" andNotificationStyle:NotificationStyleInfo];
}

@end
