//
//  BandMateProfileViewController.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 8/4/22.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface BandMateProfileViewController : UIViewController
@property (strong, nonatomic) PFUser *user;
@end

NS_ASSUME_NONNULL_END
