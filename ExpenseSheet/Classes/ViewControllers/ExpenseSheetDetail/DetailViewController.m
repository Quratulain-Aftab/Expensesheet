//
//  DetailViewController.m
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/17/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import "DetailViewController.h"
#import <CoreData/CoreData.h>
#import "Constants.h"
#import "receiptViewController.h"
#import "UIButton+button.h"
#import "Utilities.h"
#import "CombineViewController.h"
@interface DetailViewController ()
@end

@implementation DetailViewController
{
    UIDatePicker *datepicker;
    UIPopoverController *popOverForDatePicker;
    UIView *transparantview;
    
    NSArray *expenseTypeArray;
    
    UIImagePickerController *_imagePicker;
    UIImage *_image;
    
    NSDictionary *metrics;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeUIAdjustments];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.amountField endEditing:YES];
    [self.descriptionField endEditing:YES];
    
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
    self.addreceiptButtonBackView.layer.cornerRadius=10;
    self.doneButton.enabled=false;
    
    self.titleView.backgroundColor=[[Utilities shareManager]backgroundColor];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
    
    self.addmoreBackview.backgroundColor=[[Utilities shareManager]backgroundColor];
    self.addmoreBackview.layer.shadowOffset = CGSizeMake(0, 5);
    self.addmoreBackview.layer.shadowRadius = 2;
    self.addmoreBackview.layer.shadowOpacity = 0.3;
    self.addmoreBackview.layer.cornerRadius=25.0;
    
    
    [self.dateview bringSubviewToFront:self.selectLabel];
    
    self.amountField.delegate=self;
    self.descriptionField.delegate=self;
    
    self.selectLabel.backgroundColor=[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
    
    self.amountField.keyboardType=UIKeyboardTypeNumberPad;
    
    // configuring buttons hit area
    [self.customerButton setHitTestEdgeInsets:UIEdgeInsetsMake(-1, -12, -1, -320)];
    [self.projectButton setHitTestEdgeInsets:UIEdgeInsetsMake(-1, -12, -1, -320)];
    [self.typeButton setHitTestEdgeInsets:UIEdgeInsetsMake(-1, -12, -1, -320)];
    [self.dateButton setHitTestEdgeInsets:UIEdgeInsetsMake(-1, -12, -1,-320
                                                           )];
    [self.addreceiptButton setHitTestEdgeInsets:UIEdgeInsetsMake(-1, -12, -1,-320
                                                                 )];
    
    expenseTypeArray =[NSArray arrayWithObjects:@"Sales",@"Software/Hardware",@"Lodging",@"Misc",@"Client Entertainment",@"Mileage",@"Per Deim",@"Air",@"Gase/Fuel",@"Phone",@"Taxi/Cab",@"Tips",@"Parking/Tolls",@"Rental Car",@"Employee - Gift",@"Education",@"Relocation Allowance", nil];
    
    [self configureView:self.mode];
    UITapGestureRecognizer *singleFingerTapOnCombineView =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapCombineView:)];
    [self.combineView addGestureRecognizer:singleFingerTapOnCombineView];
    
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        NSDictionary *views = @{@"beeView":_contentview};
        //  int width=self.view.frame.size.width;
        if (self.view.frame.size.width==414) {
            metrics = @{@"height" : @550, @"width" : @414};
        }
        else   if (self.view.frame.size.width==375) {
            metrics = @{@"height" : @550, @"width" : @375};
        }
        else{
            metrics = @{@"height" : @550, @"width" : @320};
        }
        
        [self.scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[beeView(height)]|" options:kNilOptions metrics:metrics views:views]];
        [self.scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[beeView(width)]|" options:kNilOptions metrics:metrics views:views]];
    }
    
}
-(void)configureView:(NSInteger)mode
{
    if(mode==1)
    {
        self.combineView.hidden=YES;
        // insert mode
        [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
        self.customerDisclosure.hidden=NO;
        self.customerEditButton.hidden=YES;
        self.projectDisclosure.hidden=NO;
        self.projectEditButton.hidden=YES;
        
        //     [self.doneButton setEnabled:false];
        
        
    }
    //    else if (mode==4)
    //    {
    //         self.combineView.hidden=NO;
    //    }
    else
    {
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ExpenseSheetDetailTable];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"foreignKey==%@ AND id==%@",[NSNumber numberWithInteger:self.sheetId],[NSNumber numberWithInteger:self.ItemId]];
        [fetchRequest setPredicate:predicate];
        NSArray *results = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        
        if(results.count>0)
        {
            NSManagedObject *Detail = [results objectAtIndex:0];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MM-dd-yyyy"];
            
            
            
            [self.dateButton setTitle:[NSString stringWithFormat:@"%@",
                                       [df stringFromDate:[Detail valueForKey:ExpenseDate]]]forState:UIControlStateNormal];
            
            [self.descriptionField setText:[NSString stringWithFormat:@"%@", [Detail valueForKey:DetailDescription]]];
            [self.amountField setText:[NSString stringWithFormat:@"%@", [Detail valueForKey:Amount]]];
            [self.projectButton setTitle:[NSString stringWithFormat:@"%@",[Detail valueForKey:ProjectName]]forState:UIControlStateNormal];
            [self.customerButton setTitle:[NSString stringWithFormat:@"%@",[Detail valueForKey:CustomerName]]forState:UIControlStateNormal];
            [self.typeButton setTitle:[NSString stringWithFormat:@"%@",[Detail valueForKey:ExpenseType]]forState:UIControlStateNormal];
            if([Detail valueForKey:Receipt])
            {
                [self.addreceiptButton setTitle:[NSString stringWithFormat:@"%@",[Detail valueForKey:Receipt]]forState:UIControlStateNormal];
            }
            
        }
        
        
        if (mode==2)
        {
            self.combineView.hidden=YES;
            // update mode
            [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
            self.customerDisclosure.hidden=YES;
            self.customerEditButton.hidden=YES;
            self.projectDisclosure.hidden=YES;
            self.projectEditButton.hidden=YES;
            self.projectButton.userInteractionEnabled=false;
            self.customerButton.userInteractionEnabled=false;
        }
        //      else  if (mode==4)
        //        {
        //            self.combineView.hidden=NO;
        //            // add more mode
        //            [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
        //            self.customerDisclosure.hidden=YES;
        //            self.customerEditButton.hidden=NO;
        //            self.projectDisclosure.hidden=YES;
        //            self.projectEditButton.hidden=NO;
        //
        //        }
        
        else
        {
            // view mode
            [self.doneButton setTitle:@"Edit" forState:UIControlStateNormal];
            [self.scrollview setUserInteractionEnabled:false];
            self.customerDisclosure.hidden=YES;
            self.customerEditButton.hidden=YES;
            self.projectDisclosure.hidden=YES;
            self.projectEditButton.hidden=YES;
            self.projectButton.userInteractionEnabled=false;
            self.customerButton.userInteractionEnabled=false;
        }
    }
    
}

