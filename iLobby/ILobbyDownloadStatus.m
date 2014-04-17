//
//  ILobbyDownloadItemStatus.m
//  iLobby
//
//  Created by Pelaia II, Tom on 4/3/14.
//  Copyright (c) 2014 UT-Battelle ORNL. All rights reserved.
//

#import "ILobbyDownloadStatus.h"
#import "ILobbyConcurrentDictionary.h"



@interface ILobbyDownloadStatus ()

@property (weak, readwrite) ILobbyDownloadContainerStatus *container;
@property (nonatomic, strong, readwrite) ILobbyStoreRemoteItem *remoteItem;
@property (readwrite) float progress;
@property (readwrite) BOOL completed;

@end



@interface ILobbyDownloadContainerStatus ()

@property (strong) ILobbyConcurrentDictionary *childStatusItems;	// child status items keyed by child status' remote item object ID
- (void)updateProgress;

@end



@implementation ILobbyDownloadStatus

- (instancetype)initWithItem:(ILobbyStoreRemoteItem *)remoteItem container:(ILobbyDownloadContainerStatus *)container {
    self = [super init];
    if (self) {
		self.progress = 0.0;
		self.completed = NO;
        self.remoteItem = remoteItem;
		self.container = container;
		[container addChildStatus:self];
    }
    return self;
}


+ (instancetype)statusForRemoteItem:(ILobbyStoreRemoteItem *)remoteItem container:(ILobbyDownloadContainerStatus *)container {
	return [[self alloc] initWithItem:remoteItem container:container];
}


// determine whether this object's remote item matches (same objectID) the other remote item
- (BOOL)matchesRemoteItem:(ILobbyStoreRemoteItem *)otherRemoteItem {
	if ( self.remoteItem == otherRemoteItem ) {		// pointer identity is sufficient
		return YES;
	}
	else {
		__block NSManagedObjectID *remoteItemID = nil;
		[self.remoteItem.managedObjectContext performBlockAndWait:^{
			remoteItemID = self.remoteItem.objectID;
		}];

		__block NSManagedObjectID *otherRemoteItemID = nil;
		[otherRemoteItem.managedObjectContext performBlockAndWait:^{
			otherRemoteItemID = otherRemoteItem.objectID;
		}];

		return remoteItemID == otherRemoteItemID;
	}
}


- (void)setProgress:(float)progress {
	_progress = progress;

	if ( self.container ) {
		[self.container updateProgress];
	}

	id<ILobbyDownloadStatusDelegate> delegate = self.delegate;
	if ( delegate ) {
		[delegate downloadStatusChanged:self];
	}
}


- (void)setCompleted:(BOOL)completed {
	_completed = completed;

	if ( completed ) {
		// important for the following code to block since marking ready must complete before setting the progress which in turn propagates progress state
		[self.remoteItem.managedObjectContext performBlockAndWait:^{
			[self.remoteItem markReady];
			if ( self.container ) {
				ILobbyStoreRemoteItem *remoteContainer = self.container.remoteItem;
				if ( remoteContainer ) {
					// force any fetched properties of the containing object to refresh
					[self.remoteItem.managedObjectContext refreshObject:remoteContainer mergeChanges:YES];
				}
			}
		}];

		[self setProgress:1.0];
	}
}

@end



@implementation ILobbyDownloadContainerStatus

- (instancetype)initWithItem:(ILobbyStoreRemoteItem *)remoteItem container:(ILobbyDownloadContainerStatus *)container {
	self = [super initWithItem:remoteItem container:container];
	if ( self ) {
		self.submitted = NO;
		self.childStatusItems = [ILobbyConcurrentDictionary new];
	}

	return self;
}


- (void)printChildInfo {
	NSLog( @"Child count: %ld", (long)self.childStatusItems.count );
	for ( NSString *path in self.childStatusItems.dictionary ) {
		NSLog( @"Child Path: %@", path );
	}
}


- (void)setChildrenDelegate:(id<ILobbyDownloadStatusDelegate>)childrenDelegate {
	[self.childStatusItems.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
		ILobbyDownloadStatus *statusItem = (ILobbyDownloadStatus *)object;
		statusItem.delegate = childrenDelegate;
	}];
}


- (void)addChildStatus:(ILobbyDownloadStatus *)childStatus {
	__block NSString *childPath = nil;
	ILobbyStoreRemoteItem *childItem = childStatus.remoteItem;
	[childItem.managedObjectContext performBlockAndWait:^{
		childPath = childItem.path;
	}];
	if ( childPath != nil ) {
		self.childStatusItems[childPath] = childStatus;
		[self updateProgress];
	}
}


- (ILobbyDownloadStatus *)childStatusForRemoteItemPath:(NSString *)path {
	return path != nil ? self.childStatusItems[path] : nil;
}


- (ILobbyDownloadStatus *)childStatusForRemoteItem:(ILobbyStoreRemoteItem *)remoteItem {
	__block NSString *path = nil;
	[remoteItem.managedObjectContext performBlockAndWait:^{
		path = remoteItem.path;
	}];

	return [self childStatusForRemoteItemPath:path];
}


// update the progress as the average of the current progress of each child status
- (void)updateProgress {
	NSInteger childCount = self.childStatusItems.count;

	__block NSInteger completionCount = 0;
	__block float progressSum = 0.0;

	// WARNING: child items may be added after this is called since they get dispatched for download immediately after being added (verify using self.submitted boolean)
	if ( childCount > 0 ) {
		[self.childStatusItems.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
			ILobbyDownloadStatus *statusItem = (ILobbyDownloadStatus *)object;
			progressSum += statusItem.progress;

			// count the number of child items completed
			if ( statusItem.completed ) {
				++completionCount;
			}
		}];

		self.progress = progressSum / childCount;

		if ( _submitted && completionCount == childCount ) {
//			NSLog( @"%@ is complete", self.remoteItem.remoteLocation );
			self.completed = YES;
		}
		else {
//			NSLog( @"%@ completed %ld of %ld", self.remoteItem.remoteLocation, (long)completionCount, (long)childCount );
		}
	}
	else if ( _submitted ) {
		self.completed = YES;
	}

//	NSLog( @"Container progress: %f", self.progress );
}


- (void)setCompleted:(BOOL)completed {
	super.completed = completed;
}

@end



@implementation ILobbyDownloadFileStatus

- (void)setProgress:(float)progress {
	super.progress = progress;
}


- (void)setCompleted:(BOOL)completed {
	super.completed = completed;
}

@end
