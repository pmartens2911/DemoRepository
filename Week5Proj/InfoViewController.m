//
//  InfoViewController.m
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/29/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import "InfoViewController.h"
#import "ITDataManager.h"
#import "ITItem.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataManager = [ITDataManager sharedInstance];
    self.displayState = ALL_ITEMS;
    
    [self.tblData setDataSource:self];
    [self.tblData setDelegate:self];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 71, 320, 477)];
    [self.webView setDelegate:self];
    
    self.imageDict = [[NSMutableDictionary alloc]init];
    
    //Subscribe to notification center loading finished
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"IT Parsing Finished" object:nil];
    
    [ITDataManager sendDataRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sgmDisplayChange:(id)sender {
    switch ([self.sgmDisplay selectedSegmentIndex]) {
        case 0:
            self.displayState = ALL_ITEMS;
            break;
        case 1:
            self.displayState = TEXT_ITEMS;
            break;
        case 2:
            self.displayState = IMAGE_ITEMS;
            break;
        default:
            break;
    }
    [self.tblData reloadData];
}

- (void)updateTable
{
    NSArray *imageArray = [self.dataManager.dictIT objectForKey:IMAGE_ITEMS];
    [self.imageDict removeAllObjects];
    for(ITItem *item in imageArray) {
        NSURL *url = [NSURL URLWithString:item.data];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *newImage = [UIImage imageWithData:imageData];
        UIImageView *newImageView = [[UIImageView alloc]initWithImage:newImage];
        [self.imageDict setObject:newImageView forKey:item.sID];
    }
    [self.tblData reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *itemArray;
    if([self.displayState isEqualToString:ALL_ITEMS]) {
        itemArray = [self.dataManager.dictIT objectForKey:ALL_ITEMS];
    } else if([self.displayState isEqualToString:TEXT_ITEMS]) {
        itemArray = [self.dataManager.dictIT objectForKey:TEXT_ITEMS];
    } else if([self.displayState isEqualToString:IMAGE_ITEMS]) {
        itemArray = [self.dataManager.dictIT objectForKey:IMAGE_ITEMS];
    }
    return [itemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSArray *itemArray;
    if([self.displayState isEqualToString:ALL_ITEMS]) {
        itemArray = [self.dataManager.dictIT objectForKey:ALL_ITEMS];
    } else if([self.displayState isEqualToString:TEXT_ITEMS]) {
        itemArray = [self.dataManager.dictIT objectForKey:TEXT_ITEMS];
    } else if([self.displayState isEqualToString:IMAGE_ITEMS]) {
        itemArray = [self.dataManager.dictIT objectForKey:IMAGE_ITEMS];
    }
    ITItem *indexItem = [itemArray objectAtIndex:indexPath.row];
    
    if([indexItem.type isEqualToString:TEXT_ITEMS]) {
        cell.textLabel.text = indexItem.data;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.backgroundView = nil;
    } else if([indexItem.type isEqualToString:IMAGE_ITEMS]) {
        cell.textLabel.text = @"";
        cell.backgroundView = [self.imageDict objectForKey:indexItem.sID];
    } else {
        cell.textLabel.text = indexItem.data;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.backgroundView = nil;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *itemArray;
    if([self.displayState isEqualToString:ALL_ITEMS]) {
        itemArray = [self.dataManager.dictIT objectForKey:ALL_ITEMS];
    } else if([self.displayState isEqualToString:TEXT_ITEMS]) {
        itemArray = [self.dataManager.dictIT objectForKey:TEXT_ITEMS];
    } else if([self.displayState isEqualToString:IMAGE_ITEMS]) {
        itemArray = [self.dataManager.dictIT objectForKey:IMAGE_ITEMS];
    }
    ITItem *indexItem = [itemArray objectAtIndex:indexPath.row];
    
    if([indexItem.type isEqualToString:TEXT_ITEMS]) {
        return 70;
    } else if([indexItem.type isEqualToString:IMAGE_ITEMS]) {
        return 100;
    } else {
        return 70;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com/"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
    [self.webView setTag:100];
    [self.view addSubview:self.webView];
    
    //button.tag = 200
    //Function
    //[[self.view viewWithTag:200] removeFromSuperview];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)btnReturn:(id)sender {
    [[self.view viewWithTag:100] removeFromSuperview];
}
@end
