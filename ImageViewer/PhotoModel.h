//
//  PhotoModel.h
//  ImageViewer
//
//  Created by dengjun on 5/12/15.
//  Copyright (c) 2015 com.microstrategy.ipad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

@property(nonatomic,strong)NSString*photoName;
@property(nonatomic,strong)NSNumber*identifier;
@property(nonatomic,strong)NSString*photographerName;
@property(nonatomic,strong)NSNumber*rating;
@property(nonatomic,strong)NSString*thumbnailURL;
@property(nonatomic,strong)NSData*thumbnailData;
@property(nonatomic,strong)NSString*fullsizedURL;
@property(nonatomic,strong)NSData*fullsizedData;

@end
