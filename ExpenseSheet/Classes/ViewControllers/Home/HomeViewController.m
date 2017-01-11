//
//  HomeViewController.m
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/17/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import "HomeViewController.h"
#import "SheetCell.h"
#import <CoreData/CoreData.h>
#import "Constants.h"
#import "ExpenseSheetDetailViewController.h"
#import "CreateViewCell2.h"
#import "CreateViewCell1.h"
#import "CurrentWeekCell.h"
#import "Utilities.h"
#import "SheetPreviewViewController.h"
@interface HomeViewController ()
@property (nonatomic, strong) id previewingContext;
@property (strong) NSMutableArray *dataSource;
@end

@implementation HomeViewController
{
    
   // UIImagePickerController *imagePicker;
    UIImage *_image;
    NSInteger sheetID;
    NSString *sheetTitle;
    
    NSDate *firstWeekday;
    
    NSMutableArray *montharray;
    NSMutableArray *submittedArray;
    
    NSTimer *animationTimer;
    
    NSString *PreviewsheetTitle;
    
    NSMutableArray *currentWeekDataSource;

}
@synthesize imagePicker;
#pragma mark -
#pragma mark === View Controller Delegate ===
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeUIAdjustments];
    [self check3DTouch];
    
   }
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self adjustTable];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:isBackFromWeekView])
    {
        
        [self.sheetsListTable setEditing:NO];
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:isBackFromWeekView];
       }
    
    
  }
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
  animationTimer=[NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(AnimationTimerHandler:) userInfo:nil repeats:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}
