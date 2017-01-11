//
//  DetailPreviewViewController.h
//  ExpenseSheet
//
//  Created by SISC on 1/3/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DetailPreviewViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *customerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseTypeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseTypeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *billTypeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *billTypeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *ReImburseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ReImburseTextLabel;


@property (weak,nonatomic)NSManagedObject *expenseDetail;
@end
