//
//  AppDelegate.m
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/17/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "WeekExpensesViewController.h"
@interface AppDelegate ()
@end
@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
#pragma mark Application Delegate Methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 3D touch handling on home screen app icon
//    UIApplicationShortcutIcon * photoIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"disclosure.png"]; // your customize icon
    UIApplicationShortcutItem * photoItem = [[UIApplicationShortcutItem alloc]initWithType: @"Due this week" localizedTitle: @"Pending this week" localizedSubtitle: nil icon: [UIApplicationShortcutIcon iconWithType: UIApplicationShortcutIconTypeUpdate] userInfo: nil];
    UIApplicationShortcutItem * videoItem = [[UIApplicationShortcutItem alloc]initWithType: @"Create New Expense Sheet" localizedTitle: @"New Expense Sheet" localizedSubtitle: nil icon: [UIApplicationShortcutIcon iconWithType: UIApplicationShortcutIconTypeAdd] userInfo: nil];
    
    [UIApplication sharedApplication].shortcutItems = @[photoItem,videoItem];
    UIApplicationShortcutItem *shortcutItem = [launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
    
    // notifications handling
    [self registerForLocalNotifications];
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification)
    {
        [self handleNotification:notification];
    }
    application.applicationIconBadgeNumber = 0;

    
    
    return ![self handleShortCutItem:shortcutItem];


    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about  ,,to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AppDidBecomeActiveNotification object:nil userInfo:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    [self handleShortCutItem:shortcutItem];
}
#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ExpenseSheet" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ExpenseSheet.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark - Local Notifications
- (void)registerForLocalNotifications
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                            settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound
                                            categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}
- (void)handleNotification:(UILocalNotification *)notification {
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
//        RemindMeViewController *rootController = (RemindMeViewController *)self.window.rootViewController;
//        [rootController showReminder:notification];
    }
}
#pragma mark Handle peek
- (BOOL)handleShortCutItem:(UIApplicationShortcutItem *)shortcutItem {
    BOOL handled = NO;
    
    if (shortcutItem == nil) {
        return handled;
    }
    
    handled = YES;
    
    return handled;
    
}
@end