#pragma mark -
#pragma mark === Buttons Action ===
#pragma mark - Topbar Buttons
- (IBAction)backButtonAction:(id)sender {
    
    //   if(self.isFromWeekViewController)
    //   {
    // [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    //  }
    //  else
    //  {
    //     WeekExpensesViewController *weekVC=(WeekExpensesViewController *)[self.storyboard //instantiateViewControllerWithIdentifier:@"weekVC"];
    //  [self.navigationController pushViewController:weekVC animated:YES];
    // }
    NSLog(@"print statements goes here");
    // [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)SaveButtonAction:(id)sender
{
    
    if(self.mode==1 || self.mode==4)
    {
        // insert mode
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        // Create a new managed object
        NSManagedObject *newSheetDetail = [NSEntityDescription insertNewObjectForEntityForName:ExpenseSheetDetailTable inManagedObjectContext:context];
        [newSheetDetail setValue:[NSNumber numberWithInteger:self.ItemId] forKey:DetailId];
        [newSheetDetail setValue:self.descriptionField.text forKey:DetailDescription];
        [newSheetDetail setValue:self.addreceiptButton.titleLabel.text forKey:Receipt];
        [newSheetDetail setValue:self.typeButton.titleLabel.text forKey:ExpenseType];
        [newSheetDetail setValue:self.projectButton.titleLabel.text forKey:ProjectName];
        [newSheetDetail setValue:self.customerButton.titleLabel.text forKey:CustomerName];
        if(_image)
        {
            [self saveImage];
        }
        
        
        // NSDateFormatter * df = [[NSDateFormatter alloc] init];
        // [df setDateFormat:@"MM-dd-yyyy"]; // from here u can change format..
        NSLog(@"datepicker date is %@",datepicker.date);
        [newSheetDetail setValue:datepicker.date forKey:ExpenseDate];
        [newSheetDetail setValue:[NSNumber numberWithDouble:[self.amountField.text doubleValue]]forKey:Amount];
        [newSheetDetail setValue:[NSNumber numberWithInteger:self.sheetId] forKey:ForeignKey];
        
        NSLog(@"self.descriptionField.text is %ld",(long)self.sheetId);
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isBackFromDetailView];
        //[self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.mode==2)
    {
        // edit mode
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ExpenseSheetDetailTable];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"foreignKey==%@",[NSNumber numberWithInteger:self.sheetId]];
        [fetchRequest setPredicate:predicate];
        NSArray *results = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        if(results.count>0)
        {
            NSManagedObject* detailGrabbed = [results objectAtIndex:0];
            [detailGrabbed setValue:self.descriptionField.text forKey:DetailDescription];
            [detailGrabbed setValue:[NSNumber numberWithDouble:[self.amountField.text doubleValue]]forKey:Amount];
            
            // Save the object to persistent store
            if (![managedObjectContext save:nil]) {
                
                //   NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }
        else
        {
        }
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isBackFromDetailView];
        //  [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        // view mode
        // change mode to 2 .i.e edit mode
        [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
        self.mode=2;
        self.scrollview.userInteractionEnabled=YES;
    }
    
    
}

#pragma mark - Expense Detail Input Buttons
- (IBAction)customerButtonAction:(id)sender {
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Select Customer" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *customer1Action = [UIAlertAction actionWithTitle:@"Smart IS" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.customerButton setTitle:@"Smart IS" forState:UIControlStateNormal]
        ;
        
    }];
    UIAlertAction *customer2Action = [UIAlertAction actionWithTitle:@"Apple" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.customerButton setTitle:@"Apple" forState:UIControlStateNormal]
        ;
        
    }];
    UIAlertAction *customer3Action = [UIAlertAction actionWithTitle:@"Hydrite" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.customerButton setTitle:@"Hydrite" forState:UIControlStateNormal]
        ;
        
    }];
    
    UIAlertAction *customer4Action = [UIAlertAction actionWithTitle:@"Oracular Inc" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.customerButton setTitle:@"Oracular Inc" forState:UIControlStateNormal]
        ;
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        
    }];
    
    [alert addAction:customer1Action];
    [alert addAction:customer2Action];
    [alert addAction:customer3Action];
    [alert addAction:customer4Action];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (IBAction)projectButtonAction:(id)sender {
    
    
    if([self.customerButton.titleLabel.text isEqualToString:@"Add Customer"])
    {
        UIAlertController *error=[UIAlertController alertControllerWithTitle:nil message:@"Select Customer first" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
        }];
        
        [error addAction:cancelAction];
        
        [self presentViewController:error animated:YES completion:nil];
        
        return;
    }
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Project name 1" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.projectButton setTitle:@"Project name 1" forState:UIControlStateNormal]
        ;
        
    }];
    UIAlertAction *Ok = [UIAlertAction actionWithTitle:@"Project name 2" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.projectButton setTitle:@"Project name 2" forState:UIControlStateNormal]
        ;
        
    }];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Project name 3" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.projectButton setTitle:@"Project name 3" forState:UIControlStateNormal]
        ;
        
        
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"Project name 4" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.projectButton setTitle:@"Project name 4" forState:UIControlStateNormal]
        ;
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:Ok];
    [alert addAction:yes];
    
    [alert addAction:no];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}
