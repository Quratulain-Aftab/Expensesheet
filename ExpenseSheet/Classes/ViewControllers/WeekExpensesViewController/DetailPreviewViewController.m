//
//  DetailPreviewViewController.m
//  ExpenseSheet
//
//  Created by SISC on 1/3/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "DetailPreviewViewController.h"
#import "Utilities.h"
#import "Constants.h"

@interface DetailPreviewViewController ()

@end

@implementation DetailPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.topItem.title=@"Expense Detail";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [[Utilities shareManager] backgroundColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    
    if([self.expenseDetail valueForKey:CustomerName])
    {
    self.customerTextLabel.text=[self.expenseDetail valueForKey:CustomerName];
    }
    if([self.expenseDetail valueForKey:ProjectName])
    {
    self.projectTextLabel.text=[self.expenseDetail valueForKey:ProjectName];
    }
    if([self.expenseDetail valueForKey:ExpenseType])
    {
    self.expenseTypeTextLabel.text=[self.expenseDetail valueForKey:ExpenseType];
    }
    if([self.expenseDetail valueForKey:BillType])
    {
    self.billTypeTextLabel.text=[self.expenseDetail valueForKey:BillType];
    }
    if([self.expenseDetail valueForKey:Amount])
    {
    self.amountTextLabel.text=[NSString stringWithFormat:@"%@",[self.expenseDetail valueForKey:Amount]];
    }
    if([self.expenseDetail valueForKey:DetailDescription])
    {
    self.descriptionTextLabel.text=[self.expenseDetail valueForKey:DetailDescription];
    }
    if([self.expenseDetail valueForKey:ReImburse])
    {
    self.ReImburseTextLabel.text=@"Yes";
    }
    
    
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
