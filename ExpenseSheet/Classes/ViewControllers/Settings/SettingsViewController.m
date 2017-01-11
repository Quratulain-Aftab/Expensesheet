//
//  SettingsViewController.m
//  ExpenseSheet
//
//  Created by SISC on 1/1/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "SettingsViewController.h"
#import "Utilities.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleView.backgroundColor=[[Utilities shareManager]backgroundColor];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
    
    self.settingsTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.settingsTable.bounds.size.width, 0.01f)];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *cellIdentifier=[NSString stringWithFormat:@"SettingsCell%d",(int)indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
    selectedBackgorundView.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
    cell.selectedBackgroundView=selectedBackgorundView;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 8;
}

@end
