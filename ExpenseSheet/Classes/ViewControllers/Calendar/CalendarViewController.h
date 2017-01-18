//
//  CalendarViewController.h
//  ExpenseSheet
//
//  Created by SISC on 1/1/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FSCalendar.h>
@protocol sendDataBack <NSObject>
-(void)sendDataToPreviousController:(NSInteger)ItemIdFromCalendar;
@end
@interface CalendarViewController : UIViewController<FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource>
@property (assign,nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet FSCalendar *FSCalendar;
@property NSMutableArray *datesWithEvent;
@property (weak, nonatomic) IBOutlet UITableView *expensesTable;
@property (weak, nonatomic) IBOutlet UIView *noExpenseView;
@property (weak, nonatomic) IBOutlet UILabel *noExpenseLabel;

@end
