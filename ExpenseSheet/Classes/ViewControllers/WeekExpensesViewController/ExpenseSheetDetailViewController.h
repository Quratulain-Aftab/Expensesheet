//
//  ExpenseSheetDetailViewController.h
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/23/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ExpenseSheetDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *weeklyTable;
@property (weak, nonatomic) IBOutlet UIView *addRowBackview;
@property (strong, nonatomic) IBOutlet UIView *emptyTableView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSString *titleText;

@property NSInteger sheetId;
@property NSInteger ItemId;
@property NSString *detailTitleText;
@property int mode;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *addbutton;
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIView *customersListView;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet UILabel *listTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchbarTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchbarHeight;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;

@property BOOL isNewSheet;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@end