- (IBAction)expenseTypeButtonAction:(id)sender {
    
    if([self.customerButton.titleLabel.text isEqualToString:@"Add Customer"])
    {
        UIAlertController *error=[UIAlertController alertControllerWithTitle:nil message:@"Select Customer first" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
        }];
        
        [error addAction:cancelAction];
        
        [self presentViewController:error animated:YES completion:nil];
        
        return;
    }
    
    if([self.projectButton.titleLabel.text isEqualToString:@"Add Project"])
    {
        UIAlertController *error=[UIAlertController alertControllerWithTitle:nil message:@"Select Project first" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
        }];
        
        [error addAction:cancelAction];
        
        [self presentViewController:error animated:YES completion:nil];
        
        return;
    }
    
    NSString *titletext=@"Select Expense Type";
    
    NSString *canceltext=@"Cancel";
    
    UIViewController *controller = [[UIViewController alloc]init];
    CGRect rect;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        
        rect = CGRectMake(0, 0, 272, 420);
    }
    else
    {
        rect = CGRectMake(0, 0, 272, 400);
        
        if(self.view.frame.size.height==480)
        {
            rect = CGRectMake(0, 0, 272, 200);
        }
    }
    
    self.expenseTypeTable  = [[UITableView alloc]initWithFrame:rect];
    self.expenseTypeTable.delegate = self;
    self.expenseTypeTable.dataSource = self;
    self.expenseTypeTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [  self.expenseTypeTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [  self.expenseTypeTable setTag:12];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.expenseTypeTable.rowHeight = 50;
    }
    else
    {
        self.expenseTypeTable.rowHeight = 60;
    }
    self.expenseTypeTable.scrollEnabled=YES;
    
    
    [controller setPreferredContentSize:rect.size];
    [controller.view addSubview:self.expenseTypeTable];
    [controller.view bringSubviewToFront:self.expenseTypeTable];
    [controller.view setUserInteractionEnabled:YES];
    [self.expenseTypeTable setUserInteractionEnabled:YES];
    [self.expenseTypeTable setAllowsSelection:YES];
    self.alertcontroller = [UIAlertController alertControllerWithTitle:titletext message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self.alertcontroller setValue:controller forKey:@"contentViewController"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:canceltext style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [self.alertcontroller addAction:cancelAction];
    
    
    [self presentViewController:_alertcontroller animated:YES completion:nil];
}

