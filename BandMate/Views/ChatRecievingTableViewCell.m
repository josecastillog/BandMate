//
//  ChatRecievingTableViewCell.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/26/22.
//

#import "ChatRecievingTableViewCell.h"

static CGFloat const kCornerRadius = 19;
static NSString *const kStringFormat = @"%@";

@interface ChatRecievingTableViewCell ()
@end

@implementation ChatRecievingTableViewCell

- (void)setMessage:(Message*)message {
    _message = message;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.bubbleView addGestureRecognizer:tapGesture];
    self.messageLabel.text = self.message.content;
    self.nameLabel.text = self.message.sender.username;
    self.bubbleView.clipsToBounds = YES;
    self.bubbleView.layer.cornerRadius = kCornerRadius;
    self.likeLabel.hidden = YES;
    self.heartImgView.hidden = YES;
    if ([self.message.likeCount intValue] > 0) {
        self.heartImgView.hidden = NO;
        self.likeLabel.hidden = NO;
        self.likeLabel.text = [NSString stringWithFormat:kStringFormat, self.message.likeCount];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
    if (![self.message.usersThatLiked containsObject:PFUser.currentUser.objectId]) {
        [generator impactOccurred];
        self.message.likeCount = [NSNumber numberWithInt:[self.message.likeCount intValue] + 1];
        self.message.usersThatLiked = [self.message.usersThatLiked arrayByAddingObject:PFUser.currentUser.objectId];
    } else {
        [generator impactOccurred];
        NSMutableArray *removeUserArray = [NSMutableArray arrayWithArray:self.message.usersThatLiked];
        [removeUserArray removeObject:PFUser.currentUser.objectId];
        self.message.usersThatLiked = removeUserArray;
        self.message.likeCount = [NSNumber numberWithInt:[self.message.likeCount intValue] - 1];
    }
    [self.message saveInBackground];
    [self setMessage:self.message];
}

@end
