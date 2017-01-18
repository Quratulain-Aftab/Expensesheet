//
//  CombineViewController.m
//  ExpenseSheet
//
//  Created by SISC on 1/1/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "CombineViewController.h"
#import "Utilities.h"
#import "UIButton+button.h"
#import "CombineViewCell.h"
@interface CombineViewController ()

@end

@implementation CombineViewController
{
    NSMutableArray *dataSource;
    NSMutableArray *_pickerDataSource;
    NSArray *customersArray;
    NSMutableArray *projectsArray;
    
    BOOL shouldShowThirdCell;
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
#pragma mark -
#pragma mark === Configuring View ===
#pragma mark -
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
    
    self.combineViewTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.combineViewTable.bounds.size.width, 0.01f)];
    self.combineViewTable.dataSource=self;
    self.combineViewTable.delegate=self;
    
    dataSource=[[NSMutableArray alloc]initWithObjects:@"Apple,Expense Sheet",@"Add New", nil];
    
    self.pickerView.dataSource=self;
    self.pickerView.delegate=self;
    
    customersArray=[[NSArray alloc]initWithObjects:@"Apple",@"Samsung",@"Nokia",@"Qmobile", nil];
    projectsArray=[[NSMutableArray alloc]initWithObjects:@"iPhone",@"Galaxy J5",@"Nokia Lumia",@"Noir A 500", nil];
    
    self.pickerViewDoneButton.hitTestEdgeInsets=UIEdgeInsetsMake(-5, -20, -5, -5);
    self.pickerViewCancelButton.hitTestEdgeInsets=UIEdgeInsetsMake(-5, -5, -5, -20);
    

    _pickerDataSource=[[NSMutableArray alloc]initWithArray:customersArray];
    
    
  }
#pragma mark -
#pragma mark === Buttons Action ===
#pragma mark -
- (IBAction)backButtonAction:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)pickerViewCancelButtonAction:(id)sender {
    
    [self.pickerBackView setHidden:YES];
}
- (IBAction)pickerViewDoneButtonAction:(id)sender {
    if([self.pickerviewTitleLabel.text isEqualToString:@"Select Customer"])
    {
       NSInteger  row = [self.pickerView selectedRowInComponent:0];
        self.selectedCustomer=[_pickerDataSource objectAtIndex:row];
        
        self.pickerviewTitleLabel.text=@"Select Project";
        [self.pickerViewDoneButton setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        [_pickerDataSource removeAllObjects];
        [_pickerDataSource addObjectsFromArray:projectsArray];
        [_pickerView reloadAllComponents];
    }
    else
    {
        [self.pickerBackView setHidden:YES];
        NSInteger  row = [self.pickerView selectedRowInComponent:0];
        self.selectedProject=[_pickerDataSource objectAtIndex:row];

        
        self.pickerviewTitleLabel.text=@"Select Customer";
        [self.pickerViewDoneButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [_pickerDataSource removeAllObjects];
        [_pickerDataSource addObjectsFromArray:customersArray];
        [_pickerView reloadAllComponents];

        UITableViewCell *cell1=  [self.combineViewTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
       UITableViewCell *cell2=  [self.combineViewTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

        cell1.accessoryType=UITableViewCellAccessoryNone;
        cell2.accessoryType=UITableViewCellAccessoryCheckmark;
        shouldShowThirdCell=true;
        [self.combineViewTable beginUpdates];
        
        [self.combineViewTable reloadData];
        
        [self.combineViewTable endUpdates];
       // shouldShowThirdCell=false;
    
    }
}

#pragma mark -
#pragma mark === Tableview Delegate ===
#pragma mark -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    if(shouldShowThirdCell==true)
    {
        NSLog(@"reload");
        cellIdentifier=[NSString stringWithFormat:@"CombineViewCell%d",(int)indexPath.row*2];
    }
    else
    {
         cellIdentifier=[NSString stringWithFormat:@"CombineViewCell%d",(int)indexPath.row];
    }
    CombineViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if([cell.reuseIdentifier isEqualToString:@"CombineViewCell0"])
    {
        cell.cell1Label.text=[NSString stringWithFormat:@"%@, %@",self.existingCustomer,self.existingProject];
        
    }
    else if ([cell.reuseIdentifier isEqualToString:@"CombineViewCell2"])
    {
        cell.cell2Label.text=[NSString stringWithFormat:@"%@, %@",self.selectedCustomer,self.selectedProject];
    }
    else
    {
        
    }
    
    UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
    selectedBackgorundView.backgroundColor=[UIColor clearColor];
    cell.selectedBackgroundView=selectedBackgorundView;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row==3)
//    {
//        return 100;
//    }
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if(indexPath.row==1)
    {
    [self.pickerBackView setHidden:NO];
    }
    
    UITableViewCell *cell=[self.combineViewTable cellForRowAtIndexPath:indexPath];
    
    UITableViewCell *firstCell=[self.combineViewTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
       UITableViewCell *thirdCell=[self.combineViewTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    if([cell.reuseIdentifier isEqualToString:@"CombineViewCell1"])
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
        firstCell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        if(indexPath.row==0)
        {
            thirdCell.accessoryType=UITableViewCellAccessoryNone;
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else
        {
            firstCell.accessoryType=UITableViewCellAccessoryNone;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }

    
        
    }
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    // Remove seperator inset
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    
    // Prevent the cell from inheriting the Table View's margin settings
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        
        [cell setPreservesSuperviewLayoutMargins:NO];
        
    }
    
    
    // Explictly set your cell's layout margins
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if(indexPath.row==1)
    {
    shouldShowThirdCell=false;
    }
    
}
#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerDataSource.count;
}
// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerDataSource[row];
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}
@end
