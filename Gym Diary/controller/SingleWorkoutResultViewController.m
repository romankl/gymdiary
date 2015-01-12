//
//  SingleWorkoutResultViewController.m
//  Gym Diary
//
//  Created by Roman Klauke on 08.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "SingleWorkoutResultViewController.h"
#import "ActivityCard.h"

static const int kCardHeight = 135;

static const int kCardSpacing = 16;

@interface SingleWorkoutResultViewController ()

@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SingleWorkoutResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Add activity" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addActivity:)];
    [button addGestureRecognizer:tapGestureRecognizer];
    [self.scrollView addSubview:button];

    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 20);
}

- (void)addActivity:(id)addActivity {
    ActivityCard *card = [[ActivityCard alloc] initWithFrame:CGRectMake(0, self.scrollView.contentSize.height, self.view.frame.size.width, kCardHeight)];
    card.layer.borderColor = [UIColor redColor].CGColor;
    card.layer.borderWidth = 1.f;

    [self.scrollView addSubview:card];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.scrollView.contentSize.height + card.frame.size.height + kCardSpacing);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