- (IBAction)selectDateButtonAction:(id)sender
{
    
    UIButton *button=(UIButton *)sender;
    
    datepicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 200)];
    datepicker.layer.cornerRadius=3.0;
    datepicker.datePickerMode = UIDatePickerModeDate;
    datepicker.hidden = NO;
    datepicker.date = [NSDate date];
    //  [datepicker addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
    
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        
        
        UIViewController *viewController = [[UIViewController alloc]init];
        UIView *viewForDatePicker = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        
        [viewForDatePicker addSubview:datepicker];
        [viewController.view addSubview:viewForDatePicker];
        
        popOverForDatePicker = [[UIPopoverController alloc]initWithContentViewController:viewController];
        popOverForDatePicker.delegate = self;
        [popOverForDatePicker setPopoverContentSize:CGSizeMake(self.view.frame.size.width, 130) animated:NO];
        [popOverForDatePicker presentPopoverFromRect:button.frame inView:self.dateview  permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown| UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight) animated:YES];
    }
    else
        
    {
        transparantview=[[UIView alloc] initWithFrame:self.view.frame];
        transparantview.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
        
        UIView *viewForDatePicker = [[UIView alloc]initWithFrame:CGRectMake(0, transparantview.frame.size.height-240, self.view.frame.size.width, 240)];
        viewForDatePicker.layer.cornerRadius=3.0;
        [viewForDatePicker setBackgroundColor:[UIColor lightGrayColor]];
        UIButton* doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame=CGRectMake(self.view.frame.size.width-60-5, 0, 60, 39);
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton setTitleColor:[[Utilities shareManager]backgroundColor] forState:UIControlStateNormal];
        [doneButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        //   [doneButton.layer setBorderWidth:1.0];
        [doneButton addTarget:self action:@selector(datePickedOkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //  doneButton.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
        
        doneButton.backgroundColor=[UIColor whiteColor];
        
        [viewForDatePicker addSubview:doneButton];
        
        
        UILabel *headinglabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 100, 21)];
        headinglabel.text=@"Select Expense Date";
        headinglabel.textColor=[UIColor blackColor];
        headinglabel.center=viewForDatePicker.center;
        headinglabel.font=[UIFont systemFontOfSize:16];
        ;        headinglabel.frame=CGRectMake(self.view.frame.size.width/2-85, 9, 170, 21);
        [viewForDatePicker addSubview:headinglabel];
        headinglabel.textAlignment=NSTextAlignmentCenter;
        
        //    (self.view.frame.size.width-60, 0, 60, 39)
        UIButton* cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame=CGRectMake(5, 0, 60, 39);
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[[Utilities shareManager]backgroundColor] forState:UIControlStateNormal];
        [cancelButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        doneButton.titleLabel.textAlignment=NSTextAlignmentRight;
        cancelButton.titleLabel.textAlignment=NSTextAlignmentLeft;
        //  [cancelButton.layer setBorderWidth:1.0];
        //   cancelButton.backgroundColor=[UIColor whiteColor];
        [cancelButton addTarget:self action:@selector(datePickedCancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [viewForDatePicker addSubview:cancelButton];
        doneButton.titleLabel.font=[UIFont systemFontOfSize:14];
        cancelButton.titleLabel.font=[UIFont systemFontOfSize:14];
        //  doneButton.layer.cornerRadius=3.0;
        //  cancelButton.layer.cornerRadius=3.0;
        viewForDatePicker.layer.cornerRadius=3.0;
        [viewForDatePicker addSubview:datepicker];
        [transparantview addSubview:viewForDatePicker];
        //   viewForDatePicker.center=transparantview.center;
        
        viewForDatePicker.backgroundColor=[UIColor whiteColor];
        // viewForDatePicker.layer.borderColor=[UIColor lightGrayColor].CGColor;
        //  viewForDatePicker.layer.borderWidth=1.0;
        
        [transparantview bringSubviewToFront:viewForDatePicker];
        
        
        // viewForDatePicker.center=transparantview.center;
        [self.view addSubview: transparantview];
        
        
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-baszed application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)documentTextfieldAction:(id)sender {
}
- (IBAction)resetButtonAction:(id)sender {
}
- (IBAction)browseButtonAction:(id)sender {
    
}
- (IBAction)addmoreButtonAction:(id)sender {
    
    self.combineView.hidden=NO;
    self.projectviewHeight.constant=0;
    self.projectDetailViewHeight.constant=134-44;
    self.projectButton.hidden=YES;
    self.projectDisclosure.hidden=YES;
    self.projectLabel
    .hidden=YES;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newSheetDetail = [NSEntityDescription insertNewObjectForEntityForName:ExpenseSheetDetailTable inManagedObjectContext:context];
    [newSheetDetail setValue:[NSNumber numberWithInteger:self.ItemId] forKey:DetailId];
    [newSheetDetail setValue:self.descriptionField.text forKey:DetailDescription];
    [newSheetDetail setValue:self.addreceiptButton.titleLabel.text forKey:Receipt];
    [newSheetDetail setValue:self.typeButton.titleLabel.text forKey:ExpenseType];
    [newSheetDetail setValue:self.projectButton.titleLabel.text forKey:ProjectName];
    [newSheetDetail setValue:self.customerButton.titleLabel.text forKey:CustomerName];
    [newSheetDetail setValue:[NSDate date] forKey:ExpenseDate];
    [newSheetDetail setValue:[NSNumber numberWithDouble:[self.amountField.text doubleValue]]forKey:Amount];
    [newSheetDetail setValue:[NSNumber numberWithInteger:self.sheetId] forKey:ForeignKey];
    
    
    NSLog(@"self.descriptionField.text is %ld",(long)self.sheetId);
    
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    self.ItemId=self.ItemId+1;
    
    
    // self.mode=4;
    
    self.customerDisclosure.hidden=YES;
    self.customerEditButton.hidden=NO;
    self.projectDisclosure.hidden=YES;
    self.projectEditButton.hidden=NO;
    
    [self.typeButton setTitle:@"Add Type" forState:UIControlStateNormal];
    
    
    self.receiptImageButton.hidden=YES;
    self.removeButton.hidden=YES;
    self.attchtreceiptLabel.text=@"Add Receipt";
    self.infoviewHeight.constant=118;
    
    self.amountField.text=nil;
    self.descriptionField.text=nil;
    
    
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.5];
    self.addmoreBottom.constant=-50;
    [UIView commitAnimations];
    
    //   self.addmoreButton.enabled=false;
    
    // [self performSegueWithIdentifier:@"addmoresegue" sender:nil];
    
    
}
- (IBAction)receiptButtonAction:(id)sender {
    
    [self.scrollview setContentOffset:CGPointMake(0, 0)];
    
    // if ([UIImagePickerController /isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    
    UIAlertController *receiptALertCotroller=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhotoAction= [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //   [self.customerButton setTitle:@"Customer 1" forState:UIControlStateNormal]
        // ;
        [self takePhoto];
        
    }];
    UIAlertAction *LibraryAction = [UIAlertAction actionWithTitle:@"Choose from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //   [self.customerButton setTitle:@"Customer 1" forState:UIControlStateNormal]
        // ;
        [self choosePhotoFromLibrary];
    }];
    UIAlertAction *cancelction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }];
    
    
    [receiptALertCotroller addAction:takePhotoAction];
    [receiptALertCotroller addAction:LibraryAction];
    [receiptALertCotroller addAction:cancelction];
    
    [self presentViewController:receiptALertCotroller animated:YES completion:nil];
    
    //          } else {
    //
    //        [self choosePhotoFromLibrary];
    //    }
}
- (IBAction)receiptImageButtonAction:(id)sender {
    
    [self performSegueWithIdentifier:@"receiptviewsegue" sender:nil];
}
- (IBAction)removeButtonAction:(id)sender {
    
    self.receiptImageButton.hidden=YES;
    self.removeButton.hidden=YES;
    self.attchtreceiptLabel.text=@"Attach Receipt";
    self.infoviewHeight.constant=118;
    
}
- (IBAction)projectEditButtonAction:(id)sender {
}
- (IBAction)customerEditButtonAction:(id)sender {
}
#pragma mark - PickerView Buttons Action
-(void)datePickedOkButtonAction:(id)sender
{
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"]; // from here u can change format..
    [self.dateButton setTitle:[df stringFromDate:datepicker.date] forState:UIControlStateNormal]
    ;
    [transparantview removeFromSuperview];
    
}

