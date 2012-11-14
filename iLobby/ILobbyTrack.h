//
//  ILobbyTrack.h
//  iLobby
//
//  Created by Pelaia II, Tom on 10/23/12.
//  Copyright (c) 2012 UT-Battelle ORNL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ILobbyPresentationDelegate.h"
#import "ILobbyTransitionSource.h"

@class ILobbyTrack;
typedef void (^ILobbyTrackCompletionHandler)(ILobbyTrack *);


@interface ILobbyTrack : NSObject

@property (nonatomic, readonly, strong) UIImage *icon;
@property (nonatomic, readonly, copy) NSString *label;
@property (nonatomic, readonly, assign) float defaultSlideDuration;
@property (nonatomic, readonly, strong) NSArray *slides;
@property (nonatomic, readonly, strong) ILobbyTransitionSource *defaultTransitionSource;

- (id)initWithConfiguration:(NSDictionary *)config relativeTo:(NSString *)rootPath;
- (void)presentTo:(id<ILobbyPresentationDelegate>)presenter completionHandler:(ILobbyTrackCompletionHandler)handler;
- (void)cancelPresentation;

@end
