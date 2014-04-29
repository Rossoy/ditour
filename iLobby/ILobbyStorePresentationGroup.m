//
//  ILobbyStorePresentationGroup.m
//  iLobby
//
//  Created by Pelaia II, Tom on 3/10/14.
//  Copyright (c) 2014 UT-Battelle ORNL. All rights reserved.
//

#import "ILobbyStorePresentationGroup.h"
#import "ILobbyRemoteDirectory.h"
#import "ILobbyModel.h"
#import "ILobbyStorePresentation.h"

@implementation ILobbyStorePresentationGroup

@dynamic presentations;
@dynamic root;


+ (instancetype)insertNewPresentationGroupInContext:(NSManagedObjectContext *)managedObjectContext {
    ILobbyStorePresentationGroup *group = [NSEntityDescription insertNewObjectForEntityForName:@"PresentationGroup" inManagedObjectContext:managedObjectContext];

	// generate a unique path for the group based on the timestamp when the group was created
	NSDateFormatter *formatter = [NSDateFormatter new];
	formatter.dateFormat = @"yyyyMMdd'-'HHmmss";
	NSString *basePath = [NSString stringWithFormat:@"Group-%@", [formatter stringFromDate:[NSDate date]]];
	group.path = [[ILobbyModel presentationGroupsRoot] stringByAppendingPathComponent:basePath];
//	NSLog( @"group path: %@", group.path );

	return group;
}


- (NSString *)shortName {
	return [self.remoteLocation lastPathComponent];
}


- (NSArray *)pendingPresentations {
	return [self fetchPresentationsWithFormat:@"(group = %@) AND status = 0 OR status = 1"];
}


- (NSArray *)activePresentations {
	return [self fetchPresentationsWithFormat:@"(group = %@) AND status = 2"];
}


- (NSArray *)fetchPresentationsWithFormat:(NSString *)format {
	NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:[ILobbyStorePresentation entityName]];
	fetch.predicate = [NSPredicate predicateWithFormat:format argumentArray:@[self]];
	fetch.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
	return [self.managedObjectContext executeFetchRequest:fetch error:nil];
}

@end