//
//  WeekStartDayViewController.h
//  ExpenseSheet
//
//  Created by Quratulain on 1/11/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekStartDayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UITableView *weekDaysTable;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end
