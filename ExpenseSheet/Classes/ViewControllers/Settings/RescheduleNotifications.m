//
//  RescheduleNotifications.m
//  ExpenseSheet
//
//  Created by Quratulain on 1/11/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "RescheduleNotifications.h"
#import "Constants.h"
#import "Utilities.h"
#import "UIButton+button.h"

@interface RescheduleNotifications ()

@end

@implementation RescheduleNotifications
{
    NSArray *weekDaysDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeUIAdjustments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)makeUIAdjustments
{
    self.titleView.backgroundColor=[[Utilities shareManager]backgroundColor];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
    
    self.closeButton.hitTestEdgeInsets=UIEdgeInsetsMake(-5, -5, -5, -10);
    
   
    weekDaysDataSource=[NSArray arrayWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];
    self.weekDaysTable.delegate=self;
    self.weekDaysTable.dataSource=self;
    self.weekDaysTable.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WeekDayCell" forIndexPath:indexPath];
    
    cell.textLabel.text=[weekDaysDataSource objectAtIndex:indexPath.row];
    
    if ([[weekDaysDataSource objectAtIndex:indexPath.row] isEqualToString:[[Utilities shareManager]getUpdatedSettingsForString:WeekStartDay]])
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView=nil;
    }

      UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
    selectedBackgorundView.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
    cell.selectedBackgroundView=selectedBackgorundView;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return weekDaysDataSource.count;
}


@end
