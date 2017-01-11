//
//  CurrentWeekCell.h
//  ExpenseSheet
//
//  Created by SISC on 12/30/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentWeekCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dueThisWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end
