//
//  Constants.h
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/21/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define APP_NAME @"Expenese Sheet"
// Group name
#define AppGroupName                  @"group.DeveloperTestAppGroup"
//blur rgb
#define R 131.0
#define G 162.0
#define B 170.0

#define isBackFromWeekView              @"isBackFromWeekView" // bool
#define isBackFromDetailView            @"isBackFromDetailView" // bool


// Entities
#define ExpenseSheetTable               @"ExpenseSheet"
#define ExpenseSheetDetailTable         @"ExpenseSheetDetail"
// Attributes
// expensesheeet
#define SheetId                         @"id"
#define SheetDescription                @"sheetDescription"
#define StartDate                       @"date"
#define Status                          @"status"
//expensesheetdetail
#define ExpenseDate                     @"expenseDate"
#define BillType                        @"billType"
#define CustomerName                    @"customerName"
#define DetailDescription               @"detailDescription"
#define ExpenseType                     @"expenseType"
#define ForeignKey                      @"foreignKey"
#define DetailId                        @"id"
#define ProjectName                     @"projectName"
#define Receipt                         @"receipt"
#define ReImburse                       @"reImburse"
#define Amount                          @"expenseAmount"
// Notifications Names
#define AppDidBecomeActiveNotification  @"AppDidBecomeActiveNotification"

#pragma mark - File Names
#define SettingsFileName                @"Settings.plist"

#pragma mark - Settings Keys
#define WeekStartDay                     @"startWeekDay"
#define NotificationDay                  @""
#endif /* Constants_h */
