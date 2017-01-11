//
//  DetailViewController.h
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/17/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UIPopoverControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *contentview;
//@property (weak, nonatomic) IBOutlet UIView *dateview;
@property (weak, nonatomic) IBOutlet UIView *dateview;

@property (weak, nonatomic) IBOutlet UIView *projectdetailview;
@property (weak, nonatomic) IBOutlet UIView *infoview;
@property (weak, nonatomic) IBOutlet UIView *switchView;
@property BOOL isFromWeekViewController;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *projectButton;
@property (weak, nonatomic) IBOutlet UIButton *customerButton;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UILabel *billTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIButton *addReceiptButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UIButton *receiptImageButton;

@property  UITableView* expenseTypeTable;
@property UIAlertController *alertcontroller;
@property NSString * expenseCurrentCategory;

@property NSInteger sheetId;
@property NSInteger ItemId;
@property NSInteger mode;
@property NSString *titleText;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UILabel *attchtreceiptLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoviewHeight;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIView *addmoreBackview;
@property (weak, nonatomic) IBOutlet UIButton *addmoreButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *customerEditButton;
@property (weak, nonatomic) IBOutlet UIImageView *customerDisclosure;
@property (weak, nonatomic) IBOutlet UIButton *projectEditButton;
@property (weak, nonatomic) IBOutlet UIImageView *projectDisclosure;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addmoreBottom;
@property (weak, nonatomic) IBOutlet UIView *combineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectviewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectDetailViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet UIView *addreceiptButtonBackView;
@property (weak, nonatomic) IBOutlet UIButton *addreceiptButton;


@end