#pragma mark -
#pragma mark === ConfiguringView ===
#pragma mark -
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)makeUIAdjustments
{
    self.mainview.backgroundColor=[[Utilities shareManager]backgroundColor];
    self.myExpenseSheetsView.backgroundColor=[[Utilities shareManager]backgroundColor];
    
    currentWeekDataSource=[[NSMutableArray alloc]init]
    ;
    
    submittedArray=[[NSMutableArray alloc
                     ] init];
    montharray=[[NSMutableArray alloc
                 ] init];
    
    
    self.sheetsListTable.delegate=self;
    self.sheetsListTable.dataSource=self;
    self.sheetsListTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.sheetsListTable.bounds.size.width, 0.01f)];
    
    
    self.CurrentWeekTable.delegate=self;
    self.CurrentWeekTable.dataSource=self;
    [self.CurrentWeekTable setEditing:NO animated:YES];
    
    self.createButton.enabled=false;
    
    self.addbuttonBackview.layer.borderWidth=1.0;
    self.addbuttonBackview.layer.cornerRadius=30;
    self.addbuttonBackview.layer.borderColor=[UIColor whiteColor].CGColor;
    
    self.menuButtonBackview.layer.borderWidth=1.0;
    self.menuButtonBackview.layer.cornerRadius=30;
    self.menuButtonBackview.layer.borderColor=[UIColor whiteColor].CGColor;
    
    self.cerateviewTable.delegate=self;
    self.cerateviewTable.dataSource=self;
    self.cerateviewTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.cerateviewTable.bounds.size.width, 0.01f)];
    
    [self.cerateButtonEmptyview.layer setCornerRadius:5.0];
    
    
    self.titleView.backgroundColor=[[Utilities shareManager]backgroundColor];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
    
    self.pickerviewTitle.backgroundColor=[[Utilities shareManager]backgroundColor];
    
    self.pickerviewTitle.layer.shadowOffset = CGSizeMake(0, 5);
    self.pickerviewTitle.layer.shadowRadius = 2;
    self.pickerviewTitle.layer.shadowOpacity = 0.3;
    
    self.createViewTitle.backgroundColor=[[Utilities shareManager]backgroundColor];
    self.createViewTitle.layer.shadowOffset = CGSizeMake(0, 5);
    self.createViewTitle.layer.shadowRadius = 2;
    self.createViewTitle.layer.shadowOpacity = 0.3;
    
}
-(void)adjustTable
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ExpenseSheet];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"id" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    self.dataSource = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [submittedArray removeAllObjects];
    [montharray removeAllObjects];
    [currentWeekDataSource removeAllObjects];
    
    for(int i=0;i<self.dataSource.count;i++)
    {
        NSManagedObject *sheet = [self.dataSource objectAtIndex:i];
        NSNumber  *status=[sheet valueForKey:@"status"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM"];
        
        NSString *currentSheetMonth=[self getDateOfMonth:[sheet valueForKey:@"date"]];
        
        NSString *currentmonth=[self getDateOfMonth:[NSDate date]];
        
        BOOL isCurrentWeek=[self isDateBelongsToCurrentWeek:[sheet valueForKey:@"date"]];
        
        if([status intValue]==1)
        {
            
            [submittedArray addObject:sheet];
            
        }
        if([currentSheetMonth isEqualToString: currentmonth])
        {
            [montharray addObject:sheet];
        }
        if(isCurrentWeek==true)
        {
             [currentWeekDataSource addObject:sheet];
            isCurrentWeek=false;
        }
        
    }
    
    [self.sheetsListTable reloadData];
    [self.CurrentWeekTable reloadData];
    if(self.dataSource.count>0)
    {
        self.sheetsListTable.hidden=NO;
        
    }
    else{
        self.sheetsListTable.hidden=YES;
        self.EmptyTableView.frame=self.view.frame;
        [self.view addSubview:self.EmptyTableView];
        [self.view bringSubviewToFront:self.EmptyTableView];
        
    }
    
}
#pragma mark -
#pragma mark === Buttons Action ===
#pragma mark - MainView Buttons
- (IBAction)drawerButtonAction:(id)sender {
    [self.myExpenseSheetsView setFrame:CGRectMake( 0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.myExpenseSheetsView];
    [self.view bringSubviewToFront:self.myExpenseSheetsView];//notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.5];
    self.myExpenseSheetsView.frame=self.view.frame;
    self.mainview.hidden=YES;
    [UIView commitAnimations];
    [self.sheetsListTable reloadData];
}
- (IBAction)addSheetButtonAction:(id)sender
{
    
    [self.createview setFrame:CGRectMake( 0.0f, self.view.frame.size.height, self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:self.createview];
    [self.view bringSubviewToFront:self.createview];//notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.5];
    self.createview.frame=self.view.frame;
    [UIView commitAnimations];
    
//    CreateViewCell1 *cell1=[self.cerateviewTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
   // cell1.startDateLabel.text=[]
    CreateViewCell2 *cell2=[self.cerateviewTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell2.descriptionTextfiled setText:@""];
    [cell2.descriptionTextfiled becomeFirstResponder];
    [cell2 isFocused];
    
}
- (IBAction)shareButtonAction:(id)sender {
    
    UIImage *image =[UIImage imageNamed:@"logo"];
    
    NSArray *objectsToShare = @[image];
    
    UIActivityViewController *activityViewController =
    
    [[UIActivityViewController alloc] initWithActivityItems:objectsToShare
     
                                      applicationActivities:nil];
    
    
    if ( [activityViewController respondsToSelector:@selector(popoverPresentationController)] ) {
        
        // iOS8
        
        activityViewController.popoverPresentationController.sourceView = self.view;
        
    }
    
    [activityViewController setValue:@"Expense Sheet" forKey:@"subject"];
    
    
    
    //if iPhone
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        [self presentViewController:activityViewController
         
                           animated:YES
         
                         completion:^{
                             
                             // ...
                             
                         }];    }
    
    //if iPad
    
    else
    {
        
        // Change Rect to position Popover
        
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        
        [popup presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections: UIPopoverArrowDirectionDown animated:YES];
        
    }
    
    
}
- (IBAction)aboutUsButtonAction:(id)sender {
    
    [self performSegueWithIdentifier:@"AboutusSegue" sender:nil];
}
- (IBAction)settingsButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"SettingsSegue" sender:nil];
}

