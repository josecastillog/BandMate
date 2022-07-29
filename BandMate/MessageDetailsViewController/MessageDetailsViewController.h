//
//  MessageDetailsViewController.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/29/22.
//

#import <UIKit/UIKit.h>
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageDetailsViewController : UIViewController
@property (strong, nonatomic) Message *message;
@end

NS_ASSUME_NONNULL_END
