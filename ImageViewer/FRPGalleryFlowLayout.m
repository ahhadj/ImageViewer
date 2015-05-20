//
//  FRPGalleryFlowLayout.m
//  ImageViewer
//
//  Created by dengjun on 5/15/15.
//  Copyright (c) 2015 com.microstrategy.ipad. All rights reserved.
//

#import "FRPGalleryFlowLayout.h"

@implementation FRPGalleryFlowLayout

-(instancetype) init{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(145, 145);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    return self;
}

@end