#pragma mark - MyExpensesheetsView Buttons
- (IBAction)searchButtonAction:(id)sender {
    
//    if(self.searchbar.hidden==YES)
//    {
//        self.searchbar.hidden=NO;
//          self.searchbarHeight.constant=44
//        ;
//        self.segmentView.hidden=YES;
//        self.addButton.hidden=YES;
//        self.editButton.hidden=YES;
//        
//        self.noexpensesheetSegmentLabel.hidden=YES;
//        [self.segmentView setSelectedSegmentIndex:0];
//        [self.sheetsListTable reloadData];
//        self.sheetsListTable.hidden=NO;
//    }
//    else
//    {
//          self.searchbarHeight.constant=0;
//        self.searchbar.hidden=YES;
//         self.segmentView.hidden=NO;
//        self.addButton.hidden=NO;
//        self.editButton.hidden=NO;
//        
//    }
}
- (IBAction)expenseSheetEditButtonAction:(id)sender {
    if(self.editButton.tag==100)
    {
        // enable editing mode
        self.editButton.tag=101;
        self.sheetsListEditButtonWidth.constant=35.0;
        self.editSheetsTitleLabel.hidden=NO;
        self.closeListButton.hidden=YES;
        self.segmentView.hidden=YES;
        [self.sheetsListTable setEditing:YES animated:YES];
        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.editButton setImage:nil forState:UIControlStateNormal];
       
    }
    else{
        self.editButton.tag=100;
        self.sheetsListEditButtonWidth.constant=22.0;
        [self.editButton setTitle:@"" forState:UIControlStateNormal];
        [self.editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        self.editSheetsTitleLabel.hidden=YES;
        self.closeListButton.hidden=NO;
        self.segmentView.hidden=NO;
        [self.view layoutSubviews];
        [self.sheetsListTable setEditing:NO animated:YES];
    }


}
- (IBAction)expenseSheetsCancelButtonAction:(id)sender {
    [UIView animateWithDuration:0.5
                     animations:^{
                          self.mainview.hidden=NO;
                         [self.myExpenseSheetsView setFrame:CGRectMake( 0,self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
                     } completion:^(BOOL finished)
     {
        
         [self.myExpenseSheetsView removeFromSuperview];
     }];

}
- (IBAction)segmentAction:(id)sender {
 NSLog(@"action..");
    //[self.sheetsListTable beginUpdates];
    [self.sheetsListTable reloadData];
   // [self.sheetsListTable beginUpdates];
    
    if(self.segmentView.selectedSegmentIndex==0)
    {
        if(self.dataSource.count>0)
        {
            self.sheetsListTable.hidden=NO;
            self.noexpensesheetSegmentLabel.hidden=YES;
        }
    }
    else if (self.segmentView.selectedSegmentIndex==1)
    {
        if(montharray.count>0)
        {
            self.sheetsListTable.hidden=NO;
             self.noexpensesheetSegmentLabel.hidden=YES;
        }
        else
        {
             self.sheetsListTable.hidden=YES;
             self.noexpensesheetSegmentLabel.hidden=NO;
            self.noexpensesheetSegmentLabel.text=@"No expense sheet this month";
        }
    }
    else{
        if(submittedArray.count>0)
        {
             self.sheetsListTable.hidden=NO;
             self.noexpensesheetSegmentLabel.hidden=YES;
             self.noexpensesheetSegmentLabel.text=@"No expense sheet submitted yet";
        }
        else
        {
             self.sheetsListTable.hidden=YES;
             self.noexpensesheetSegmentLabel.hidden=NO;
        }
        
    }
}
#pragma mark - CreateExpenseSheetView Buttons
- (IBAction)cancelButtonAction:(id)sender
{
    CreateViewCell2 *cell2=[self.cerateviewTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell2.descriptionTextfiled endEditing:YES];
    [UIView animateWithDuration:0.5
                     animations:^{
                        [self.createview setFrame:CGRectMake( 0,self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
                     } completion:^(BOOL finished)
    {
                         [self.createview removeFromSuperview];
        
    }];

}
- (IBAction)createButtonAction:(id)sender
{
     CreateViewCell2 *cell2=[self.cerateviewTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if(![cell2.descriptionTextfiled.text isEqualToString:@""])
    {
    [self.EmptyTableView removeFromSuperview];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSInteger idd=0;
    if([[NSUserDefaults standardUserDefaults]integerForKey:@"sheetID"])
    {
        idd=[[NSUserDefaults standardUserDefaults]integerForKey:@"sheetID"];
    }
    

    idd=idd+1;
    
    [[NSUserDefaults standardUserDefaults]setInteger:idd forKey:@"sheetID"];
    
    sheetID=idd;

    sheetTitle=cell2.descriptionTextfiled.text;
    
    NSManagedObject *newSheet = [NSEntityDescription insertNewObjectForEntityForName:ExpenseSheet inManagedObjectContext:context];
    [newSheet setValue:[NSNumber numberWithInteger:idd] forKey:@"id"];
    [newSheet setValue:cell2.descriptionTextfiled.text forKey:@"sheetDescription"];
    [newSheet setValue:self.createDatePicker.date forKey:@"date"];
    [newSheet setValue:[NSNumber numberWithBool:NO] forKey:@"status"];

    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self.cerateviewTable reloadData];
    [self.createview removeFromSuperview];
    
        
        NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:AppGroupName];
        
        // Use the shared user defaults object to update the user's account
        [mySharedDefaults setObject:sheetTitle forKey:@"Description"];
        
        NSDateFormatter *df=[[NSDateFormatter alloc]init];
    
         [mySharedDefaults setObject:[df stringFromDate:self.createDatePicker.date] forKey:@"Duration"];
        
    
      NSLog(@"description set is %@",[mySharedDefaults objectForKey:@"Description"]);
    [self performSegueWithIdentifier:@"weeksegue" sender:nil];
    
    }
}
#pragma mark - DatePickerView Buttons
- (IBAction)pickerDoneButtonAction:(id)sender
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.pickerbackview setFrame:CGRectMake( self.view.frame.size.width,0, self.view.frame.size.width, self.view.frame.size.height)];
                     } completion:^(BOOL finished)
     {
         [self.pickerbackview removeFromSuperview];
         
         CreateViewCell1 *cell=(CreateViewCell1 *)[self.cerateviewTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
         
         NSDateFormatter *df=[[NSDateFormatter alloc]init];
         [df setDateFormat:@"dd-MM-yyyy"];
         cell.dateLabelCreateView.text=[df stringFromDate:firstWeekday];
         
        // [self.cerateviewTable reloadData];
         
//         NSArray *paths=[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
//         [self.cerateviewTable reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
       
         NSLog(@"cell is %@",cell);
         
     }];
    

}

