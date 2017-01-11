//
//  LoginViewController.h
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/17/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (strong, nonatomic) IBOutlet UIView *EnterPasscodeView;
@property (weak, nonatomic) IBOutlet UITextField *passcodeField;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasscodeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginviewTop;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
