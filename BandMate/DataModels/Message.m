//
//  Message.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/27/22.
//

#import "Message.h"

static NSString *const kClassName = @"Message";
static NSString *const kMessageSender = @"sender";
static NSString *const kMessageContent = @"content";
static NSString *const kLikeCount = @"likeCount";
static NSString *const kUsersThatLiked = @"usersThatLiked";
static NSNumber *const kIntitLikeCount = @0;

@implementation Message

@dynamic createdAt;
@dynamic sender;
@dynamic conversation;
@dynamic content;
@dynamic likeCount;
@dynamic usersThatLiked;

+ (nonnull NSString *)parseClassName {
    return kClassName;
}

+ (Message*)initWithContent:(Conversation*)conversation :(NSString*)content {
    Message *message = [[Message alloc] init];
    message.content = content;
    message.sender = PFUser.currentUser;
    message.conversation = conversation;
    message.likeCount = kIntitLikeCount;
    message.usersThatLiked = [NSArray array];
    return message;
}

+ (Message*)initWithPFObject:(PFObject*)object {
    Message *message = [[Message alloc] init];
    PFUser *user = [object objectForKey:kMessageSender];
    message.objectId = object.objectId;
    message.sender = user;
    message.content = [object objectForKey:kMessageContent];
    message.likeCount = [object objectForKey:kLikeCount];
    message.usersThatLiked = [object objectForKey:kUsersThatLiked];
    [user fetchIfNeeded];
    return message;
}

@end
