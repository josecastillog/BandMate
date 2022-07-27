//
//  BandsTableViewCell.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/25/22.
//

#import "BandsTableViewCell.h"
#import "Artist.h"
#import "UIImageView+AFNetworking.h"

@interface BandsTableViewCell()
@property (strong, nonatomic) Conversation *conversation;
@end

@implementation BandsTableViewCell

- (void)setCell:(Conversation*)conversation {
    _conversation = conversation;
    self.bandNameLabel.text = @"";
    self.bandNameLabel.text = conversation.objectId;
}

- (void)setImage {
    self.bandImgView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.bandImgView.layer.cornerRadius = self.bandImgView.frame.size.height/2;
    self.bandImgView.clipsToBounds = YES;
}

@end
