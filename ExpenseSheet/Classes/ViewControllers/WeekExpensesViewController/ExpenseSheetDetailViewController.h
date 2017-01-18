//
//  ExpenseSheetDetailViewController.h
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/23/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ExpenseSheetDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UISearchControllerDelegate,UISearchDisplayDelegate>
@property (strong, nonatomic) IBOutlet UIView *emptyTableView;

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *weeklyTable;
@property (weak, nonatomic) IBOutlet UIView *addRowBackview;

@property (weak, nonatomic) IBOutlet UIButton *addbutton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (strong, nonatomic) IBOutlet UIView *customersListView;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet UILabel *listTitle;



@property (weak, nonatomic) IBOutlet UICollectionView *infoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *receiptCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *infoListCloseButton;
@property (weak, nonatomic) IBOutlet UIView *infoDescriptionView;
@property (weak, nonatomic) IBOutlet UIView *dateListDescriptionView;
@property (weak, nonatomic) IBOutlet UITableView *dateListTable;
@property (strong, nonatomic) IBOutlet UIView *dateListView;
@property (weak, nonatomic) IBOutlet UIButton *datesListCloseButton;
@property (weak, nonatomic) IBOutlet UITableView *receiptsTable;
@property (weak, nonatomic) IBOutlet UIButton *receiptsViewCloseButton;
@property (weak, nonatomic) IBOutlet UIView *receiptsListDescriptionView;
@property (strong, nonatomic) IBOutlet UIView *receiptsListView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeight;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property   UISearchBar *searchbar;
@property NSString *titleText;
@property NSInteger sheetId;
@property NSInteger itemId;
@property NSString *detailTitleText;
@property int mode;
@property BOOL shouldPresentDetailVC;
@property BOOL isNewSheet;

@end
