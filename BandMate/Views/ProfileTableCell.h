//
//  ProfileTableCell.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/19/22.
//

#import <UIKit/UIKit.h>
#import "Artist.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (strong, nonatomic) Artist *artist;
@end

NS_ASSUME_NONNULL_END
