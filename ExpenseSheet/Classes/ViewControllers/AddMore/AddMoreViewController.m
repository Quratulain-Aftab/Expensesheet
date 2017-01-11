//
//  AddMoreViewController.m
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 12/9/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import "AddMoreViewController.h"

@interface AddMoreViewController ()

@end

@implementation AddMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleView.backgroundColor=[UIColor colorWithRed:48.0/255.0 green:111.0/255.0 blue:183.0/255.0 alpha:1.0];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Status Bar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
