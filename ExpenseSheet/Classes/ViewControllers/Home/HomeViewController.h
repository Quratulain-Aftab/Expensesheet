//
//  HomeViewController.h
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/17/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIViewControllerPreviewingDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *pickerviewTitle;

@property (weak, nonatomic) IBOutlet UIDatePicker *createDatePicker;
@property (weak, nonatomic) IBOutlet UIView *createview;
@property (weak, nonatomic) IBOutlet UIView *myExpenseSheetsView;
@property (weak, nonatomic) IBOutlet UITableView *sheetsListTable;
@property (strong, nonatomic) IBOutlet UIView *EmptyTableView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITableView *cerateviewTable;
@property (weak, nonatomic) IBOutlet UIView *createViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *cerateviewLabel;
@property (strong, nonatomic) IBOutlet UIView *pickerbackview;
@property (weak, nonatomic) IBOutlet UILabel *pickerviewLabel;
@property (weak, nonatomic) IBOutlet UIButton *cerateButtonEmptyview;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeight;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;
@property (weak, nonatomic) IBOutlet UILabel *noexpensesheetSegmentLabel;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (weak, nonatomic) IBOutlet UITableView *CurrentWeekTable;
@property (weak, nonatomic) IBOutlet UIView *addbuttonBackview;
@property (weak, nonatomic) IBOutlet UIView *menuButtonBackview;
@property (weak, nonatomic) IBOutlet UIView *mainview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sheetsListEditButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addNewSheetButtonTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myExpenseSheetsButtonTop;
@property (weak, nonatomic) IBOutlet UILabel *editSheetsTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeListButton;
@property UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIButton *createViewCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;


@end
