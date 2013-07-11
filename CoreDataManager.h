//
//  CoreDataManager.h
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/28/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject
+ (BOOL)saveMusicWithAlbum:(NSString*)album andWithArtist:(NSString*)artist andWithGenre:(NSString*)genre;
+ (NSArray *)loadDataByGenre;
+ (NSFetchedResultsController*)loadFetchedResultsByAlbum;
+ (void)clearCoreData;
+ (void)setFavoriteAlbum:(NSString*)album andByFavoriteValue:(NSNumber*)value;
@end