- (IBAction)pickerCancelButtonAction:(id)sender
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.pickerbackview setFrame:CGRectMake( self.view.frame.size.width,0, self.view.frame.size.width, self.view.frame.size.height)];
                     } completion:^(BOOL finished)
     {
         [self.pickerbackview removeFromSuperview];
     }];
    

}
#pragma mark -
#pragma mark === Tableview Delegate ===
#pragma mark -
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //add code here for when you hit delete
        NSManagedObject *sheetItem = [self.dataSource objectAtIndex:indexPath.row];
        NSManagedObjectContext *context = [self managedObjectContext];
        [context deleteObject:sheetItem];
        NSError *error;
        if (![context save:&error]) {
            // Handle the error.
        }
        
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self adjustTable];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (aTableView==self.sheetsListTable)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  // Tell the table to begin updates to ensure that the following reloads and animations all happen at once
    
    [super setEditing:editing animated:animated];
       [self.sheetsListTable beginUpdates];
    // set the table editing if you are not using UITableViewController
    
    // reload any rows that may need updating for the new state
    
    if (editing) {
        // tell the table view to insert the editing rows
    } else {
        // tell the table view to remove the editing rows
        
    }
    
    [self.sheetsListTable endUpdates]; // commit the updates.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==self.sheetsListTable)
    {
   // sheetID=[self.dataSource ]
     NSManagedObject *sheet = [self.dataSource objectAtIndex:indexPath.row];
    sheetID=[[sheet valueForKey:@"id"] integerValue];
    sheetTitle=[sheet valueForKey:@"sheetDescription"];
    [self performSegueWithIdentifier:@"weeksegue" sender:nil];
    }
    else if (tableView==self.CurrentWeekTable)
    {
        NSManagedObject *sheet = [currentWeekDataSource objectAtIndex:indexPath.row];
        sheetID=[[sheet valueForKey:@"id"] integerValue];
        sheetTitle=[sheet valueForKey:@"sheetDescription"];
        [self performSegueWithIdentifier:@"weeksegue" sender:nil];
    }
    else
    {
        if(indexPath.row==0)
      
        {
            CreateViewCell2 *cell2=[self.cerateviewTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [cell2.descriptionTextfiled resignFirstResponder];
          //  NSCalendar *gregorian = [NSCalendar currentCalendar];
            NSDate *currentDate = [NSDate date];
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setDay:-2];
           // NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
            //[comps setDay:-2];
           // NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
            

           // self.createDatePicker.minimumDate = minDate;
            self.createDatePicker.maximumDate = currentDate;
            [self.pickerbackview setFrame:CGRectMake( self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:self.pickerbackview];
            [self.view bringSubviewToFront:self.pickerbackview];//notice this is OFF screen!
            [UIView beginAnimations:@"animateTableView" context:nil];
            [UIView setAnimationDuration:0.5];
            self.pickerbackview.frame=self.view.frame;
            
            [UIView commitAnimations];
            [cell2.descriptionTextfiled resignFirstResponder];

        }
    }
  
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.sheetsListTable)
    {
    SheetCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
 
        NSManagedObject *sheet;
        if(self.segmentView.selectedSegmentIndex==0)
        {
        sheet= [montharray objectAtIndex:indexPath.row];
        }
        else if (self.segmentView.selectedSegmentIndex==1)
        {
            sheet= [self.dataSource objectAtIndex:indexPath.row];
        }
        else{
            sheet= [submittedArray objectAtIndex:indexPath.row];
        }
    
      NSDateFormatter *df = [[NSDateFormatter alloc] init];
      [df setDateFormat:@"MM/dd/yyyy"];
 
    NSLog(@"id is : %@",[sheet valueForKey:@"id"]);
          NSLog(@"status is : %@",[sheet valueForKey:@"status"]);
  NSDate *endDate=[[sheet valueForKey:@"date"]  dateByAddingTimeInterval:60*60*24*7];
    
    cell.intervalLabel.text = [NSString stringWithFormat:@"%@-%@",
                               [df stringFromDate:[sheet valueForKey:@"date"]], [df stringFromDate:endDate]];
     
    [cell.descriptonLabel setText:[NSString stringWithFormat:@"%@", [sheet valueForKey:@"sheetDescription"]]];
    if([sheet valueForKey:@"documentName"])
    {
    [cell.receiptImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [sheet valueForKey:@"documentName"]]]];
    }
    
        UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
        selectedBackgorundView.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
        cell.selectedBackgroundView=selectedBackgorundView;
       return cell;
    }
    else
        if(tableView==self.CurrentWeekTable)
            
        {
            CurrentWeekCell *cell;
            cell=[tableView dequeueReusableCellWithIdentifier:@"CurrentWeekCell" forIndexPath:indexPath];
            
            UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
            selectedBackgorundView.backgroundColor=[UIColor clearColor];
            cell.selectedBackgroundView=selectedBackgorundView;
            
            NSManagedObject *sheet=[currentWeekDataSource objectAtIndex:indexPath.row];
            cell.descriptionLabel.text=[sheet valueForKey:@"sheetDescription"];
            
            NSDate *startDate=[sheet valueForKey:@"date"];
            
            NSCalendar *gregorian = [NSCalendar currentCalendar];
            NSDateComponents *componentsToAdd = [gregorian components:NSCalendarUnitDay fromDate:startDate];
            [componentsToAdd setDay:6];
            NSDate *endOfWeek = [gregorian dateByAddingComponents:componentsToAdd toDate:startDate options:0];
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            NSLocale* en_AU_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU_POSIX"];
            [formatter setLocale:en_AU_POSIX];
            [formatter setDateFormat:@"dd"];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            
            cell.durationLabel.text=[NSString stringWithFormat:@"%@ - %@",[formatter stringFromDate:startDate],[formatter stringFromDate:endOfWeek]];
            
            return cell;

        }
    else

    {
        if(indexPath.row==0)
        {
        CreateViewCell1 *cell;
        cell=[tableView dequeueReusableCellWithIdentifier:@"CreateViewCell1" forIndexPath:indexPath];
            
           // NSCalendar *gregorian = [NSCalendar currentCalendar];
           // NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
          //  [components setDay:([components day]-([components weekday]-[[NSCalendar currentCalendar] firstWeekday]))];
          //  firstWeekday = [gregorian dateFromComponents:components];
            if(firstWeekday)
            {
            NSDateFormatter *df=[[NSDateFormatter alloc]init];
            [df setDateFormat:@"MM-dd-yy"];
            
            cell.dateLabelCreateView.text=[df stringFromDate:firstWeekday];
            }
            
            UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
            selectedBackgorundView.backgroundColor=[UIColor clearColor];
            cell.selectedBackgroundView=selectedBackgorundView;

            return cell;

        }
        else
        {
            
             CreateViewCell2 *cell;
             cell=[tableView dequeueReusableCellWithIdentifier:@"CreateViewCell2" forIndexPath:indexPath];
            cell.descriptionTextfiled.delegate=self;
            [self performSelector:@selector(appearKeyboard:) withObject:cell afterDelay:2.0];
           
            
            UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
            selectedBackgorundView.backgroundColor=[UIColor clearColor];
            cell.selectedBackgroundView=selectedBackgorundView;
            
            return cell;

        }
    }
        
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.sheetsListTable)
    {
        if(self.segmentView.selectedSegmentIndex==0)
        {
            return montharray.count;

        }
        else if (self.segmentView.selectedSegmentIndex==1)
        {
            return self.dataSource.count;
        }
        else{
            return submittedArray.count;
        }

    }
    else if (tableView==self.CurrentWeekTable)
    {
        if(self.dataSource.count>0)
        return 1;
        else
            return 0;
    }
    else
    {
        return 2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.sheetsListTable)
    {
        return 60.0;
    }
    else if(tableView==self.CurrentWeekTable)
    {
        return 70.0;
    }
    else
    {
        return 44.0;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
   if(tableView==self.sheetsListTable)
   {
    //1. Setup the CATransform3D structure
       
       if((self.segmentView.selectedSegmentIndex==0 && montharray.count==indexPath.row+1 &&  montharray.count>0) || (self.dataSource.count==indexPath.row+1 && self.segmentView.selectedSegmentIndex==1 && self.dataSource.count>0))
       {
        
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:1];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
           
       }
   }
}

