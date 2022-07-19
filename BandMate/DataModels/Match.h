//
//  Match.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/17/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Match : PFObject<PFSubclassing>

// Properties
@property (nonatomic, strong) NSString *artistID;
@property (nonatomic, strong) NSString *expertiseLevel;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSNumber *numberOfMembers;
@property BOOL hasSinger;
@property BOOL hasGuitarist;
@property BOOL hasDrummer;
@property BOOL hasBassist;
@property BOOL isActive;

// Methods
+ (void)startMatching;

@end

NS_ASSUME_NONNULL_END
