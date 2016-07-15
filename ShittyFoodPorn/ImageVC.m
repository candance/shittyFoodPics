//
//  ImageVC.m
//  ShittyFoodPorn
//
//  Created by Candance Smith on 7/14/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "ImageVC.h"
#import "UIImageView+AFNetworking.h"

@interface ImageVC () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *fullImageVIew;

@end

@implementation ImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 4.0;
    self.scrollView.contentSize = self.fullImageVIew.image.size;
    self.scrollView.delegate = self;
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.fullImageVIew setImageWithURL:self.imageURL];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.fullImageVIew;
}

@end



