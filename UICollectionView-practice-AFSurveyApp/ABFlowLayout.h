//
//  ABFlowLayout.h
//  UICollectionView-practice-AFSurveyApp
//
//  Created by Amitai Blickstein on 10/12/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
    //In the header for other files to use.
#define kMaxItemDimension  200.0f
//#define kMaxItemDimension MAX(CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds)) * 0.9 / 3
#define kMaxItemSize       CGSizeMake(kMaxItemDimension, kMaxItemDimension)

@interface ABFlowLayout : UICollectionViewFlowLayout
@end