#pragma mark -
#pragma mark === Search Bar Delegate ===
#pragma mark -
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [self.searchbar resignFirstResponder];
//    
//    [self.searchbar setShowsCancelButton:NO animated:YES];
//    
//    self.titleViewHeight.constant=64;
//    
//    self.searchbarHeight.constant=0;
//    self.searchbar.hidden=YES;
//    self.segmentView.hidden=NO;
//    self.addButton.hidden=NO;
//    self.editButton.hidden=NO;
//    
//}
//-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    //This'll Show The cancelButton with Animation
//  [self.searchbar setShowsCancelButton:YES animated:YES];
//    
//    self.titleViewHeight.constant=22;
//  }
//-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    //This'll Show The cancelButton with Animation
//    [self.searchbar setShowsCancelButton:NO animated:YES];
//    self.searchbar.showsCancelButton=NO;
//}
#pragma mark -
#pragma mark === UITextfield Delegate ===
#pragma mark -
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    //This'll Show The cancelButton with Animation

    return YES;
}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        //Returning yes allows the entered chars to be processed
    if(textField.text.length>1)
    {
        self.createButton.enabled=YES;
    }
    return YES;
}
#pragma mark -
#pragma mark === Core Data ===
#pragma mark -
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
#pragma mark -
#pragma mark === UIImagePickerController Delegate ===
#pragma mark -

