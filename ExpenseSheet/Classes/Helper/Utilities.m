//
//  Utilities.m
//  AlifIslam
//
//  Created by Syed Ubaidullah on 23/07/2015.
//  Copyright (c) 2015 NineSol Technololgies. All rights reserved.
//

#import "Utilities.h"
#import "Constants.h"
//#import "AppDelegate.h"

@implementation Utilities

#pragma mark - Shared

+ (Utilities *)shareManager {
    static Utilities *sharedInstance=nil;
    static dispatch_once_t  oncePredecate;
    
    dispatch_once(&oncePredecate,^{
        sharedInstance = [[Utilities alloc] init];
    });
    return sharedInstance;
}


#pragma mark - Get Color from Hexa code

- (UIColor *)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
-(UIColor *)backgroundColor
{
    UIColor *color=[UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:0.7];
    return color;
}
@end
