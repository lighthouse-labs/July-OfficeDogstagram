//
//  ViewController.m
//  OfficeDogFinder
//
//  Created by Ian MacKinnon on 2015-07-16.
//  Copyright (c) 2015 Ian MacKinnon. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "DogCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface ViewController (){
    NSMutableArray *officeDogs;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    officeDogs = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api.instagram.com/v1/tags/officedogs/media/recent?client_id=0ef2700dfbb5430e8a55981871e8ac5a" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        for (NSDictionary *media in [responseObject objectForKey:@"data"]){
            [officeDogs addObject: [media valueForKeyPath:@"images.standard_resolution.url"]];
        }
        
        [self.puppyView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return [officeDogs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    NSString *imageUrl = [officeDogs objectAtIndex:indexPath.row];
    DogCollectionViewCell *cell = [self.puppyView dequeueReusableCellWithReuseIdentifier:@"DogCell" forIndexPath:indexPath];
    
    [cell.dogImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *imageUrl = [officeDogs objectAtIndex:indexPath.row];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"clicked" message:imageUrl delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    [alertView show];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        UICollectionReusableView *headerView = [self.puppyView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

@end
