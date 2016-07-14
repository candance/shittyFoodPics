//
//  FoodThumbnailPhotoCell.m
//  ShittyFoodPorn
//
//  Created by Candance Smith on 7/13/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "FoodThumbnailPhotoCell.h"

@implementation FoodThumbnailPhotoCell

- (void)prepareForReuse {
    self.thumbnailPhotoView.image = nil;
}

@end
