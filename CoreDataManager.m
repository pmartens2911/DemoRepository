//
//  CoreDataManager.m
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/28/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"
#import "Genre.h"
#import "Music.h"

@implementation CoreDataManager

+ (NSArray*)loadDataArrayWithEntity:(NSString*)entityName andWithKey:(NSString*)key
{
    //Fetch Data
    //NSFetchRequest needed by the fetchedResultsController
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    //NSSortDescriptor defines how to sort the fetched results
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:key ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //Set fetchBatchSize
    //[fetchRequest setFetchBatchSize:25];
    
    //FetchRequest needs to know what entity to fetch
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    
    NSError *error = nil;
    if(![fetchedResultsController performFetch:&error])
    {
        //Error Handling Here
        NSLog(@"Failed to fetch results for entity %@, error %@", entityName, error);
        exit(-1);
    }
    //NSArray *section0 = [[fetchedResultsController sections] objectAtIndex:0];
    NSArray *resultsArray = fetchedResultsController.fetchedObjects;
    NSLog(@"Results Array : %@", resultsArray);
    return resultsArray;
}

+ (NSArray *)loadDataByGenre
{
    return [CoreDataManager loadDataArrayWithEntity:@"Genre" andWithKey:@"genreName"];
}

+ (NSArray *)loadDataByMusic
{
    return [CoreDataManager loadDataArrayWithEntity:@"Music" andWithKey:@"album"];
}

+ (NSManagedObject*)getObjectByEntity:(NSString*)entity andByKey:(NSString*)key andByValue:(NSString*)value
{
    NSArray *dataArray = [CoreDataManager loadDataArrayWithEntity:entity andWithKey:key];
    if ([entity isEqualToString:@"Genre"]) {
        for (Genre *item in dataArray)
        {
            if([[item valueForKey:key] isEqualToString:value]) {
                return item;
            }
        }
    } else if ([entity isEqualToString:@"Music"]) {
        for (Music *item in dataArray)
        {
            if([[item valueForKey:key] isEqualToString:value]) {
                return item;
            }
        }
    }
    //Return nil if object not found
    return nil;
}

+ (BOOL)saveMusicWithAlbum:(NSString*)album andWithArtist:(NSString*)artist andWithGenre:(NSString*)genre
{
    NSError *error = nil;
    
    //Grab the appDelegate and managedObjectContext
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    Music *newMusic = (Music*)[CoreDataManager getObjectByEntity:@"Music" andByKey:@"album" andByValue:album];
    if(newMusic != nil) {
        return NO;
    }
    // Song doesn't exist in the managedObjectContext, so make a new one
    newMusic = (Music*)[NSEntityDescription insertNewObjectForEntityForName:@"Music" inManagedObjectContext:managedObjectContext];
    
    newMusic.album = album;
    newMusic.artist = artist;
    newMusic.favorites = [NSNumber numberWithBool:NO];
    
    Genre *musicGenre = (Genre*)[CoreDataManager getObjectByEntity:@"Genre" andByKey:@"genreName" andByValue:genre];
    
    //If the genre doesn't exist then create it
    if(musicGenre == nil) {
        musicGenre = (Genre*)[NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:managedObjectContext];
        //Set up the genre item name
        musicGenre.genreName = genre;
    }
    //Set the music genre pointer
    newMusic.genre = musicGenre;
    
    //Add the music item to the genre set
    [musicGenre addMusicObject:newMusic];
    
    //Save the managedObjectContext
    if(![managedObjectContext save:&error])
    {
        //Error Handling Here
        NSLog(@"Failed to save entity error %@", error);
        exit(-1);
    }
    return YES;
}

+ (void)clearCoreData
{
    //Grab the appDelegate and managedObjectContext
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    [managedObjectContext reset];
    NSError *error;
    //Save the managedObjectContext
    if(![managedObjectContext save:&error])
    {
        //Error Handling Here
        NSLog(@"Failed to save entity error %@", error);
        exit(-1);
    }
    
}

+ (NSFetchedResultsController*)loadFetchedResultsWithEntity:(NSString*)entityName andWithKey:(NSString*)key andWithBatchSize:(NSUInteger)batchSize
{
    //Fetch Data
    //NSFetchRequest needed by the fetchedResultsController
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    //NSSortDescriptor defines how to sort the fetched results
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:key ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //Set fetchBatchSize
    [fetchRequest setFetchBatchSize:batchSize];
    
    //FetchRequest needs to know what entity to fetch
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    
    NSError *error = nil;
    if(![fetchedResultsController performFetch:&error])
    {
        //Error Handling Here
        NSLog(@"Failed to fetch results for entity %@, error %@", entityName, error);
        exit(-1);
    }
    
    return fetchedResultsController;
}

+ (NSFetchedResultsController*)loadFetchedResultsByAlbum
{
    return [CoreDataManager loadFetchedResultsWithEntity:@"Music" andWithKey:@"album" andWithBatchSize:25];
}

- (NSFetchedResultsController*)loadFetchedResultsByGenre
{
    return [CoreDataManager loadFetchedResultsWithEntity:@"Genre" andWithKey:@"genreName" andWithBatchSize:1];
}

+ (void)setFavoriteAlbum:(NSString*)album andByFavoriteValue:(NSNumber*)value
{
    Music *changeItem = (Music*)[CoreDataManager getObjectByEntity:@"Music" andByKey:@"album" andByValue:album];
    changeItem.favorites = value;
    
    //Grab the appDelegate and managedObjectContext
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;

    NSError *error;
    //Save the managedObjectContext
    if(![managedObjectContext save:&error])
    {
        //Error Handling Here
        NSLog(@"Failed to save entity error %@", error);
        exit(-1);
    }
    
}

@end
