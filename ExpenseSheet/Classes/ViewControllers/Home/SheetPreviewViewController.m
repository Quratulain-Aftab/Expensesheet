//
//  SheetPreviewViewController.m
//  ExpenseSheet
//
//  Created by SISC on 1/3/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "SheetPreviewViewController.h"
#import <CoreData/CoreData.h>
#import "Constants.h"
#import "DayCell.h"

@interface SheetPreviewViewController ()
@property NSMutableArray *dataSource;
@end

@implementation SheetPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.topItem.title=self.navigationTitle;
    
    NSLog(@"title is %@",self.navigationTitle);
    
    self.SheetPreviewTable.delegate=self;
    self.SheetPreviewTable.dataSource=self;
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ExpenseSheetDetail];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"foreignKey==%@",[NSNumber numberWithInteger:self.sheetId]];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"id" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    self.dataSource = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

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
#pragma mark - Tableview Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.SheetPreviewTable)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
       // NSManagedObject *sheetItem = [self.dataSource objectAtIndex:indexPath.row];
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PreviewSheetCell" forIndexPath:indexPath];
        NSManagedObject *sheetDetail;
                 sheetDetail = [self.dataSource objectAtIndex:indexPath.row];
   
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd-yyyy"];
        
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                               [df stringFromDate:[sheetDetail valueForKey:ExpenseDate]]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                               [df stringFromDate:[sheetDetail valueForKey:ExpenseDate]]];
        
        NSLog(@"foreign key is %d" ,[[sheetDetail valueForKey:ForeignKey]intValue]);
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%@", [sheetDetail valueForKey:DetailDescription]]];
        UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
        selectedBackgorundView.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
        cell.selectedBackgroundView=selectedBackgorundView;
        return cell;
    }
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       
            return self.dataSource.count;
    }
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 80;
  }

#pragma mark - Core Data
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


@end
