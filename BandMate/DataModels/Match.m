//
//  Match.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/17/22.
//

#import "Match.h"
#import "Artist.h"

// Class name
static NSString *const kClassName = @"Match";
// Query parameters
static int const kQueryLimit = 200;
// Max and min number of members a Match can have
static NSNumber *const kMaxMembers = @4;
static NSNumber *const kMinMembers = @1;
// Types of instruments
static NSArray *const kInstrumentTypeArray = @[@"Guitar", @"Drums", @"Singer", @"Bass"];
// User table keys
static NSString *const kUserMatchesRelation = @"Matches";
static NSString *const kUserInstrumentType = @"instrumentType";
static NSString *const kUserExpertiseLevel = @"expertiseLevel";
static NSString *const kuserFavArtists = @"fav_artists";
// Match table keys
static NSString *const kMatchMembersRelation = @"members";
static NSString *const kMatchArtistID = @"artistID";
static NSString *const kMatchNumberOfMembers = @"numberOfMembers";
static NSString *const kMatchExpertiseLevel = @"expertiseLevel";

@interface Match ()
+ (Match*)createNewMatch:(NSString*)artist;
+ (Match*)updateExistingMatch:(Match*)match;
+ (Instrument)instrumentTypeStringToEnum:(NSString*)strVal;
+ (void)checkMatchExists:(NSArray*)retrievedMatches :(NSArray*)currentUserArtists :(NSArray*)currentUserMatches;
+ (void)saveMatches:(NSArray*)matches;
@end

@implementation Match

@dynamic artistID;
@dynamic expertiseLevel;
@dynamic users;
@dynamic numberOfMembers;
@dynamic hasSinger;
@dynamic hasGuitarist;
@dynamic hasDrummer;
@dynamic hasBassist;
@dynamic isActive;

+ (nonnull NSString *)parseClassName {
    return kClassName;
}

+ (void)startMatching {
    
    NSArray *currentUserArtists = [PFUser.currentUser objectForKey:kuserFavArtists];
    
    // Queries matches of user and matches in progress of user's favorite artists
    PFQuery *query = [Match query];
    
    [query whereKey:kMatchArtistID containedIn:currentUserArtists];
    [query whereKey:kMatchNumberOfMembers lessThan:kMaxMembers];
    [query whereKey:kMatchExpertiseLevel equalTo: [PFUser.currentUser objectForKey:kUserExpertiseLevel]];
    [query setLimit:kQueryLimit];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<Match *> * _Nullable retrievedMatches, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error loading existing matches: %@", [error localizedDescription]);
        } else {
            PFRelation *relation = [PFUser.currentUser relationForKey:kUserMatchesRelation];
            PFQuery *query = [relation query];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable currentUserMatches, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error loading user's existing matches: %@", [error localizedDescription]);
                } else {
                    NSLog(@"Successfully loaded user's existing matches");
                    [self checkMatchExists:retrievedMatches :currentUserArtists :currentUserMatches];
                }
            }];
        }
    }];
    
}

+ (void)checkMatchExists:(NSArray*)retrievedMatches :(NSArray*)currentUserArtists :(NSArray*)currentUserMatches {
    
    // Matches to be posted
    NSMutableArray *matches = [NSMutableArray array];
    
    // Array for matches not currently in progress by the user
    NSMutableArray *artistsNotInCurrentMatches = [NSMutableArray array];
    
    if (currentUserMatches.count != 0) {
        // Check if user has a match in progress with the artist already
        for (NSString *artist in currentUserArtists) {
                for (Match *match in currentUserMatches) {
                        if ([match.artistID isEqualToString:artist]) {
                            break;
                        } else if ([match isEqual:[currentUserMatches lastObject]]) {
                            [artistsNotInCurrentMatches addObject:artist];
                        }
                }
        }
        
    } else {
        [artistsNotInCurrentMatches addObjectsFromArray:currentUserArtists];
    }

    // Array for matches not found to be created new
    NSMutableArray *matchesNotFound = [NSMutableArray array];
    
    // Check if there are matches for this artist already
    // If yes, add the user to that match
    if (retrievedMatches.count != 0) {
        for (NSString *artist in artistsNotInCurrentMatches) {
                for (Match *match in retrievedMatches) {
                    // If match has room for user's instrumentType, update match
                    if ([match.artistID isEqualToString:artist]) {
                        Match *updatedMatch = [Match updateExistingMatch:match];
                        if (updatedMatch) {
                            [matches addObject:updatedMatch];
                            break;
                        }
                    // If no room in retrieved matches, create new match
                    } else if ([match isEqual:[retrievedMatches lastObject]]) {
                        [matchesNotFound addObject:artist];
                    }
                }
        }
    } else {
        [matchesNotFound addObjectsFromArray:artistsNotInCurrentMatches];
    }
    
    // Creates Match object of matches that where not in progress nor found
    for (NSString *artist in matchesNotFound) {
        [matches addObject:[self createNewMatch:artist]];
    }
    
    // Saves matches first, then adds them to User table using PFRelation
    [self saveMatches:matches];
    
}

