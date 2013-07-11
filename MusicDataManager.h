//
//  MusicDataManager.h
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/28/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicDataManager : NSObject
@property (strong, nonatomic) NSMutableArray *arrAlbums;
@property (strong, nonatomic) NSMutableArray *arrArtists;
@property (strong, nonatomic) NSMutableArray *arrGenres;

//Test Data
@property (strong, nonatomic) NSMutableArray *musicData;

//Core Data
@property (strong, nonatomic) NSMutableDictionary *coreGenreDict;
@property (strong, nonatomic) NSMutableArray *coreGenreKeys;
//@property (strong, nonatomic) NSArray *coreGenre;
//@property (strong, nonatomic) NSArray *coreMusic;

+ (MusicDataManager *)sharedInstance;
+ (void)setCoreData;
+ (void)sendDataRequest;
+ (NSFetchedResultsController*)loadFetchedResultsByAlbum;
+ (void)setFavoriteAlbum:(NSString*)album andByFavoriteValue:(NSNumber*)value;
@end
