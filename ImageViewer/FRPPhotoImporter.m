//
//  FRPPhotoImporter.m
//  ImageViewer
//
//  Created by dengjun on 5/12/15.
//  Copyright (c) 2015 com.microstrategy.ipad. All rights reserved.
//

#import "FRPPhotoImporter.h"
#import "PhotoModel.h"
#import "AppDelegate.h"


@implementation FRPPhotoImporter

+(RACSignal*)importPhotos{
    NSURLRequest* request = [self popularURLRequest];
    
    return [[[[[[NSURLConnection rac_sendAsynchronousRequest:request] reduceEach:^id(NSURLResponse* response, NSData* data){
        return data;
    }] deliverOn:[RACScheduler mainThreadScheduler]] map:^id(NSData* value) {
        id results = [NSJSONSerialization JSONObjectWithData:value options:0 error:nil];
        return [[[results[@"photos"] rac_sequence] map:^id(NSDictionary* value) {
            PhotoModel* photoModel = [PhotoModel new];
            
            [self configurePhotoModel:photoModel withDictionary:value];
            [self downloadThumbnailForPhotoModel:photoModel];
            return photoModel;
        }] array];
    }] publish] autoconnect];
}

+(NSURLRequest*) popularURLRequest{
    return [FRPDelegate.apiHelper urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular
                                             resultsPerPage:100 page:0 photoSizes:PXPhotoModelSizeThumbnail sortOrder:PXAPIHelperSortOrderRating except:PXPhotoModelCategoryNude];
}

+(void) configurePhotoModel:(PhotoModel*) photoModel withDictionary:(NSDictionary*) dictionary{
    photoModel.photoName = dictionary[@"name"];
    photoModel.identifier = dictionary[@"id"];
    photoModel.photographerName = dictionary[@"user"][@"username"];
    photoModel.rating = dictionary[@"rating"];
    photoModel.thumbnailURL = [self urlForImageSize:3 inArray:dictionary[@"images"]];
    
    if (dictionary[@"comments_count"]) {
        photoModel.fullsizedURL = [self urlForImageSize:4 inArray:dictionary[@"images"]];
    }
}

+(NSString*) urlForImageSize:(NSInteger) size inArray:(NSArray*) array{
    return [[[[[array rac_sequence] filter:^BOOL(NSDictionary* value) {
        return [value[@"size"] integerValue] == size;
    }] map:^id(id value) {
        return value[@"url"];
    }] array] firstObject];
}

+(void)downloadThumbnailForPhotoModel:(PhotoModel*) photoModel{
    RAC(photoModel, thumbnailData) = [self download:photoModel.thumbnailURL];
}

+(void)downLoadFullsizedImageForPhotoModel:(PhotoModel*) photoModel{
    RAC(photoModel, fullsizedData) = [self download:photoModel.fullsizedURL];
}

+(RACSignal*) download:(NSString*) urlString{
    NSAssert(urlString, @"URL must not be nil");
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    return [[[NSURLConnection rac_sendAsynchronousRequest:request] map:^id(RACTuple* value) {
        return [value second];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

+(NSURLRequest*) photoURLRequest:(PhotoModel*) photoModel{
    return [FRPDelegate.apiHelper urlRequestForPhotoID:photoModel.identifier.integerValue];
}

+(RACSignal*) fetchPhotoDetails:(PhotoModel*) photoModel{
    NSURLRequest* request = [self photoURLRequest:photoModel];
    
    return [[[[[[NSURLConnection rac_sendAsynchronousRequest:request] map:^id(RACTuple* value) {
        return [value second];
    }] deliverOn:[RACScheduler mainThreadScheduler]] map:^id(NSData* value) {
        id results = [NSJSONSerialization JSONObjectWithData:value options:0 error:nil][@"photo"];
        [self configurePhotoModel:photoModel withDictionary:results];
        [self downLoadFullsizedImageForPhotoModel:photoModel];
        return photoModel;
    }] publish] autoconnect];
}



@end
