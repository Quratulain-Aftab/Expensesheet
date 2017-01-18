//
//  CalendarViewController.m
//  ExpenseSheet
//
//  Created by SISC on 1/1/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "CalendarViewController.h"
#import "Utilities.h"
#import "Model.h"
#import "Constants.h"
#import "DayCell.h"

@interface CalendarViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;

@end

@implementation CalendarViewController
{
    NSMutableArray *expenseDatasource;
    NSArray *expensesArray;
     NSInteger row;
    BOOL isSelected;
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
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
   if(isSelected)
   {
    isSelected=false;
    NSManagedObject *sheetItem = [expenseDatasource objectAtIndex:row];
    [_delegate sendDataToPreviousController:[[sheetItem valueForKey:@"id"] integerValue]];

   }
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
    
    self.FSCalendar.delegate=self;
    self.FSCalendar.dataSource=self;
    
    self.dateFormatter2 = [[NSDateFormatter alloc] init];
    self.dateFormatter2.dateFormat = @"yyyy-MM-dd";

    expensesArray=[Model fetchDataFromTable:ExpenseSheetTable];
    
    self.datesWithEvent=[[NSMutableArray alloc]init];
    
    NSLog(@"expensesarray is %@",expensesArray);
    for(NSManagedObject *date in expensesArray)
    {
   
        NSDate *currentDate=[date valueForKey:@"date"];
        
        [self.datesWithEvent addObject:[self.dateFormatter2 stringFromDate:currentDate]];
    }
       NSLog(@"datesarray is %@",self.datesWithEvent);
    
    self.expensesTable.delegate=self;
    self.expensesTable.dataSource=self;
    expenseDatasource=[[NSMutableArray alloc]init];
  }
#pragma mark -
#pragma mark === Buttons ===
#pragma mark -
- (IBAction)backButtonAction:(id)sender
{
      [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark === FSCalendar Delegate ===
#pragma mark -
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    return [self.datesWithEvent containsObject:[self.dateFormatter2 stringFromDate:date]];
}
- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventSelectionColorsForDate:(nonnull NSDate *)date
{
    if ([self calendar:calendar subtitleForDate:date]) {
        return @[appearance.eventDefaultColor];
    }
    if ([_datesWithEvent containsObject:[self.dateFormatter2 stringFromDate:date]]) {
        return @[[UIColor whiteColor]];
    }
    return nil;
}
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
    if ([_datesWithEvent containsObject:dateString]) {
        
        return [UIColor purpleColor];
    }
    return nil;
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter2 stringFromDate:date]);
    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
    if ([_datesWithEvent containsObject:dateString])
    {
        
        [expenseDatasource removeAllObjects];
        
       for(NSManagedObject *expense in expensesArray)
       {
           NSString *current=[ self.dateFormatter2 stringFromDate:[expense valueForKey:@"date"]];

           if([current isEqualToString: dateString])
           {
               [expenseDatasource addObject:expense];
           }
       }
        [self.expensesTable reloadData];
        self.noExpenseView.hidden=YES;
        
       }
    else
    {
        [expenseDatasource removeAllObjects];
       for(NSManagedObject *expense in expensesArray)
       {
           NSDate *startDate=[expense valueForKey:@"date"];
          // NSString *current=[ self.dateFormatter2 stringFromDate:[expense valueForKey:@"date"]];
           for(int i=0;i<7;i++)
           {
               NSDate *newDate=[startDate dateByAddingTimeInterval:i*24*60*60];
                NSString *newDateString=[ self.dateFormatter2 stringFromDate:newDate];
               if([newDateString isEqualToString: dateString])
               {
                   [expenseDatasource addObject:expense];
               }

           }
       }
        
        if(expenseDatasource.count>0)
        {
            [self.expensesTable reloadData];
            self.noExpenseView.hidden=YES;
                }
        else
        {
            self.noExpenseView.hidden=NO;
            self.noExpenseLabel.text=[NSString stringWithFormat:@"No Expense Sheet Found"];
        }
       
    }
}
#pragma mark -
#pragma mark === Tableview Delegate ===
#pragma mark -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isSelected=true;
    row=indexPath.row;
    [self dismissViewControllerAnimated:NO completion:nil];
 //    if(tableView==self.weeklyTable)
//    {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        NSManagedObject *sheetItem = [self.dataSource objectAtIndex:indexPath.row];
//        self.detailTitleText=[sheetItem valueForKey:DetailDescription];
//        isEditButtonClicked=YES;
//        self.ItemId=indexPath.row;
//        self.mode=3;
//        [self performSegueWithIdentifier:@"detailsegue" sender:nil];
//    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        DayCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DayCell" forIndexPath:indexPath];
        NSManagedObject *sheetDetail;
                   sheetDetail = [expenseDatasource objectAtIndex:indexPath.row];
    
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd-yyyy"];
        
        cell.dateLabel.text = [NSString stringWithFormat:@"%@",
                               [df stringFromDate:[sheetDetail valueForKey:@"date"]]];
       // cell.dateLabel.text = [NSString stringWithFormat:@"%@",
                             //  [df stringFromDate:[sheetDetail valueForKey:ExpenseDate]]];
        
     //   NSLog(@"foreign key is %d" ,[[sheetDetail valueForKey:ForeignKey]intValue]);
        
        [cell.descriptionLabel setText:[NSString stringWithFormat:@"%@", [sheetDetail valueForKey:@"sheetDescription"]]];
    
    if([[sheetDetail valueForKey:@"status"] boolValue]==true)
    {
        [cell.amountLabel setText:[NSString stringWithFormat:@"Submitted"]];
        [cell.amountLabel setTextColor:[UIColor greenColor]];
    }
    else
    {
         [cell.amountLabel setText:[NSString stringWithFormat:@"Saved"]];
        [cell.amountLabel setTextColor:[UIColor orangeColor]];
    }
    
        UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
        selectedBackgorundView.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
        cell.selectedBackgroundView=selectedBackgorundView;
        return cell;
 }
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        return expenseDatasource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 60;
}
@end
