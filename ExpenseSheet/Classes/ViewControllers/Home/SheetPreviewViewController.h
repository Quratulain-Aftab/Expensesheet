//
//  SheetPreviewViewController.h
//  ExpenseSheet
//
//  Created by SISC on 1/3/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SheetPreviewViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *SheetPreviewTable;
@property NSInteger sheetId;
@property NSString *navigationTitle;
@end
