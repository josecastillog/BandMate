//
//  BandsTableViewCell.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/25/22.
//

#import "BandsTableViewCell.h"
#import "Artist.h"
#import "UIImageView+AFNetworking.h"

static NSString *const kEmptyLabel = @"";
static NSString *const kArtistID = @"artistID";
static NSString *const kImageUrl = @"url";
static NSString *const kUpperLabelText = @"Your band with artist:";

@interface BandsTableViewCell()
@property (strong, nonatomic) Conversation *conversation;
@end

@implementation BandsTableViewCell

- (void)setCell:(Conversation*)conversation {
    _conversation = conversation;
    self.shimView.shimmering = NO;
    self.bandNameLabel.backgroundColor = [UIColor clearColor];
    self.bandNameLabel.text = kEmptyLabel;
    self.bandNameLabel.layer.cornerRadius = 0;
    self.upperLabel.backgroundColor = [UIColor clearColor];
    self.upperLabel.text = kUpperLabelText;
    [self setImage];
}

- (void)setShimmering {
    self.shimView.contentView = self.mainView;
    self.shimView.shimmering = YES;
    self.bandNameLabel.backgroundColor = [UIColor lightGrayColor];
    self.bandNameLabel.text = kEmptyLabel;
    self.bandNameLabel.clipsToBounds = YES;
    self.bandNameLabel.layer.cornerRadius = self.bandNameLabel.frame.size.height/2;
    self.upperLabel.backgroundColor = [UIColor lightGrayColor];
    self.upperLabel.text = kEmptyLabel;
    self.upperLabel.clipsToBounds = YES;
    self.upperLabel.layer.cornerRadius = self.bandNameLabel.frame.size.height/2;
    self.bandImgView.backgroundColor = [UIColor lightGrayColor];
    self.bandImgView.layer.cornerRadius = self.bandImgView.frame.size.height/2;
    self.bandImgView.clipsToBounds = YES;
}

- (void)setImage {
    self.bandImgView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    self.bandImgView.layer.cornerRadius = self.bandImgView.frame.size.height/2;
    self.bandImgView.clipsToBounds = YES;
    PFQuery *queryArtist = [Artist query];
    [queryArtist whereKey:kArtistID equalTo:self.conversation.match.artistID];
    [queryArtist findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            Artist *artist = [objects firstObject];
            NSDictionary *image = artist.images[0];
            NSURL *posterURL = [NSURL URLWithString:image[kImageUrl]];
            [self.bandImgView setImageWithURL:posterURL];
            self.bandNameLabel.text = artist.name;
        }
    }];
}

@end
