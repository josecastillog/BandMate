//
//  ProfileTableCell.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/19/22.
//

#import "ProfileTableCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ProfileTableCell

- (void)setArtist:(Artist*)artist {
    
    _artist = artist;
    self.nameLabel.text = self.artist.name;
    self.followersLabel.text = [NSString stringWithFormat:@"%@", self.artist.followers];
    
    NSDictionary *image = self.artist.images[0];
    NSURL *posterURL = [NSURL URLWithString:image[@"url"]];
    [self.imgView setImageWithURL:posterURL];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.locale = [NSLocale currentLocale];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    self.followersLabel.text = [NSString stringWithFormat:@"%@", [numberFormatter stringForObjectValue:artist.followers]];

    NSString *displayGenres = [NSString string];
    for (NSString *genre in self.artist.genres) {
        if ([genre isEqualToString:[self.artist.genres firstObject]]) {
            displayGenres = genre;
        }
        displayGenres = [NSString stringWithFormat:@"%@, %@", displayGenres, genre];
    }
    self.genresLabel.text = displayGenres;
    
}

@end
