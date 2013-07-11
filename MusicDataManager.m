//
//  MusicDataManager.m
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/28/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import "MusicDataManager.h"
#import "Genre.h"
#import "Music.h"
#import "ConnectionManager.h"
#import "CoreDataManager.h"

@implementation MusicDataManager

+ (MusicDataManager *)sharedInstance
{
    static MusicDataManager *sharedInstance;
    if(sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL]init];
        //Initialize arrays
        sharedInstance.arrAlbums = [[NSMutableArray alloc]init];
        sharedInstance.arrArtists = [[NSMutableArray alloc]init];
        sharedInstance.arrGenres = [[NSMutableArray alloc]init];
        sharedInstance.coreGenreKeys = [[NSMutableArray alloc]init];
        sharedInstance.coreGenreDict = [[NSMutableDictionary alloc]init];
        //Test Data
        sharedInstance.musicData = [[NSMutableArray alloc]init];
    }
    return sharedInstance;
}

+ (void)sendDataRequest
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    
    [connectionManager sendDataRequest];
}

+ (void)setCoreData
{
    MusicDataManager *data = [MusicDataManager sharedInstance];
    
    //Clear out the data
    [data.musicData removeAllObjects];
    NSNumber *songCount = [NSNumber numberWithInteger:[data.arrAlbums count]];
    NSNumber *artistCount = [NSNumber numberWithInteger:[data.arrArtists count]];
    NSNumber *genreCount = [NSNumber numberWithInteger:[data.arrGenres count]];
    if([songCount isEqualToNumber:artistCount] && [songCount isEqualToNumber:genreCount]) {
        for(int i = 0; i < [data.arrAlbums count]; i++) {
            //Test data
            /*MusicItem *newItem = [[MusicItem alloc]init];
             newItem.album = [data.arrAlbums objectAtIndex:i];
             newItem.artist = [data.arrArtists objectAtIndex:i];
             newItem.genre = [data.arrGenres objectAtIndex:i];
             newItem.favorites = [NSNumber numberWithBool:NO];
             
             [data.musicData addObject:newItem];*/
            //Core Data
            [CoreDataManager saveMusicWithAlbum:[data.arrAlbums objectAtIndex:i] andWithArtist:[data.arrArtists objectAtIndex:i] andWithGenre:[data.arrGenres objectAtIndex:i]];
        }
    }
    //Core data is saved out, load it into the data now.
    NSArray *coreData = [CoreDataManager loadDataByGenre];
    [data.coreGenreDict removeAllObjects];
    [data.coreGenreKeys removeAllObjects];
    for(Genre *item in coreData) {
         [data.coreGenreDict setObject:item forKey:item.genreName];
         [data.coreGenreKeys addObject:item.genreName];
    }
    
}

+ (NSFetchedResultsController*)loadFetchedResultsByAlbum
{
    return [CoreDataManager loadFetchedResultsByAlbum];
}

+ (void)setFavoriteAlbum:(NSString*)album andByFavoriteValue:(NSNumber*)value
{
    [CoreDataManager setFavoriteAlbum:album andByFavoriteValue:value];
}

@end
