//
//  SettingBackgroundViewController.m
//  ExpenseSheet
//
//  Created by Quratulain on 1/10/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "SettingBackgroundViewController.h"
#import "BackgroundCollectionViewCell.h"

@interface SettingBackgroundViewController ()

@end

@implementation SettingBackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"BackgroundCell";
    
    BackgroundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
  //  UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    cell.backgroundColor=[UIColor grayColor];
   // recipeImageView.image = [UIImage imageNamed:[recipeImages objectAtIndex:indexPath.row]];
    
    return cell;
}
@end
