//
//  Utilities.h
//  AlifIslam
//
//  Created by Syed Ubaidullah on 23/07/2015.
//  Copyright (c) 2015 NineSol Technololgies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject <NSURLSessionDelegate>

+ (Utilities *)shareManager;
- (UIColor *)colorWithHexString:(NSString*)hex;
-(UIColor *)backgroundColor;
@end
