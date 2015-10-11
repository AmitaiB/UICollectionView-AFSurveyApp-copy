//
//  ABCollectionViewCell.h
//  UICollectionView-practice-AFSurveyApp
//
//  Created by Amitai Blickstein on 10/11/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

-(void)setDisabled:(BOOL)disabled;

@end