// Makes string to enum for using in switch
+ (Instrument) instrumentTypeStringToEnum:(NSString*)strInstrument {
    NSUInteger n = [kInstrumentTypeArray indexOfObject:strInstrument];
    return (Instrument) n;
}

// Checks if there is room for user in a match, if not returns nil
+ (Match*)updateExistingMatch:(Match*)match {
    
    NSString *userInstrument = [PFUser.currentUser objectForKey:kUserInstrumentType];
    PFRelation *relation = [match relationForKey:kMatchMembersRelation];
    
    Instrument instrumentType = [Match instrumentTypeStringToEnum:userInstrument];
    
    switch(instrumentType) {
        case Guitar:
            if (!match.hasGuitarist) {
                match.hasGuitarist = YES;
                match.numberOfMembers = [NSNumber numberWithInt:[match.numberOfMembers intValue] + 1];
                [relation addObject:PFUser.currentUser];
                return match;
            }
            return nil;
        case Drums:
            if (!match.hasDrummer) {
                match.hasDrummer = YES;
                match.numberOfMembers = [NSNumber numberWithInt:[match.numberOfMembers intValue] + 1];
                [relation addObject:PFUser.currentUser];
                return match;
            }
            return nil;
        case Singer:
            if (!match.hasSinger) {
                match.hasSinger = YES;
                match.numberOfMembers = [NSNumber numberWithInt:[match.numberOfMembers intValue] + 1];
                [relation addObject:PFUser.currentUser];
                return match;
            }
            return nil;
        case Bass:
            if (!match.hasBassist) {
                match.hasBassist = YES;
                match.numberOfMembers = [NSNumber numberWithInt:[match.numberOfMembers intValue] + 1];
                [relation addObject:PFUser.currentUser];
                return match;
            }
            return nil;
    }
    
}

// Creates new match if no matching with that artist previously existed
+ (Match*)createNewMatch:(NSString*)artist {
    
    NSString *userInstrument = [PFUser.currentUser objectForKey:kUserInstrumentType];
    Instrument instrumentType = [Match instrumentTypeStringToEnum:userInstrument];
    
    Match *newMatch = [Match new];
    newMatch.artistID = artist;
    newMatch.numberOfMembers = kMinMembers;
    newMatch.isActive = NO;
    newMatch.expertiseLevel = [PFUser.currentUser objectForKey:kUserExpertiseLevel];
    PFRelation *relation = [newMatch relationForKey:kMatchMembersRelation];
    [relation addObject:PFUser.currentUser];
    
    switch(instrumentType) {
        case Guitar:
            newMatch.hasGuitarist = YES;
            newMatch.hasBassist = NO;
            newMatch.hasSinger = NO;
            newMatch.hasDrummer = NO;
            return newMatch;
        case Drums:
            newMatch.hasGuitarist = NO;
            newMatch.hasBassist = NO;
            newMatch.hasSinger = NO;
            newMatch.hasDrummer = YES;
            return newMatch;
        case Singer:
            newMatch.hasGuitarist = NO;
            newMatch.hasBassist = NO;
            newMatch.hasSinger = YES;
            newMatch.hasDrummer = NO;
            return newMatch;
        case Bass:
            newMatch.hasGuitarist = NO;
            newMatch.hasBassist = YES;
            newMatch.hasSinger = NO;
            newMatch.hasDrummer = NO;
            return newMatch;
    }
    
}

// Posts matches to database
+ (void)saveMatches:(NSArray*)matches {
    
    PFRelation *relation = [PFUser.currentUser relationForKey:kUserMatchesRelation];
    
    [PFObject saveAllInBackground:matches block:^(BOOL succeeded, NSError * _Nullable error) {

        if (error) {
            NSLog(@"Error saving new matches %@", [error localizedDescription]);
        } else {

            NSLog(@"Successfully saved new matches");

            for (Match* match in matches) {
                [relation addObject:match];
            }

            [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error saving user's matches %@", [error localizedDescription]);
                } else {
                    NSLog(@"Successfully saved user's matches");
                }
            }];

        }
    }];
    
}

@end
