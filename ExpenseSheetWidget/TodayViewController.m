//
//  TodayViewController.m
//  ExpenseSheetWidget
//
//  Created by Quratulain on 1/4/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "Constants.h"
#import <CoreData/CoreData.h>

@interface TodayViewController () <NCWidgetProviding>
@property NSMutableArray *dataSource;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.createNewExpenseSheetButton.layer.cornerRadius=3.0;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:AppDidBecomeActiveNotification object:nil];
    
   // NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ExpenseSheet];
   // NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                            //  initWithKey:@"id" ascending:NO];
  //  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    //self.dataSource = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    

    completionHandler(NCUpdateResultNewData);
    NSLog(@"widgetPerformUpdateWithCompletionHandler");
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:AppGroupName];
    NSLog(@"desc is %@", [mySharedDefaults objectForKey:@"Description"]);
    [mySharedDefaults objectForKey:@"Description"];
   // [self.createNewExpenseSheetButton setTitle: [mySharedDefaults objectForKey:@"Description"] forState:UIControlStateNormal] ;
    
}
- (IBAction)createNewExpenseSheetButtonAction:(id)sender {
}
-(void)refreshData:(NSNotification *)notification
{
    
}

@end
