//
//  FRPPhotoImporter.h
//  ImageViewer
//
//  Created by dengjun on 5/12/15.
//  Copyright (c) 2015 com.microstrategy.ipad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<ReactiveCocoa/ReactiveCocoa.h>

@class PhotoModel;

@interface FRPPhotoImporter : NSObject

+(RACSignal*) importPhotos;
+(RACReplaySubject*) fetchPhotoDetails:(PhotoModel*) photoModel;

@end
