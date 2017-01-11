//
//  SheetCell.h
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/23/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptonLabel;
@property (weak, nonatomic) IBOutlet UIImageView *receiptImage;
@property (weak, nonatomic) IBOutlet UILabel *intervalLabel;

@end
