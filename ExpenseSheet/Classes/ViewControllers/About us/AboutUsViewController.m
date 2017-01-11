//
//  AboutUsViewController.m
//  ExpenseSheet
//
//  Created by SISC on 1/1/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "AboutUsViewController.h"
#import "Utilities.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
#pragma mark -
#pragma mark === ViewController Delegate ===
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleView.backgroundColor=[[Utilities shareManager]backgroundColor];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a 
 little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
#pragma mark === Buttons ===
#pragma mark -
- (IBAction)backButtonAction:(id)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark === Status Bar ===
#pragma mark -
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
