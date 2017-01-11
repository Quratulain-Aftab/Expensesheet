//
//  LoginViewController.m
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/17/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import "LoginViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "Utilities.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.emailTextfield.delegate=self;
    self.passwordTextfield.delegate=self;
    self.passcodeField.delegate=self;
    
    
    self.passcodeField.keyboardType=UIKeyboardTypeNumberPad;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"Passcode"])
    {
        [self.passcodeField becomeFirstResponder];
    }
    else
    {
           [self.emailTextfield becomeFirstResponder];
    }
   
    
    self.loginButton.layer.cornerRadius=10.0;
  //  self.loginButton .backgroundColor=[UIColor colorWithRed:48.0/2555.0 green:111.0/255.0 blue:183.0/255.0 alpha:1.0];
    self.loginButton.backgroundColor=[[Utilities shareManager]backgroundColor];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view.
    
    
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"useTouchID"]==YES)
    {
        [self.emailTextfield resignFirstResponder];
        
        [self showLocalAuthenticationAlert];
    }
    else
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"Passcode"])
    {
        self.EnterPasscodeView.frame=self.view.frame;
        [self.view addSubview:self.EnterPasscodeView];
        
    }
 }
-(void)viewWillLayoutSubviews
{
   // [super viewWillLayoutSubviews];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone &&self.view.frame.size.width==320)
    {
    if([self.emailTextfield isFirstResponder]|| [self.passwordTextfield isFirstResponder])
    {
    self.loginviewTop.constant=20;
    }
   else
    {
        self.loginviewTop.constant=150;
    }
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Gesture Handler
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
 //   CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    [self.emailTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
    //Do stuff here...
}

#pragma mark - Buttons Action
- (IBAction)goButtonAction:(id)sender {
    
    [self performSegueWithIdentifier:@"homesegue" sender:nil];
    
}
- (IBAction)forgotButtonAction:(id)sender {
    
    [self.EnterPasscodeView setHidden:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)LoginButtonAction:(id)sender {
    
    
    [self performSegueWithIdentifier:@"craetepasscodesegue" sender:nil];
}
#pragma mark - Status Bar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - Local Authentication
-(void)showLocalAuthenticationAlert
{
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        NSString *myLocalizedReasonString = @"Authentication is required to access your expense sheets list";
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                      localizedReason:myLocalizedReasonString
                                reply:^(BOOL success, NSError *error) {
                                    if (success) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          //  [self performSegueWithIdentifier:@"Success" sender:nil];
                                            NSLog(@"success");
                                            [self performSegueWithIdentifier:@"homesegue" sender:nil];

                                        });
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                message:error.description
                                                                                               delegate:self
                                                                                      cancelButtonTitle:@"OK"
                                                                                      otherButtonTitles:nil, nil];
                                            [alertView show];
                                            // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
                                        });
                                    }
                                }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:authError.description
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
                // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
            });
        }
}
#pragma mark - UITextfield Delegate
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
        //This'll Show The cancelButton with Animation
    
    self.loginviewTop.constant=20;
    return YES;
}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
        self.loginviewTop.constant=200;
    //This'll Show The cancelButton with Animation
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(bool)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==self.passcodeField)
    {
        if(textField.text.length==3)
        {
             [self performSegueWithIdentifier:@"homesegue" sender:nil];
        }
    }
    return YES;
}
@end
