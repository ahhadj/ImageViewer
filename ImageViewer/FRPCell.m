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
@property (nonatomic, strong) RACDisposable* subscription;

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
    
    return self;
}


-(void) setPhotoModel:(PhotoModel *)photoModel{
    self.subscription = [[[RACObserve(photoModel, thumbnailData) filter:^BOOL(id value) {
        return value != nil;
    }] map:^id(id value) {
        return [UIImage imageWithData:value];
    }] setKeyPath:@keypath(self.imageView, image) onObject:self.imageView];
}

-(void) prepareForReuse{
    [super prepareForReuse];
    
    [self.subscription dispose];
    self.subscription = nil;
}

@end
