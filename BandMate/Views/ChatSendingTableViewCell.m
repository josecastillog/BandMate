//
//  ChatTableViewCell.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/26/22.
//

#import "ChatSendingTableViewCell.h"

static CGFloat const kCornerRadius = 19;
static NSString *const kStringFormat = @"%@";

@implementation ChatSendingTableViewCell

- (void)setMessage:(Message*)message {
    _message = message;
    self.bubbleView.layer.cornerRadius = kCornerRadius;
    self.bubbleView.clipsToBounds = YES;
    self.messageLabel.text = message.content;
    self.likesLabel.hidden = YES;
    self.heartImgView.hidden = YES;
    if ([self.message.likeCount intValue] > 0) {
        self.heartImgView.hidden = NO;
        self.likesLabel.hidden = NO;
        self.likesLabel.text = [NSString stringWithFormat:kStringFormat, self.message.likeCount];
    }
}

@end
