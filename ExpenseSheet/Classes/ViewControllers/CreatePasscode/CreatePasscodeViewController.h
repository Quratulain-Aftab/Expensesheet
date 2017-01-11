//
//  CreatePasscodeViewController.h
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/22/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePasscodeViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *conifrmPasscodeTextfield;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *useTouchIDButton;

@end
