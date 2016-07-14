//
//  ImageVC.m
//  ShittyFoodPorn
//
//  Created by Candance Smith on 7/14/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "ImageVC.h"
#import "UIImageView+AFNetworking.h"

@interface ImageVC ()

@property (weak, nonatomic) IBOutlet UIImageView *fullImageVIew;

@end

@implementation ImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fullImageVIew.contentMode = UIViewContentModeScaleAspectFit;
    [self.fullImageVIew setImageWithURL:self.imageURL];
}

@end
