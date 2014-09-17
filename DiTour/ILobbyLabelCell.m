//
//  ILobbyLabelCell.m
//  iLobby
//
//  Created by Pelaia II, Tom on 4/24/14.
//  Copyright (c) 2014 UT-Battelle ORNL. All rights reserved.
//

#import "ILobbyLabelCell.h"


@implementation ILobbyLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
	[super awakeFromNib];
    // Initialization code
	self.subtitle = nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)defaultHeight {
	return 44;
}


- (void)setMarked:(BOOL)marked {
	static UIColor *markedColor = nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		markedColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
	});

	self.titleLabel.textColor = marked ? markedColor : [UIColor blackColor];
}


- (void)setTitle:(NSString *)title {
	self.titleLabel.text = title;
}


- (void)setSubtitle:(NSString *)subtitle {
	self.subtitleLabel.text = subtitle;
}

@end