-(void)datePickedCancelButtonAction:(id)sender
{
    
    [transparantview removeFromSuperview];
    
}
#pragma mark -
#pragma mark === Tableview Delegate ===
#pragma mark -
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.expenseTypeTable)
    {
        return 9;
        
    }
    else
        return 1;
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
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:@"expenseCell"];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"expenseCell"];
    }
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        cell.textLabel.font=[UIFont systemFontOfSize:30];
        
    }
    else
    {
        
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        
    }
    
    cell.textLabel.text=[expenseTypeArray objectAtIndex:[indexPath row]];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.typeButton setTitle:[expenseTypeArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [self setAddMoreButton];
    [self.alertcontroller dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark === Gestures Handler ===
#pragma mark -
//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    [self.descriptionField resignFirstResponder];
    [self.amountField resignFirstResponder];
    //Do stuff here...
}
- (void)handleSingleTapCombineView:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    [self performSegueWithIdentifier:@"CustomerProjectSegue" sender:nil];
    //Do stuff here...
}

#pragma mark - UITextfield Delegate
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    //This'll Show The cancelButton with Animation
    
    self.scrollview.contentOffset=CGPointMake(0, 100);
    self.scrollview.layer.shadowOffset=CGSizeMake(0, 3);
    
    return YES;
}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    [self setAddMoreButton];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.amountField) {
        [textField resignFirstResponder];
        [self.descriptionField becomeFirstResponder];
        return YES;
    }
    [textField resignFirstResponder];
    return YES;
}

