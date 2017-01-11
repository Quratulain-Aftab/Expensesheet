//
//  CurrentWeekCell.m
//  ExpenseSheet
//
//  Created by SISC on 12/30/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import "CurrentWeekCell.h"

@implementation CurrentWeekCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.dueThisWeekLabel.layer.borderColor=[UIColor whiteColor].CGColor;
    self.dueThisWeekLabel.layer.borderWidth=1.0;
    self.dueThisWeekLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.dueThisWeekLabel.layer.shadowRadius = 2;
    self.dueThisWeekLabel.layer.shadowOpacity = 0.3;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