//must conform to both UIImagePickerControllerDelegate and UINavigationControllerDelegate
//but don’t have to implement any of the UINavigationControllerDelegate methods.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    _image = info[UIImagePickerControllerEditedImage];

    NSData *imageData = UIImagePNGRepresentation(_image);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
    
    NSLog(@"pre writing to file");
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog(@"Failed to cache image data to disk");
    }
    else
    {
        NSLog(@"the cachedImagedPath is %@",imagePath);
    }

   [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)takePhoto
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)choosePhotoFromLibrary
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)showImage:(UIImage *)image
{
    //self.imageView.image = image;
    // self.imageView.hidden = NO;
    
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
  //  if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].y > 0) {
    //    NSLog(@"show search bar");
        
    //    self.searchbar.frame=CGRectMake(self.searchbar.frame.origin.x, /self.searchbar.frame.origin.y, self.searchbar.frame.size.width, 44);
     //   self.searchbarHeight.constant=90;
      //  self.searchbar.hidden=NO;
        // handle dragging to the right
  //  } else {
        // handle dragging to the
      //   self.titleViewHeight.constant=64;
   //     NSLog(@"hide search bar");
     //   self.searchbar.frame=CGRectMake(self.searchbar.frame.origin.x, self.searchbar.frame.origin.y, self.searchbar.frame.size.width, 0);
     //  self.searchbarHeight.constant=0;
     //   self.searchbar.hidden=YES;
      //  [self resignFirstResponder];
       
  //  }
//}
//#pragma mark - Force Touch
//-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
//    [super traitCollectionDidChange:previousTraitCollection];
//    if ([self isForceTouchAvailable]) {
//        if (!self.previewingContext) {
//            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.sheetsListTable];
//        }
//    } else {
//        if (self.previewingContext) {
//            [self unregisterForPreviewingWithContext:self.previewingContext];
//            self.previewingContext = nil;
//        }
//    }
//}
//- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
//    
//    CGPoint cellPosition = [self.sheetsListTable convertPoint:location fromView:self.sheetsListTable];
//    NSIndexPath *path = [self.sheetsListTable indexPathForRowAtPoint:cellPosition];
//    
//    if (path) {
//        UITableViewCell *tableCell = [self.sheetsListTable cellForRowAtIndexPath:path];
//        UIViewController *previewController =[[UIViewController alloc]init];
//        //[self prepareYourPreviewStatement];
//        previewController.preferredContentSize = CGSizeMake(300, 400);
//        previewingContext.sourceRect = [self.view convertRect:tableCell.frame fromView:(UIView*)self.sheetsListTable];
//        UILabel *test=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//        test.center=previewController.view.center;
//        test.textColor=[UIColor blackColor];
//        test.text=@"test label for pressure touch";
//        [previewController.view addSubview:test];
//        return previewController;
//    }
//    return nil;
//}
//-(void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
//    
//    [self.navigationController showViewController:viewControllerToCommit sender:nil];
//    
//}
#pragma mark -
#pragma mark === Picker Selector ===
#pragma mark -
- (IBAction)dateChanged:(id)sender {
    
    NSDate *weekDay =self.createDatePicker.date; //any date in the week in which to calculate the first or last day
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:weekDay];
    [components setDay:([components day]-([components weekday]-[[NSCalendar currentCalendar] firstWeekday]))];
    
    firstWeekday = [gregorian dateFromComponents:components];
    //   NSDate *lastWeekday = [[gregorian dateFromComponents:components] dateByAddingTimeInterval:7 * 24 * 3600 - 1];
    //   NSLog(@"first - %@ \nlast - %@", firstWeekday, lastWeekday);
    
   // NSString *pickeddate=[self getDayOfWeekShortString:firstWeekday];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"E MM-dd-yyyy"];
    self.pickerviewLabel.text = [NSString stringWithFormat:@"%@",
                                 [df stringFromDate:firstWeekday]];
    // [self.createDatePicker setHidden:YES];
}

