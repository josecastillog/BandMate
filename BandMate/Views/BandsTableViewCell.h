//
//  BandsTableViewCell.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/25/22.
//

#import <UIKit/UIKit.h>
#import "Match.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface BandsTableViewCell : UITableViewCell
// Properties
@property (weak, nonatomic) IBOutlet PFImageView *bandImgView;
@property (weak, nonatomic) IBOutlet UILabel *bandNameLabel;
// Methods
- (void)setCell:(Match*)match;
@end

NS_ASSUME_NONNULL_END