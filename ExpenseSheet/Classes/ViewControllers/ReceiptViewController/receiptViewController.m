//
//  receiptViewController.m
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 12/8/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import "receiptViewController.h"
#import "Utilities.h"

@interface receiptViewController ()

@end

@implementation receiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleView.backgroundColor=[[Utilities shareManager] backgroundColor];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
    self.receiptImage.image=[UIImage imageNamed:@"receipt.jpg"];
    //self.receiptImage.image=self.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)closeButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)shareButtonAction:(id)sender
{
    
  //  NSString *textToShare1 = @"I just found this beautiful app   \"Urdu Quran\" on Appstore. Download Free Now: ";
    
    UIImage *image =self.receiptImage.image;
    
    NSArray *objectsToShare = @[image];
    
    UIActivityViewController *activityViewController =
    
    [[UIActivityViewController alloc] initWithActivityItems:objectsToShare
     
                                      applicationActivities:nil];
    
    if ( [activityViewController respondsToSelector:@selector(popoverPresentationController)] ) {
        
        // iOS8
        
        activityViewController.popoverPresentationController.sourceView = self.view;
        
    }
    
    
    [activityViewController setValue:@"Expense Sheet" forKey:@"subject"];
    
    
    
    //if iPhone
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        [self presentViewController:activityViewController
         
                           animated:YES
         
                         completion:^{
                             
                             // ...
                             
                         }];    }
    
    //if iPad
    
    else
    {
        
        // Change Rect to position Popover
        
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        
        [popup presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections: UIPopoverArrowDirectionDown animated:YES];
        
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
