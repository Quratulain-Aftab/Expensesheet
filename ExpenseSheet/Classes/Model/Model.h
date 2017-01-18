//
//  Model.h
//  ExpenseSheet
//
//  Created by Quratulain on 1/12/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Model : NSObject
+(NSArray *)fetchDataFromTable:(NSString *)tableName;
@end
