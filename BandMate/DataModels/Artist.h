//
//  Artist.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/13/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Artist : PFObject<PFSubclassing>

// Properties

@property (nonatomic, strong) NSString *artistID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uri;
@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *externalURL;
@property (nonatomic, strong) NSNumber *followers;

// Methods
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)artistsWithArray:(NSArray *)dictionaries;
+ (NSArray *)userGenresWithArray:(NSArray *)artistObjects;
+ (NSArray *)userArtistIDsWithArray:(NSArray *)artistObjects;

@end

NS_ASSUME_NONNULL_END
