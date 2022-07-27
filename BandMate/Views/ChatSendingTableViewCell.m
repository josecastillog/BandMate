//
//  ChatTableViewCell.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/26/22.
//

#import "ChatSendingTableViewCell.h"

static CGFloat const kCornerRadius = 19;

@implementation ChatSendingTableViewCell

- (void)setMessage:(NSString*)message {
    self.bubbleView.layer.cornerRadius = kCornerRadius;
    self.bubbleView.clipsToBounds = YES;
    self.messageLabel.text = message;
}

@end
