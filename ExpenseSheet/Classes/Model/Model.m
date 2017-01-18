//
//  Model.m
//  ExpenseSheet
//
//  Created by Quratulain on 1/12/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "Model.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Constants.h"

@implementation Model
#pragma mark -
#pragma mark === Core Data ===
#pragma mark -
+ (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
+(NSArray *)fetchDataFromTable:(NSString *)tableName
{
    NSManagedObjectContext *managedObjectContext = [Model managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:tableName];
    NSArray*  dataArray = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return dataArray;
}
+(NSArray *)fetchDataFromTable:(NSString *)tableName withPredicateName:(NSString *)predicateField andValue:(NSString *)predicateValue
{
    NSManagedObjectContext *managedObjectContext = [Model managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:tableName];
    NSArray*  dataArray = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return dataArray;
}
@end
