//
//  FoodPhotosDisplayVC.m
//  ShittyFoodPorn
//
//  Created by Candance Smith on 7/13/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "FoodPhotosDisplayVC.h"
#import "FoodThumbnailPhotoCell.h"
#import "ImageVC.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface FoodPhotosDisplayVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, retain) UIColor *barTintColor;

@end

@implementation FoodPhotosDisplayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor purpleColor];
    [self.refreshControl addTarget:self action:@selector(makeImgurRequests) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;

    [self makeImgurRequests];
}

#define ImgurAPIKey @"3b73e207093f0c4"
#define IMGUR_PHOTO_URL @"link"
#define IMGUR_PHOTO_TITLE @"title"
//NSString *const kBASE_URL = @"http://i.imgur.com/";
//NSString *const kIMAGE_FILE_EXTENSION = @".jpg";

- (void)makeImgurRequests {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
    spinner.hidesWhenStopped = YES;
    spinner.hidden = NO;
    
    [spinner startAnimating];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"Client-ID 3b73e207093f0c4" forHTTPHeaderField:@"Authorization"];
    [manager GET:@"https://api.imgur.com/3/gallery/r/shittyfoodporn" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *photosTopLevelResults = (NSDictionary *)responseObject;
        self.photosResults = [photosTopLevelResults objectForKey:@"data"];
        NSLog(@"Photos Results:%@", self.photosResults);
        self.photosURLStrings = [self.photosResults valueForKeyPath:IMGUR_PHOTO_URL];
        [spinner stopAnimating];
        [self.refreshControl endRefreshing];
        [self.collectionView reloadData];

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photosURLStrings.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Food Photo Cell";
    
    FoodThumbnailPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *imageURLString = self.photosURLStrings[indexPath.row];
    
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageURL];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [cell.thumbnailPhotoView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"poop"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        cell.thumbnailPhotoView.image = image;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        
        [cell.thumbnailPhotoView.layer addAnimation:transition forKey:nil];
        
    } failure:nil];
    
    return cell;
}

#pragma segue

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"Display Chosen Image" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Display Chosen Image"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        ImageVC *ivc = [segue destinationViewController];
        ivc.imageURL = [NSURL URLWithString:self.photosURLStrings[indexPath.row]];
        NSArray *photoTitle = [self.photosResults valueForKeyPath:IMGUR_PHOTO_TITLE];
        ivc.title = photoTitle[indexPath.row];
    }
}

@end
