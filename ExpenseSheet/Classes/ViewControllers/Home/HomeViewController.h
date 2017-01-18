//
//  HomeViewController.h
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/17/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIViewControllerPreviewingDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *emptyTableView;
@property (weak, nonatomic) IBOutlet UILabel *noExpenseSheetLabel;
@property (weak, nonatomic) IBOutlet UIButton *emptyViewCreateButton;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *currentWeekTable;
@property (weak, nonatomic) IBOutlet UIView *addButtonBackView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *menuButtonBackView;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;


@property (strong, nonatomic) IBOutlet UIView *pickerbackview;
@property (weak, nonatomic) IBOutlet UIView *pickerViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *pickerviewLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *createDatePicker;


@property (weak, nonatomic) IBOutlet UIView *createView;
@property (weak, nonatomic) IBOutlet UIView *createViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *createViewTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *createViewCancelButton;
@property (weak, nonatomic) IBOutlet UITableView *createViewTable;

@property (weak, nonatomic) IBOutlet UIView *myExpenseSheetsView;
@property (weak, nonatomic) IBOutlet UITableView *sheetsListTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *closeListButton;
@property (weak, nonatomic) IBOutlet UILabel *editSheetsTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sheetsListEditButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addNewSheetButtonTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myExpenseSheetsButtonTop;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property UIImagePickerController *imagePicker;

@end
