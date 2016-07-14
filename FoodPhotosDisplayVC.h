//
//  FoodPhotosDisplayVC.h
//  ShittyFoodPorn
//
//  Created by Candance Smith on 7/13/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodPhotosDisplayVC : UIViewController

extern NSString *const kBASE_URL;
extern NSString *const kIMAGE_FILE_EXTENSION;

@property (strong, nonatomic) NSArray *photosResults;
@property (strong, nonatomic) NSArray *photosURLStrings;

@end
