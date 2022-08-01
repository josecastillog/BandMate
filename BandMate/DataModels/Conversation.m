//
//  Conversation.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/27/22.
//

#import "Conversation.h"

static NSString *const kRelationConversation = @"participants";
static NSString *const kClassName = @"Conversation";

@implementation Conversation
@dynamic match;

+ (nonnull NSString *)parseClassName {
    return kClassName;
}

+ (Conversation*)initWithMatch:(Match*)match {
    Conversation *conversation = [[Conversation alloc] init];
    conversation.match = match;
    return conversation;
}

- (instancetype)addParticipant:(PFUser*)user {
    PFRelation *relation = [self relationForKey:kRelationConversation];
    [relation addObject:user];
    return self;
}

@end
