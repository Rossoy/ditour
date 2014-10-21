//
//  ILobbyPresentationGroupTableController.h
//  iLobby
//
//  Created by Pelaia II, Tom on 3/12/14.
//  Copyright (c) 2014 UT-Battelle ORNL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILobbyModelContainer.h"
#import "DiTour-Swift.h"

@interface ILobbyPresentationGroupsTableController : UITableViewController <ILobbyModelContainer>

@property (nonatomic, readwrite, strong) MainModel *lobbyModel;

- (IBAction)openGroupURL:(id)sender;
- (IBAction)editGroup:(id)sender;

@end
