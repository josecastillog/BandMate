//
//  Artist.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/13/22.
//

#import "Artist.h"

@implementation Artist

@dynamic artistID;
@dynamic name;
@dynamic uri;
@dynamic genres;
@dynamic images;
@dynamic externalURL;
@dynamic followers;

+ (nonnull NSString *)parseClassName {
    return @"Artist";
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    self.artistID = dictionary[@"id"];
    self.name = dictionary[@"name"];
    self.uri = dictionary[@"uri"];
    self.genres = dictionary[@"genres"];
    self.images = dictionary[@"images"];
    self.externalURL = dictionary[@"external_urls"];
    self.followers = [dictionary valueForKeyPath:@"followers.total"];
    return self;
    
}

+(NSArray *)artistsWithArray:(NSArray *)dictionaries {
    
    NSMutableArray *artists = [NSMutableArray array];
    
    for (NSDictionary *dictionary in dictionaries) {
        Artist *artist = [[Artist alloc] initWithDictionary:dictionary];
        [artists addObject:artist];
    }
    
    return artists;
    
}

+ (NSArray *)userGenresWithArray:(NSArray *)artistObjects {
    
    NSMutableArray *arrayOfGenres = [NSMutableArray array];
    
    for (Artist *artist in artistObjects) {
        [arrayOfGenres addObjectsFromArray:artist.genres];
    }
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayOfGenres];
    NSArray *arrayWithoutDuplicates = [orderedSet array];
    
    return arrayWithoutDuplicates;
    
}

+ (NSArray *)userArtistIDsWithArray:(NSArray *)artistObjects {
    
    NSMutableArray *arrayOfArtistID = [NSMutableArray array];
    
    for (Artist *artist in artistObjects) {
        [arrayOfArtistID addObject:artist.artistID];
    }
    
    return arrayOfArtistID;
    
}

@end
