//
//  MusicViewController.m
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/28/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicDataManager.h"
#import "Genre.h"
#import "Music.h"
#import "AppDelegate.h"
#import "CoreDataManager.h"

@interface MusicViewController ()

@end

@implementation MusicViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //Set up navigation bar buttons for favorites
    UIBarButtonItem *addFavorites = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToFavorites)];
    UIBarButtonItem *removeFavorites = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(removeFromFavorites)];
    [self.navigationItem setRightBarButtonItem:addFavorites animated:YES];
    [self.navigationItem setLeftBarButtonItem:removeFavorites animated:YES];
    [self.navigationItem setTitle:@"Top 100 Songs"];
    
    //UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    //Subscribe to notification center loading finished
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"Music parsing finished" object:nil];
    
    self.dataManager = [MusicDataManager sharedInstance];
    [MusicDataManager sendDataRequest];
    [self.refreshControl beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMoreData
{
    //Fetched Caching
    [self performSelector:@selector(updateTable) withObject:nil afterDelay:1];
}

- (void)updateTable
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)addToFavorites
{
    if(self.indexPath.section >= 0 && self.indexPath.section < [self.dataManager.coreGenreDict count]) {
        NSString *key = [self.dataManager.coreGenreKeys objectAtIndex:self.indexPath.section];
        Genre *indexGenre = [self.dataManager.coreGenreDict objectForKey:key];
        NSArray *musicArray = [[indexGenre.music allObjects] copy];
        Music *indexMusic = [musicArray objectAtIndex:self.indexPath.row];
        [MusicDataManager setFavoriteAlbum:indexMusic.album andByFavoriteValue:[NSNumber numberWithBool:YES]];
        [self.tableView reloadData];
    }
}

- (void)removeFromFavorites
{
    if(self.indexPath.section >= 0 && self.indexPath.section < [self.dataManager.coreGenreDict count]) {
        NSString *key = [self.dataManager.coreGenreKeys objectAtIndex:self.indexPath.section];
        Genre *indexGenre = [self.dataManager.coreGenreDict objectForKey:key];
        NSArray *musicArray = [[indexGenre.music allObjects] copy];
        Music *indexMusic = [musicArray objectAtIndex:self.indexPath.row];
        [MusicDataManager setFavoriteAlbum:indexMusic.album andByFavoriteValue:[NSNumber numberWithBool:NO]];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataManager.coreGenreDict count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [self.dataManager.coreGenreKeys objectAtIndex:section];
    Genre *indexGenre = [self.dataManager.coreGenreDict objectForKey:key];
    return [indexGenre.music count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.dataManager.coreGenreKeys objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSString *key = [self.dataManager.coreGenreKeys objectAtIndex:indexPath.section];
    Genre *indexGenre = [self.dataManager.coreGenreDict objectForKey:key];
    NSArray *musicArray = [[indexGenre.music allObjects] copy];
    Music *indexMusic = [musicArray objectAtIndex:indexPath.row];
    
    NSString *album = indexMusic.album;
    NSString *artist = indexMusic.artist;
    NSString *genre = indexGenre.genreName;
    cell.textLabel.text = album;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Artist: %@, Genre: %@", artist, genre];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    if([indexMusic.favorites boolValue]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checked.png"]];
        cell.accessoryView = imageView;
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unchecked.png"]];
        cell.accessoryView = imageView;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


@end
