//
//  MatchTableViewCell.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/24/22.
//

#import <UIKit/UIKit.h>
#import "Match.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchTableViewCell : UITableViewCell
//Properties
@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
// Methods
- (void)setCell:(Match*)match;
@end

NS_ASSUME_NONNULL_END