//must conform to both UIImagePickerControllerDelegate and UINavigationControllerDelegate
//but don’t have to implement any of the UINavigationControllerDelegate methods.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //   if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    self.attchtreceiptLabel.text
    =@"receipt";
    _image = info[UIImagePickerControllerEditedImage];
    [self.receiptImageButton setBackgroundImage:_image forState:UIControlStateNormal];
    self.removeButton.hidden=NO;
    self.receiptImageButton.hidden=NO;
    self.infoviewHeight.constant=218;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self setAddMoreButton];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark ===  Core Data ===
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
#pragma mark === Helper methods ===
#pragma mark -
-(void)setAddMoreButton
{
    [self performSelector:@selector(callWithDelay) withObject:nil afterDelay:1.0];
}
-(void)callWithDelay
{
    if(([self.customerButton.titleLabel.text isEqualToString:@"Add Customer"]||[self.projectButton.titleLabel.text isEqualToString:@"Add Project"]||[self.typeButton.titleLabel.text isEqualToString:@"Add Type"])||[self.amountField.text isEqualToString:@""]||[self.descriptionField.text isEqualToString:@""]||[self.attchtreceiptLabel.text isEqualToString:@"Receipt"])
    {
        
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.2];
        self.addmoreBottom.constant=-50;
        [UIView commitAnimations];
        self.doneButton.enabled=false;
    }
    else{
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.2];
        self.addmoreBottom.constant=10;
        
        [UIView commitAnimations];
        self.doneButton.enabled=YES;
    }
    
}
- (void)takePhoto
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
- (void)choosePhotoFromLibrary
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
- (void)saveImage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageName=[NSString stringWithFormat:@"%ld_%ld.png",self.sheetId,self.ItemId];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSData *imageData = UIImagePNGRepresentation(
                                                 _image);
    [imageData writeToFile:savedImagePath atomically:NO];
}
#pragma mark -
#pragma mark === Navigation ===
#pragma mark -
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"receiptviewsegue"])
    {
        receiptViewController *receiptVC=(receiptViewController *)segue.destinationViewController;
        receiptVC.image=_image;
        
    }
    else if ([segue.identifier isEqualToString:@"CustomerProjectSegue"])
    {
        CombineViewController *combineVc=segue.destinationViewController;
        combineVc.existingCustomer=self.customerButton.titleLabel.text;
        combineVc.existingProject=self.projectButton.titleLabel.text;
    }
}
@end
