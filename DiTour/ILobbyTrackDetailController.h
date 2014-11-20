//
//  ILobbyTrackDetailController.h
//  iLobby
//
//  Created by Pelaia II, Tom on 4/24/14.
//  Copyright (c) 2014 UT-Battelle ORNL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ILobbyDownloadStatus.h"
#import "DiTour-Swift.h"


@interface ILobbyTrackDetailController : UITableViewController <DitourModelContainer>

@property (nonatomic) DitourModel *ditourModel;
@property (nonatomic, strong) TrackStore *track;
@property (nonatomic, strong) DownloadContainerStatus *trackDownloadStatus;

@end
