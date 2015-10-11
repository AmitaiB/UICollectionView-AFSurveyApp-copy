//
//  ABSelectionModel.h
//  UICollectionView-practice-AFSurveyApp
//
//  Created by Amitai Blickstein on 10/11/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSUInteger ABSectionModelNoSelectionIndex;

@interface ABSectionModel : NSObject

+(instancetype)sectionModelWithPhotoModels:(NSArray *)photoModels;

@property (nonatomic, strong, readonly) NSArray *photoModels;
@property (nonatomic, assign) NSUInteger selectedPhotoModelIndex;
@property (nonatomic, readonly) BOOL hasBeenSelected;

@end
