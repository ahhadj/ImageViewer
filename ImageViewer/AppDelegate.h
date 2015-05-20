//
//  AppDelegate.h
//  ImageViewer
//
//  Created by dengjun on 5/12/15.
//  Copyright (c) 2015 com.microstrategy.ipad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <500px-iOS-api/PXAPI.h>

#define FRPDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) PXAPIHelper* apiHelper;


@end

