//
//  ABFlowLayout.m
//  UICollectionView-practice-AFSurveyApp
//
//  Created by Amitai Blickstein on 10/12/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import "ABFlowLayout.h"
#import "ABDecorationView.h"

NSString * const ABFlowLayoutDecorationViewID = @"DecorationViewID";

@implementation ABFlowLayout {
    NSMutableSet *insertedSectionSet;
}

-(instancetype)init {
    if (!(self = [super init])) return nil;
    
        //Create a basic flow layout that will accomodate 3 columns in portrait
    self.sectionInset            = UIEdgeInsetsMake(30.0f, 80.0f, 30.0f, 20.0f);
    self.minimumInteritemSpacing = 20.0f;
    self.minimumLineSpacing      = 20.0f;
    self.itemSize                = kMaxItemSize;
    self.headerReferenceSize     = CGSizeMake(60, 70);//<--important! default is CGSizeZero, which means they would not be displayed.
    [self registerClass:[ABDecorationView class] forDecorationViewOfKind:ABFlowLayoutDecorationViewID];
 
    insertedSectionSet = [NSMutableSet set];
    
    return self;
}


#pragma mark - === Overridden Methods ===

#pragma mark - Cell Layout

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *newAttributesArray = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        [self applyLayoutAttributes:attributes];
        
        if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
            UICollectionViewLayoutAttributes *newAttributes = [self layoutAttributesForDecorationViewOfKind:ABFlowLayoutDecorationViewID atIndexPath:attributes.indexPath];
            
            [newAttributesArray addObject:newAttributes];
        }
    }
    
    attributesArray = [attributesArray arrayByAddingObjectsFromArray:newAttributesArray];
    
    return attributesArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    [self applyLayoutAttributes:attributes];
    
    return attributes;
}

#pragma mark - Decoration View Layout attributes

-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *decorationViewAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
    if ([decorationViewKind isEqualToString:ABFlowLayoutDecorationViewID]) {
            // We need to identify and grab the tallest cell['s attributes], and make that height
            // the minimum distance between one row and the next.
        UICollectionViewLayoutAttributes *tallestCellAttributes;
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:indexPath.section];
        
        for (NSUInteger i = 0; i < numberOfCellsInSection; i++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:i inSection:indexPath.section];
            
            UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:cellIndexPath];
            
            if (CGRectGetHeight(cellAttributes.frame) > CGRectGetHeight(tallestCellAttributes.frame))
            {
                tallestCellAttributes = cellAttributes;
            }
        }
        
        CGFloat decorationViewHeight = CGRectGetHeight(tallestCellAttributes.frame) + self.headerReferenceSize.height;
        
        decorationViewAttributes.size = CGSizeMake([self collectionViewContentSize].width, decorationViewHeight);
        decorationViewAttributes.center = CGPointMake([self collectionViewContentSize].width / 2.0f, tallestCellAttributes.center.y);
        decorationViewAttributes.frame = CGRectIntegral(decorationViewAttributes.frame);
            // Place the decoration view behind all the cells
        decorationViewAttributes.zIndex = -1;
    }
    return decorationViewAttributes;
}

#pragma mark  ===Animation Support===

-(void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem * _Nonnull updateItem, NSUInteger idx, BOOL * _Nonnull stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            [insertedSectionSet addObject:@(updateItem.indexPathAfterUpdate.section)];
        }
    }];
}

-(void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    
        //We only want the animation to affect the current
        //group of photos.
    [insertedSectionSet removeAllObjects];
}

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath {
        //returning nil will cause a crossfade
    
    UICollectionViewLayoutAttributes *layoutAttributes;
    
    if ([elementKind isEqualToString:ABFlowLayoutDecorationViewID]) {
        if ([insertedSectionSet containsObject:@(decorationIndexPath.section)]) {
            layoutAttributes = [self layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:decorationIndexPath];
            layoutAttributes.alpha = 0.0f;
            layoutAttributes.transform3D = CATransform3DMakeTranslation(-CGRectGetWidth(layoutAttributes.frame), 0, 0);
        }
    }
    
    return layoutAttributes;
}

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
        //returning nil will cause a crossfade
    
    UICollectionViewLayoutAttributes *layoutAttributes;
    
    if ([insertedSectionSet containsObject:@(itemIndexPath.section)]) {
        layoutAttributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        layoutAttributes.transform3D = CATransform3DMakeTranslation([self collectionViewContentSize].width, 0, 0);
    }
    
    return layoutAttributes;
}

#pragma mark - Helper Methods

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes*)attributes {
//representedElementKind == nil only when the element is a Cell: perfect!
//We need to find the center point. We do so by divying up the space equally,
//and putting our cell in the center of that area.
    if (attributes.representedElementKind == nil)
    {
        CGFloat width       = [self collectionViewContentSize].width;
        CGFloat leftMargin  = [self sectionInset].left;
        CGFloat rightMargin = [self sectionInset].right;
        CGFloat availableSpace = width - (leftMargin + rightMargin);
        
        NSUInteger itemsInSection = [[self collectionView] numberOfItemsInSection:attributes.indexPath.section];
        CGFloat firstXPosition = availableSpace / (2 * itemsInSection);
        CGFloat xPosition = firstXPosition + (2 * firstXPosition * attributes.indexPath.item);
        
        attributes.center = CGPointMake(leftMargin + xPosition, attributes.center.y);
        attributes.frame = CGRectIntegral(attributes.frame); //To avoid 1/2-pixels.
    }
}

@end
