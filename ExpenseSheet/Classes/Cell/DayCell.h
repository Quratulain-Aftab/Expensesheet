//
//  DayCell.h
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/23/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *receiptimage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end
