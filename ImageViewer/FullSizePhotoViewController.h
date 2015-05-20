//
//  FullSizePhotoViewController.h
//  ImageViewer
//
//  Created by dengjun on 5/19/15.
//  Copyright (c) 2015 com.microstrategy.ipad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FullSizePhotoViewController;

@protocol FullSizePhotoViewControllerDelegate <NSObject>

-(void) userDidScroll:(FullSizePhotoViewController*) viewController toPhotoAtIndex:(NSInteger) index;

@end

@interface FullSizePhotoViewController : UIViewController

-(instancetype) initWithPhotoModels:(NSArray*) photoModelArray currentPhotoIndex:(NSInteger)photoIndex;

@property (nonatomic, readonly) NSArray* photoModelArray;
@property (nonatomic, weak) id<FullSizePhotoViewControllerDelegate> delegate;

@end
