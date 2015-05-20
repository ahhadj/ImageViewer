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
    RACReplaySubject* subject = [RACReplaySubject subject];
    
    NSURLRequest* request = [self popularURLRequest];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (data){
                                   id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   
                                   [subject sendNext:[[[results[@"photos"] rac_sequence] map:^id(NSDictionary* photoDictionary) {
                                       PhotoModel* model = [PhotoModel new];
                                       
                                       [self configurePhotoModel:model withDictionary:photoDictionary];
                                       [self downloadThumbnailForPhotoModel:model];
                                       
                                       return model;
                                   }] array]];
                                   [subject sendCompleted];
                               }else{
                                   [subject sendError:connectionError];
                               }
                               
                           }];
    
    return subject;
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
   /* NSAssert(photoModel.thumbnailURL, @"Thumbnail URL must not be nil.");
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:photoModel.thumbnailURL]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        photoModel.thumbnailData = data;
    }];*/
    
    [self download:photoModel.thumbnailURL withCompletion:^(NSData *data) {
        photoModel.thumbnailData = data;
    }];
}

+(void)downLoadFullsizedImageForPhotoModel:(PhotoModel*) photoModel{
    [self download:photoModel.fullsizedURL withCompletion:^(NSData* data){
        photoModel.fullsizedData = data;
    }];
}

+(void) download:(NSString*) urlString withCompletion:(void(^)(NSData* data)) complection{
    NSAssert(urlString, @"URL must not be nil");
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (complection){
            complection(data);
        }
    }];
}

+(NSURLRequest*) photoURLRequest:(PhotoModel*) photoModel{
    return [FRPDelegate.apiHelper urlRequestForPhotoID:photoModel.identifier.integerValue];
}

+(RACReplaySubject*) fetchPhotoDetails:(PhotoModel*) photoModel{
    RACReplaySubject* subject = [RACReplaySubject subject];
    
    NSURLRequest* request = [self photoURLRequest:photoModel];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data){
                                   id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"photo"];
                                   
                                   [self configurePhotoModel:photoModel withDictionary:results];
                                   [self downLoadFullsizedImageForPhotoModel:photoModel];
                                   
                                   [subject sendNext:photoModel];
                                   [subject sendCompleted];
                               }else{
                                   [subject sendError:connectionError];
                               }
    }];
    
    return subject;
}



@end