#pragma mark -
#pragma mark === UIViewControllerPreviewingDelegate Methods ===
#pragma mark -

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
              viewControllerForLocation:(CGPoint)location {
    
    NSIndexPath *indexPath = [self.sheetsListTable indexPathForRowAtPoint:location];
    NSManagedObject *sheet = [self.dataSource objectAtIndex:indexPath.row];
    if (sheet) {
        SheetCell *cell = [self.sheetsListTable cellForRowAtIndexPath:indexPath];
        if (cell) {
            previewingContext.sourceRect = cell.frame;
            UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewNavigationVC"];
            PreviewsheetTitle=[sheet valueForKey:@"sheetDescription"];
          [self configureNavigationController:navController withSheetID:[[sheet valueForKey:@"id"] intValue]];
            return navController;
        }
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self showDetailViewController:viewControllerToCommit sender:self];
}
#pragma mark -
#pragma mark === Helper methods ===
#pragma mark -

- (NSManagedObject *)sheetForIndexPath:(NSIndexPath *)indexPath {

    NSManagedObject *sheet = nil;
    if (indexPath) {
        if (self.segmentView.selectedSegmentIndex==0) {
            sheet = [montharray objectAtIndex:indexPath.row];
        } else {
            sheet = [self.dataSource objectAtIndex:indexPath.row];
        }
    }
    return sheet;
}

