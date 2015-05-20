//
//  FRPCell.m
//  ImageViewer
//
//  Created by dengjun on 5/15/15.
//  Copyright (c) 2015 com.microstrategy.ipad. All rights reserved.
//

#import<ReactiveCocoa/ReactiveCocoa.h>
#import<libextobjc/EXTScope.h>
#import<500px-iOS-api/PXAPI.h>

#import "FRPCell.h"
#import "PhotoModel.h"


@interface FRPCell()

@property (nonatomic, weak) UIImageView* imageView;

@end

@implementation FRPCell

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor darkGrayColor];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    RAC(self.imageView, image) = [[RACObserve(self, photoModel.thumbnailData) ignore:nil] map:^id(id value) {
        return [UIImage imageWithData:value];
    }];
    
    return self;
}

@end
