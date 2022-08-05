//
//  BandsTableViewCell.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/25/22.
//

#import "BandsTableViewCell.h"
#import "Artist.h"
#import "UIImageView+AFNetworking.h"

static NSString *const emptyLabel = @"";

@interface BandsTableViewCell()
@property (strong, nonatomic) Conversation *conversation;
@end

@implementation BandsTableViewCell

- (void)setCell:(Conversation*)conversation {
    _conversation = conversation;
    self.shimView.shimmering = NO;
    self.bandNameLabel.backgroundColor = [UIColor clearColor];
    self.bandNameLabel.text = emptyLabel;
    self.bandNameLabel.text = conversation.objectId;
}

- (void)setShimmering {
    self.shimView.contentView = self.mainView;
    self.shimView.shimmering = YES;
    self.bandNameLabel.backgroundColor = [UIColor lightGrayColor];
    self.bandNameLabel.text = emptyLabel;
    self.bandNameLabel.clipsToBounds = YES;
    self.bandNameLabel.layer.cornerRadius = self.bandNameLabel.frame.size.height/2;
    self.imageView.backgroundColor = [UIColor lightGrayColor];
    self.bandImgView.layer.cornerRadius = self.bandImgView.frame.size.height/2;
    self.bandImgView.clipsToBounds = YES;
}

- (void)setImage {
    self.bandImgView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.bandImgView.layer.cornerRadius = self.bandImgView.frame.size.height/2;
    self.bandImgView.clipsToBounds = YES;
}

@end
