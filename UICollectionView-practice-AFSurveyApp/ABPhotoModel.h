//
//  ABPhotoModel.h
//  UICollectionView-practice-AFSurveyApp
//
//  Created by Amitai Blickstein on 10/11/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABPhotoModel : NSObject

+(instancetype)photoModelWithName:(NSString *)name image:(UIImage*)image;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIImage *image;

@end
