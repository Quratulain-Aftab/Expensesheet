//
//  CreatePasscodeViewController.m
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/22/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import "CreatePasscodeViewController.h"
#import "Utilities.h"

@interface CreatePasscodeViewController ()

@end

@implementation CreatePasscodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleView.backgroundColor=[[Utilities shareManager] backgroundColor];
    self.doneButton.backgroundColor=[[Utilities shareManager] backgroundColor];
    self.useTouchIDButton.backgroundColor=[[Utilities shareManager] backgroundColor];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
    self.doneButton.layer.cornerRadius=5.0;
     self.useTouchIDButton.layer.cornerRadius=5.0;
    
    self.passcodeTextfield.keyboardType=UIKeyboardTypeNumberPad;
    self.conifrmPasscodeTextfield.keyboardType=UIKeyboardTypeNumberPad;
    
  //  [self.passcodeTextfield becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneButtonAction:(id)sender {
    
  //  [[NSUserDefaults standardUserDefaults] setObject:@"1234" forKey:@"Passcode"];
    [[NSUserDefaults standardUserDefaults] setObject:self.passcodeTextfield.text forKey:@"Passcode"];
    [self performSegueWithIdentifier:@"homesegue" sender:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)useTouhIDButtonAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useTouchID"];
      [self performSegueWithIdentifier:@"homesegue" sender:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
