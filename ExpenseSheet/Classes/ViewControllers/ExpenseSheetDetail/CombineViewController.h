//
//  CombineViewController.h
//  ExpenseSheet
//
//  Created by SISC on 1/1/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CombineViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UITableView *combineViewTable;
@property (weak, nonatomic) IBOutlet UIView *pickerBackView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *pickerviewTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *pickerViewDoneButton;
@property (weak, nonatomic) IBOutlet UIButton *pickerViewCancelButton;

@property NSString *existingCustomer;
@property NSString *existingProject;

@property NSString *selectedCustomer;
@property NSString *selectedProject;

@end
