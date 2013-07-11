//
//  InfoViewController.h
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/29/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITDataManager;

@interface InfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgmDisplay;
@property (weak, nonatomic) IBOutlet UITableView *tblData;
- (IBAction)sgmDisplayChange:(id)sender;
//Data Properties
@property (strong, nonatomic) NSString *displayState;
@property (strong, nonatomic) ITDataManager *dataManager;
- (IBAction)btnReturn:(id)sender;
@property (strong, nonatomic) NSMutableDictionary *imageDict;
@property (strong, nonatomic) UIWebView *webView;

@end