- (void)configureNavigationController:(UINavigationController *)navController withSheetID:(NSInteger)sheetId {
    
    if ([navController.topViewController isKindOfClass:[SheetPreviewViewController class]]) {
        SheetPreviewViewController *controller = (SheetPreviewViewController *)navController.topViewController;
        controller.sheetId = sheetId;
        controller.navigationTitle=PreviewsheetTitle;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}
-(NSString *)getDayOfWeekShortString:(NSDate *)date
{
    static NSDateFormatter *shortDayOfWeekFormatter;
    if(!shortDayOfWeekFormatter){
        shortDayOfWeekFormatter = [[NSDateFormatter alloc] init];
        NSLocale* en_AU_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU_POSIX"];
        [shortDayOfWeekFormatter setLocale:en_AU_POSIX];
        [shortDayOfWeekFormatter setDateFormat:@"EE"];
    }
    return [shortDayOfWeekFormatter stringFromDate:date];
}

-(NSString *)getDateOfMonth:(NSDate *)date
{
    static NSDateFormatter *dateFormaater;
    if(!dateFormaater){
        dateFormaater = [[NSDateFormatter alloc] init];
        NSLocale* en_AU_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU_POSIX"];
        [dateFormaater setLocale:en_AU_POSIX];
        [dateFormaater setDateFormat:@"MM"];
    }
    return [dateFormaater stringFromDate:date];
}
- (NSInteger)numberOfWeek:(NSDate *)date
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSCalendarUnitWeekOfYear fromDate:date];
    return [components weekOfYear];
}
-(BOOL)isDateBelongsToCurrentWeek:(NSDate *)date
{
    if ([self numberOfWeek:[NSDate date]] == [self numberOfWeek:date])
    {
        NSLog(@"Same Week");
          return YES;
    }
    else
    {
        NSLog(@"Different Week");
          return false;
    }

}
- (UILongPressGestureRecognizer *)longPress {
    
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showPeekView)];
        [self.view addGestureRecognizer:_longPress];
    }
    return _longPress;
}
-(void)showPeekView
{
    
}
-(void)appearKeyboard:(CreateViewCell2 *)cell
{
    [cell.descriptionTextfiled becomeFirstResponder];
    [cell isFocused];
}
-(void)AnimationTimerHandler:(NSTimer *)timer
{
    if(self.addNewSheetButtonTop.constant<75)
    {
        
        if(self.myExpenseSheetsButtonTop.constant<75)
        {
            self.myExpenseSheetsButtonTop.constant=self.myExpenseSheetsButtonTop.constant+5;
            self.addNewSheetButtonTop.constant=self.addNewSheetButtonTop.constant+2.5;
            
        }
        else
            self.addNewSheetButtonTop.constant=self.addNewSheetButtonTop.constant+2.5;
    }
    else
    {
        [animationTimer invalidate];
        animationTimer=nil;
    }
    
}
- (void)check3DTouch {
    
    // register for 3D Touch (if available)
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
        NSLog(@"3D Touch is available! Hurra!");
        
        // no need for our alternative anymore
        self.longPress.enabled = NO;
        
    } else {
        
        NSLog(@"3D Touch is not available on this device. Sniff!");
        
        // handle a 3D Touch alternative (long gesture recognizer)
        self.longPress.enabled = YES;
        
    }
}

#pragma mark -
#pragma mark === Navigation ===
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"weeksegue"])
    {
        ExpenseSheetDetailViewController *weekExpenseVC=(ExpenseSheetDetailViewController *)segue.destinationViewController;
        weekExpenseVC.sheetId=sheetID;
        weekExpenseVC.titleText=sheetTitle;
    }
}

@end
