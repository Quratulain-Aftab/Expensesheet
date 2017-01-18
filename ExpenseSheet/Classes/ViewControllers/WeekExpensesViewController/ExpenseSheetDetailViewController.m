//
//  ExpenseSheetDetailViewController.m
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/23/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import "ExpenseSheetDetailViewController.h"
#import "DayCell1.h"
#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import <CoreData/CoreData.h>
#import "Constants.h"
#import "DayCell.h"
#import "Utilities.h"
#import "DetailPreviewViewController.h"
#import "UIButton+button.h"
#import "BackgroundCollectionViewCell.h"
@interface ExpenseSheetDetailViewController ()
@property (strong) NSMutableArray *dataSource;
@end

@implementation ExpenseSheetDetailViewController
{
    BOOL isEditButtonClicked;
    NSMutableArray *listDataSource;
    NSMutableArray *listTableDataSource;
    NSMutableArray *searchResults;
    BOOL isFilteredData;
    NSString *matchingString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self makeUIAdjustments];
    
//    if(self.shouldPresentDetailVC)
//    {
//       // self.view.hidden=YES;
//        [self performSegueWithIdentifier:@"detailsegue" sender:nil];
//        self.shouldPresentDetailVC=false;
//      
//    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:isBackFromDetailView])
    {
         [self adjustViewAccordingToState];
          [self.weeklyTable reloadData];
          [[NSUserDefaults standardUserDefaults]setBool:NO forKey:isBackFromDetailView];
    }
    
//    if(self.shouldPresentDetailVC)
//    {
//        self.view.hidden=YES;
//        [self performSegueWithIdentifier:@"detailsegue" sender:nil];
//        self.shouldPresentDetailVC=false;
//        self.view.hidden=NO;
//    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.view.hidden=NO;
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
    listTableDataSource=[[NSMutableArray alloc]init];
    
   
    self.titleView.backgroundColor=[[Utilities shareManager]backgroundColor];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
    
    self.weeklyTable.delegate=self;
    self.weeklyTable.dataSource=self;
    self.weeklyTable.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.weeklyTable.frame.size.width, 44)];
     self.searchbar.delegate=self;
    self.searchbar.searchBarStyle=UISearchBarStyleMinimal;
//    UIButton *searchBarCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    searchBarCancelButton.frame=CGRectMake(5, 7, 50, 30);
//    [searchBarCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
//    [searchBarCancelButton setTitleColor:[[Utilities shareManager]backgroundColor] forState:UIControlStateNormal];
//    [searchBarCancelButton addTarget:self action:@selector(searchbarCancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [searchBarCancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
//    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.weeklyTable.frame.size.width, 44)];
//    [headerView addSubview:searchBarCancelButton];
//    [headerView addSubview:self.searchbar];
    
     self.weeklyTable.tableHeaderView=self.searchbar;

    self.backview.layer.cornerRadius=25.0;
    
    if(![self.titleText isEqualToString:@""])
    {
        self.titleLabel.text=self.titleText;
    }
    else{
        self.titleLabel.text=@"New Expense Sheet";
    }
    
    self.listTable.delegate=self;
    self.listTable.dataSource=self;
    
    self.receiptsTable.delegate=self;
    self.receiptsTable.dataSource=self;
    

    
    self.infoCollectionView.delegate=self;
    self.infoCollectionView.dataSource=self;
    
    self.dateCollectionView.delegate=self;
    self.dateCollectionView.dataSource=self;
    
    self.receiptCollectionView.delegate=self;
    self.receiptCollectionView.dataSource=self;
    

    
    self.dateListTable.delegate=self;
    self.dateListTable.dataSource=self;
    
    self.InfoListCloseButton.hitTestEdgeInsets=UIEdgeInsetsMake(-5, -5, -5, -15);
    self.datesListCloseButton.hitTestEdgeInsets=UIEdgeInsetsMake(-5, -5, -5, -15);
    self.receiptsViewCloseButton.hitTestEdgeInsets=UIEdgeInsetsMake(-5, -5, -5, -15);
    
    
     self.backButton.hitTestEdgeInsets=UIEdgeInsetsMake(-5, -5, -5, -15);
     self.addbutton.hitTestEdgeInsets=UIEdgeInsetsMake(-5, -15, -5, -5);
   
    
    listDataSource=[[NSMutableArray alloc] init];
    
    [self adjustViewAccordingToState];
    
    [self check3DTouch];
    

}
-(void)adjustViewAccordingToState
{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ExpenseSheetDetailTable];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"foreignKey==%@",[NSNumber numberWithInteger:self.sheetId]];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"id" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    self.dataSource = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    
    if(self.dataSource.count>0)
    {
        
        self.weeklyTable.hidden=NO;
        self.saveButton.enabled=YES;
        self.submitButton.enabled=YES;
        self.editButton.enabled=YES;
        
        
        [self.emptyTableView removeFromSuperview];
    }
    else{
        self.weeklyTable.hidden=YES;
        self.saveButton.enabled=NO;
        self.submitButton.enabled=NO;
        self.editButton.enabled=NO;
        
        
        self.emptyTableView.frame=CGRectMake(0, self.addRowBackview.frame.origin.y+self.addRowBackview.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(self.addRowBackview.frame.size.height+self.addRowBackview.frame.origin.y));
        
        [self.view addSubview:self.emptyTableView];
        [self.view bringSubviewToFront:self.emptyTableView];
        [self.view bringSubviewToFront:self.backview];
        
    }
    
}
#pragma mark -
#pragma mark === Buttons Action ===
#pragma mark -  Titlebar
- (IBAction)backButtonAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isBackFromWeekView"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addButtonAction:(id)sender {
    
    
    self.itemId=[self.dataSource count];
    self.mode=1;
    [self performSegueWithIdentifier:@"detailsegue" sender:nil];
}

