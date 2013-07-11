//
//  MusicViewController.h
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/28/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicDataManager;

@interface MusicViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tblMusic;
@property (strong, nonatomic) MusicDataManager *dataManager;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end
