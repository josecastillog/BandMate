//
//  Conversation.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/27/22.
//

#import <Parse/Parse.h>
#import "Match.h"

NS_ASSUME_NONNULL_BEGIN

@interface Conversation : PFObject<PFSubclassing>

// Properties
@property (nonatomic, strong) Match *match;
// Methods
+ (Conversation*)initWithMatch:(Match*)match;
- (instancetype)addParticipant:(PFUser*)user;

@end

NS_ASSUME_NONNULL_END