- (IBAction)searchButtonAction:(id)sender {
    
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.2];
   
    self.titleViewHeight.constant=22;
    self.addRowBackview.hidden=YES;
     self.TopBarHeight.constant=0;
    //self.searchbarHeight.constant=44;
    [UIView commitAnimations];
    
}
-(void)searchbarCancelButtonAction:(id)sender
{
    [self.searchbar resignFirstResponder];
    
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.2];
    self.titleViewHeight.constant=64;
    self.addRowBackview.hidden=NO;
    self.TopBarHeight.constant=50;
    [UIView commitAnimations];
    
    self.searchbar.text=@"";
    isFilteredData=false;
    [self.weeklyTable reloadData];
}
#pragma mark - Topbar
- (IBAction)editButtonAction:(id)sender {
    if([self.editButton.titleLabel.text isEqualToString:@"Edit"])
    {
        [self.weeklyTable setEditing:YES animated:YES];
        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
    }
    else{
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.weeklyTable setEditing:NO animated:YES];
    }

}
- (IBAction)saveButtonAction:(id)sender
{
    
}
- (IBAction)submitButtonAction:(id)sender
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Expense Sheet" message:@"Do you want to submit this Expense Sheet?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)

                                   {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // sve status locally
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ExpenseSheetTable];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"id==%@",[NSNumber numberWithInteger:self.sheetId]];
        [fetchRequest setPredicate:predicate];
        NSArray *results = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        if(results.count>0)
        {
            NSManagedObject* detailGrabbed = [results objectAtIndex:0];
            [detailGrabbed setValue:[NSNumber numberWithBool:YES] forKey:@"status"];
            
            // Save the object to persistent store
            if (![managedObjectContext save:nil]) {
                
                //   NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }

        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode=MBProgressHUDModeText;
        
        hud.labelFont=[UIFont fontWithName:@"Arial" size:14];
        
        hud.center=self.view.center;
        
        hud.labelText=@"Submitted Successfully";
        
        
        hud.removeFromSuperViewOnHide=YES;
        
        [hud hide:YES afterDelay:0.5];

        
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

}
#pragma mark - Bottom Buttons
- (IBAction)customersListCancelButtonAction:(id)sender {
    
    [self.customersListView removeFromSuperview];
    [self.dateListView removeFromSuperview];
    [self.receiptsListView removeFromSuperview];
}

- (IBAction)customerButtonAction:(id)sender {
    
    
    NSInteger buttonTag=[(UIButton *)sender tag];
    
    self.infoDescriptionView.hidden=NO;
    [self.customersListView setFrame:CGRectMake( 0.0f, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.customersListView];
    [self.view bringSubviewToFront:self.customersListView];//notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.2];
    self.customersListView.frame=self.view.frame;
    
    [UIView commitAnimations];
 
   //  NSManagedObject *sheetDetail = [self.dataSource objectAtIndex:indexPath.row];
    [listTableDataSource removeAllObjects];
    [listDataSource removeAllObjects];
 

    if(buttonTag==11)
    {
        self.listTitle.text=@"Customers";
        matchingString=CustomerName;
    }
    else
    {
        self.listTitle.text=@"Projects";
        matchingString=ProjectName;
    }
    
    for(NSManagedObject *sheetDetail in self.dataSource)
    {
    if([listDataSource containsObject:[sheetDetail valueForKey:matchingString]]==NO)
    {
        [listDataSource addObject:[sheetDetail valueForKey:matchingString]];
    }
    }
    
     [self.infoCollectionView reloadData];
  }
//- (IBAction)projectButtonAction:(id)sender {
    
//    self.infoDescriptionView.hidden=NO;
//    
//    UIButton *button=(UIButton *)sender;
//    
//      [listDataSource removeAllObjects];
//    
//
//    if(button.tag==12)
//    {
//        // projects
//    for(NSManagedObject *sheetDetail in self.dataSource)
//    {
//        if([listDataSource containsObject:[sheetDetail valueForKey:ProjectName]]==NO)
//        {
//            [listDataSource addObject:[sheetDetail valueForKey:ProjectName]];
//        }
//    }
//     self.listTitle.text=@"Projects";
//    }
//    if(button.tag==13)
//    {
//        // dates
//        for(NSManagedObject *sheetDetail in self.dataSource)
//        {
//            NSDate *date=[sheetDetail valueForKey:ExpenseDate];
//            NSDateFormatter *df=[[NSDateFormatter alloc] init];
//            [df setDateFormat:@"EE , dd-MM"];
//     
//            NSString *dateString=[df stringFromDate:date];
//            
//            if([listDataSource containsObject:dateString]==NO)
//            {
//                [listDataSource addObject:dateString];
//            }
//        }
//        self.listTitle.text=@"Expense Dates";
//    }
//
//    if(button.tag==14)
//    {
//        // receipts
//        for(NSManagedObject *sheetDetail in self.dataSource)
//        {
//            if([listDataSource containsObject:[sheetDetail valueForKey:Receipt]]==NO)
//            {
//                if([sheetDetail valueForKey:Receipt])
//                [listDataSource addObject:[sheetDetail valueForKey:Receipt]];
//            }
//        }
//        self.listTitle.text=@"Receipts";
//    }
//
//    
//    [self.listTable reloadData];
//   
//
//    [self.customersListView setFrame:CGRectMake( 0.0f, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.view addSubview:self.customersListView];
//    [self.view bringSubviewToFront:self.customersListView];//notice this is OFF screen!
//    [UIView beginAnimations:@"animateTableView" context:nil];
//    [UIView setAnimationDuration:0.2];
//    self.customersListView.frame=self.view.frame;
//    
//    [UIView commitAnimations];
//}
- (IBAction)datesButtonAction:(id)sender {
    
    matchingString=ExpenseDate;
    self.dateListDescriptionView.hidden=NO;
    [self.dateListView setFrame:CGRectMake( 0.0f, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.dateListView];
    [self.view bringSubviewToFront:self.dateListView];//notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.2];
    self.dateListView.frame=self.view.frame;
    
    [UIView commitAnimations];
    
    //  NSManagedObject *sheetDetail = [self.dataSource objectAtIndex:indexPath.row];
    [listTableDataSource removeAllObjects];
    [listDataSource removeAllObjects];
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"E dd"];
    
    for(NSManagedObject *sheetDetail in self.dataSource)
    {
        NSString *currentDate=[dateFormatter stringFromDate:[sheetDetail valueForKey:ExpenseDate]];
        if([listDataSource containsObject:currentDate]==NO)
        {
            [listDataSource addObject:currentDate];
        }
    }
    
    [self.dateCollectionView reloadData];

}
- (IBAction)receiptsButtonAction:(id)sender {
    
    matchingString=Receipt;
    self.receiptsListDescriptionView.hidden=NO;
    [self.receiptsListView setFrame:CGRectMake( 0.0f, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.receiptsListView];
    [self.view bringSubviewToFront:self.receiptsListView];//notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.2];
    self.receiptsListView.frame=self.view.frame;
    
    [UIView commitAnimations];
    
    [listTableDataSource removeAllObjects];
    [listDataSource removeAllObjects];
    
    
        for(NSManagedObject *sheetDetail in self.dataSource)
        {
           NSInteger currentSheetID=[[sheetDetail valueForKey:ForeignKey] integerValue];
            NSInteger currentItemID=[[sheetDetail valueForKey:DetailId] integerValue];
            NSString *currentImageName=[NSString stringWithFormat:@"%ld_%ld.png",currentSheetID,currentItemID];
            if([listDataSource containsObject:currentImageName]==NO)
            {
            [listDataSource addObject:currentImageName];
            }
        }
    
        [self.receiptCollectionView reloadData];

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
        
        [self adjustViewAccordingToState];
        
        
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [self.weeklyTable beginUpdates]; // Tell the table to begin updates to ensure that the following reloads and animations all happen at once
    
    [super setEditing:editing animated:animated];
    
    // set the table editing if you are not using UITableViewController
    
    // reload any rows that may need updating for the new state
    
    if (editing) {
        // tell the table view to insert the editing rows
    } else {
        // tell the table view to remove the editing rows
    }
    
    [self.weeklyTable endUpdates]; // commit the updates.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSManagedObject *sheetItem;
    if(tableView==self.weeklyTable)
    {
        sheetItem = [self.dataSource objectAtIndex:indexPath.row];
    }
    else
    {
        sheetItem = [listTableDataSource objectAtIndex:indexPath.row];

    }
    
    [self.searchbar resignFirstResponder];
    [self.searchbar setShowsCancelButton:NO animated:YES];
    self.titleViewHeight.constant=64;
    self.addRowBackview.hidden=NO;
    self.TopBarHeight.constant=50;
    
    
    self.searchbar.text=@"";
    isFilteredData=false;
    [self.weeklyTable reloadData];

    
    self.detailTitleText=[sheetItem valueForKey:DetailDescription];
    isEditButtonClicked=YES;
    self.itemId=[[sheetItem valueForKey:DetailId] integerValue];
    self.mode=3;
    [self performSegueWithIdentifier:@"detailsegue" sender:nil];
        
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(tableView==self.weeklyTable)
    {
        DayCell *cell;
        cell=[tableView dequeueReusableCellWithIdentifier:@"DayCell" forIndexPath:indexPath];
            NSManagedObject *sheetDetail;
            if (isFilteredData) {
                
                sheetDetail=[searchResults objectAtIndex:indexPath.row];
            }
            else{
                sheetDetail = [self.dataSource objectAtIndex:indexPath.row];
            }
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MM-dd-yyyy"];
            
            cell.dateLabel.text = [NSString stringWithFormat:@"%@",
                                   [df stringFromDate:[sheetDetail valueForKey:ExpenseDate]]];
            cell.dateLabel.text = [NSString stringWithFormat:@"%@",
                                   [df stringFromDate:[sheetDetail valueForKey:ExpenseDate]]];
            
            NSLog(@"foreign key is %d" ,[[sheetDetail valueForKey:ForeignKey]intValue]);
            
            [cell.descriptionLabel setText:[NSString stringWithFormat:@"%@", [sheetDetail valueForKey:DetailDescription]]];
            [cell.amountLabel setText:[NSString stringWithFormat:@"%@", [sheetDetail valueForKey:Amount]]];
            
            if([self getImageWithName:[NSString stringWithFormat:@"%ld_%ld.png",[[sheetDetail valueForKey:ForeignKey] integerValue],[[sheetDetail valueForKey:DetailId] integerValue]]])
            {
                [cell.receiptimage setImage:[self getImageWithName:[NSString stringWithFormat:@"%ld_%ld.png",[[sheetDetail valueForKey:ForeignKey] integerValue],[[sheetDetail valueForKey:DetailId] integerValue]]]];
            }
            
            
            UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
            selectedBackgorundView.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
            cell.selectedBackgroundView=selectedBackgorundView;
      //  }
   
    return cell;
 }
    else
    {
         DayCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
          NSManagedObject *sheetDetail;
                   sheetDetail=[listTableDataSource objectAtIndex:indexPath.row];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd-yyyy"];
        
        cell.dateLabel.text = [NSString stringWithFormat:@"%@",
                               [df stringFromDate:[sheetDetail valueForKey:ExpenseDate]]];
        cell.dateLabel.text = [NSString stringWithFormat:@"%@",
                               [df stringFromDate:[sheetDetail valueForKey:ExpenseDate]]];
        
        NSLog(@"foreign key is %d" ,[[sheetDetail valueForKey:ForeignKey]intValue]);
        
        [cell.descriptionLabel setText:[NSString stringWithFormat:@"%@", [sheetDetail valueForKey:DetailDescription]]];
        [cell.amountLabel setText:[NSString stringWithFormat:@"%@", [sheetDetail valueForKey:Amount]]];
        
        if([UIImage imageNamed:[sheetDetail valueForKey:Receipt]]!=nil)
        {
            [cell.receiptimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[sheetDetail valueForKey:Receipt]]]];
        }
    
//        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
//        cell.textLabel.text=[[listTableDataSource objectAtIndex:indexPath.row] valueForKey:DetailDescription];
           return cell;
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.weeklyTable)
    {
        if(isFilteredData==false)
        {
            return self.dataSource.count;
        }
        else
        {
             return searchResults.count;
        }
    }
    else
    {
        return listTableDataSource.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(tableView==self.weeklyTable)
    {
//    if(indexPath.row==0)
//    {
//        return 44;
//    }
    return 80;
    }
    else
    return 80;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView==self.weeklyTable)
    {
    if(isFilteredData==false)
    {
        if(indexPath.row==0)
        {
        [self.weeklyTable setContentOffset:CGPointMake(0, 44) animated:NO];
       // [self.weeklyTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
        
     }
}
#pragma mark === Collectionview Delegate ===
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return listDataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"InfoCollectionCell";
    
    BackgroundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

   
        if([matchingString isEqualToString:ExpenseDate])
            {
                NSArray *arr=[[listDataSource objectAtIndex:indexPath.row] componentsSeparatedByString:@" "];
                cell.label.text=arr[0];
                cell.dateLabel.text=arr[1];
                cell.layer.cornerRadius=24.0;
                cell.backgroundColor=[UIColor clearColor];
        
                UIView *selectedView=[[UIView alloc]initWithFrame:cell.bounds];
        
                selectedView.backgroundColor=[[Utilities shareManager] backgroundColor];
        
                cell.selectedBackgroundView=selectedView;
                              
            }
        else if ([matchingString isEqualToString:Receipt])
            {
                    cell.backgroundColor=[UIColor clearColor];
                    cell.backgroundColor=[UIColor clearColor];
                    cell.backgroundImageView.image=[self getImageWithName:[listDataSource objectAtIndex:indexPath.row]];
            }
        else
            {
                cell.backgroundColor=[[Utilities shareManager] backgroundColor];
                cell.label.text=[listDataSource objectAtIndex:indexPath.row];
            }

    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
        [listTableDataSource removeAllObjects];

        NSDateFormatter *df=[[NSDateFormatter alloc]init];
        [df setDateFormat:@"E dd"];
    
        for(NSManagedObject *expense in self.dataSource)
        {
            NSString *current;
            if([matchingString isEqualToString:ExpenseDate])
            {
                current=[df stringFromDate:[expense valueForKey:ExpenseDate]];
            }
            else if([matchingString isEqualToString:Receipt])
            {
                current=[NSString stringWithFormat:@"%ld_%ld.png",[[expense valueForKey:ForeignKey] integerValue],[[expense valueForKey:DetailId] integerValue]];
            }
            else
            {
                current=[expense valueForKey:matchingString];
            }
            if([current isEqualToString: [listDataSource objectAtIndex:indexPath.row]])
            {
                [listTableDataSource addObject:expense];
            }
        }
    if([matchingString isEqualToString:ExpenseDate])
    {
        
        [self.dateListTable reloadData];
        self.dateListDescriptionView.hidden=YES;
    }
    else if([matchingString isEqualToString:Receipt])
    {
        [self.receiptsTable reloadData];
        self.receiptsListDescriptionView.hidden=YES;
 
    }
    else
    {
      [self.listTable reloadData];
       self.infoDescriptionView.hidden=YES;
    }

}
#pragma mark - Searchbar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    isFilteredData=true;
    
    searchResults = [[NSMutableArray alloc] init];
    
    for (NSManagedObject* currentExpense  in self.dataSource)
    {
        NSString *amount=[NSString stringWithFormat:@"%@",[currentExpense valueForKey:Amount]];
        NSString *currentstr=[[[[[currentExpense valueForKey:CustomerName]stringByAppendingString:[currentExpense valueForKey:ProjectName]]stringByAppendingString:[currentExpense valueForKey:ExpenseType]]stringByAppendingString:[currentExpense valueForKey:DetailDescription]]stringByAppendingString:amount];
        
        NSRange nameRange = [currentstr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if(nameRange.location != NSNotFound)
        {
            [searchResults addObject:currentExpense];
            //self.surahNotFoundLabel.hidden=YES;
        }
    }
    if(searchResults.count>0)
    {

    }
    [self.weeklyTable reloadData];
    
}
-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //This'll Show The cancelButton with Animation
    [self.searchbar setShowsCancelButton:YES animated:YES];
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.2];
   //  self.searchbar.frame = CGRectMake(60, 0, self.weeklyTable.frame.size.width-60, 44);
    self.titleViewHeight.constant=22;
    self.addRowBackview.hidden=YES;
    self.TopBarHeight.constant=0;
    [UIView commitAnimations];

    isFilteredData=true;
  [self.weeklyTable reloadData];

}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    isFilteredData=true;
    
    searchResults = [[NSMutableArray alloc] init];
    
    for (NSManagedObject* currentExpense  in self.dataSource)
    {
        NSString *amount=[NSString stringWithFormat:@"%@",[currentExpense valueForKey:Amount]];
        NSString *currentstr=[[[[[currentExpense valueForKey:CustomerName]stringByAppendingString:[currentExpense valueForKey:ProjectName]]stringByAppendingString:[currentExpense valueForKey:ExpenseType]]stringByAppendingString:[currentExpense valueForKey:DetailDescription]]stringByAppendingString:amount];
        
        NSRange nameRange = [currentstr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if(nameRange.location != NSNotFound)
        {
            [searchResults addObject:currentExpense];
        
        }
    }
    if(searchResults.count>0)
    {
        
    }
    
    [self.weeklyTable reloadData];
    

}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    
//    [searchBar resignFirstResponder];
//    
//    [self.searchbar setFrame:CGRectMake(0, 0, self.weeklyTable.frame.size.width, 44)];
//    
//    [UIView beginAnimations:@"animateTableView" context:nil];
//    [UIView setAnimationDuration:0.2];
//    
//    self.titleViewHeight.constant=64;
//    self.addRowBackview.hidden=NO;
//    self.TopBarHeight.constant=50;
//   self.searchbarHeight.constant=0;
//    [UIView commitAnimations];
//    
//    self.searchbar.text=@"";
//    isFilteredData=false;
//    [self.weeklyTable reloadData];
    
    [self.searchbar resignFirstResponder];
    [self.searchbar setShowsCancelButton:NO animated:YES];
    
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.2];
    self.titleViewHeight.constant=64;
    self.addRowBackview.hidden=NO;
    self.TopBarHeight.constant=50;
    [UIView commitAnimations];
    
    self.searchbar.text=@"";
    isFilteredData=false;
    [self.weeklyTable reloadData];

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
#pragma mark === UIViewControllerPreviewingDelegate Methods ===
#pragma mark -

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
              viewControllerForLocation:(CGPoint)location {
    
    NSIndexPath *indexPath = [self.weeklyTable indexPathForRowAtPoint:location];
    NSManagedObject *sheet = [self.dataSource objectAtIndex:indexPath.row];
    if (sheet) {
        DayCell *cell = [self.weeklyTable cellForRowAtIndexPath:indexPath];
        if (cell) {
            previewingContext.sourceRect = cell.frame;
            UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewDetailNavigationVC"];
            //PreviewsheetTitle=[sheet valueForKey:@"sheetDescription"];
            [self configureNavigationController:navController withExpenseDetail:sheet];
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

- (void)configureNavigationController:(UINavigationController *)navController withExpenseDetail:(NSManagedObject*)expenseDetail {
    
    if ([navController.topViewController isKindOfClass:[DetailPreviewViewController class]]) {
        DetailPreviewViewController *controller = (DetailPreviewViewController *)navController.topViewController;
        // controller.sheetId = sheetId;
        controller.expenseDetail=expenseDetail;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

- (UILongPressGestureRecognizer *)longPress {
    
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showPeek)];
        [self.view addGestureRecognizer:_longPress];
    }
    return _longPress;
}
-(void)showPeek
{
    
}
#pragma mark -
#pragma mark === Navigation ===
#pragma mark -
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"detailsegue"])
    {
        DetailViewController *detailVC=(DetailViewController *)segue.destinationViewController;
        detailVC.isFromWeekViewController=isEditButtonClicked;
        detailVC.sheetId=self.sheetId;
        detailVC.ItemId=self.itemId;
        detailVC.titleText=self.detailTitleText;
        detailVC.mode=self.mode;
    }
}
-(UIImage *)getImageWithName:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSData *myData = [[NSData alloc] initWithContentsOfFile:appFile];
    
    return [UIImage imageWithData:myData];

}
@end
