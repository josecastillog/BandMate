//
//  ChatRecievingTableViewCell.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/26/22.
//

#import "ChatRecievingTableViewCell.h"

static CGFloat const kCornerRadius = 19;

@implementation ChatRecievingTableViewCell

- (void)setMessage:(NSString*)message {
    self.messageLabel.text = message;
    self.bubbleView.clipsToBounds = YES;
    self.bubbleView.layer.cornerRadius = kCornerRadius;
}

@end
