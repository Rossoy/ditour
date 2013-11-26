//
//  ILobbyStoreMain.h
//  iLobby
//
//  Created by Pelaia II, Tom on 11/20/13.
//  Copyright (c) 2013 UT-Battelle ORNL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILobbyStorePresentation, ILobbyStoreTrackConfiguration;

@interface ILobbyStoreUserConfig : NSManagedObject

@property (nonatomic, retain) ILobbyStorePresentation *defaultPresentation;
@property (nonatomic, retain) ILobbyStoreTrackConfiguration *configuraton;


+ (instancetype)insertNewUserConfigInContext:(NSManagedObjectContext *)managedObjectContext;

@end
