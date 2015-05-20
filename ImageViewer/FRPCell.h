//
//  FRPCell.h
//  ImageViewer
//
//  Created by dengjun on 5/15/15.
//  Copyright (c) 2015 com.microstrategy.ipad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoModel;

@interface FRPCell : UICollectionViewCell

//-(void) setPhotoModel:(PhotoModel*) photoModel;

@property (nonatomic, strong) PhotoModel* photoModel;

@end
