//
//  BandsTableViewCell.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/25/22.
//

#import "BandsTableViewCell.h"
#import "Artist.h"
#import "UIImageView+AFNetworking.h"

// Artist table keys
static NSString *const artistID = @"artistID";
// Image key
static NSString *const imageKey = @"url";

@interface BandsTableViewCell()
@property (strong, nonatomic) Match *match;
@property (strong, nonatomic)Artist *artist;
@end

@implementation BandsTableViewCell

- (void)setCell:(Match*)match {
    
    _match = match;
    self.bandNameLabel.text = @"";
    
    PFQuery *query = [Artist query];
    [query whereKey:artistID equalTo:match.artistID];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error loading artist: %@", [error localizedDescription]);
        } else {
            self.artist = [objects firstObject];
            self.bandNameLabel.text = self.artist.name;
            [self setImage];
        }
    }];
    
}

- (void)setImage {
    self.bandImgView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.bandImgView.layer.cornerRadius = self.bandImgView.frame.size.height/2;
    self.bandImgView.clipsToBounds = YES;
    NSDictionary *image = [self.artist.images firstObject];
    NSURL *posterURL = [NSURL URLWithString:image[imageKey]];
    [self.bandImgView setImageWithURL:posterURL];
}

@end
