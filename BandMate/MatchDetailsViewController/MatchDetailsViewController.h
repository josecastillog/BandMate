//
//  MatchDetailsViewController.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/24/22.
//

#import "ViewController.h"
#import "Match.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MatchDetailsViewControllerDelegate
- (void)didTapAcceptDeclineButton:(Match *)match;
@end

@interface MatchDetailsViewController : ViewController
@property (strong, nonatomic) Match *match;
@property (weak, nonatomic) id<MatchDetailsViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
