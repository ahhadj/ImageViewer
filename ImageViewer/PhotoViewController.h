//
//  PhotoViewController.h
//  ImageViewer
//
//  Created by dengjun on 5/19/15.
//  Copyright (c) 2015 com.microstrategy.ipad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoModel;

@interface PhotoViewController : UIViewController

-(instancetype) initWithPhotoModel:(PhotoModel*) photoModel index:(NSInteger) photoIndex;

@property (nonatomic, readonly) NSInteger photoIndex;
@property (nonatomic, readonly) PhotoModel* photoModel;

@end
