//
//  ITConnectionManager.m
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/29/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import "ITConnectionManager.h"
#import "ITDataManager.h"
#import "ITItem.h"

@implementation ITConnectionManager
- (void)sendDataRequest
{
    //URL and Connection Code
    NSURL *tempNSURL = [NSURL URLWithString:@"http://dev.fuzzproductions.com/MobileTest/test.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tempNSURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if(theConnection) {
        self.recievedData = [NSMutableData data];
    } else {
        //Inform the user that the connection failed.
        UIAlertView *connectionFailure = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"There was an error in sending the connection request. Please make sure that you have a connection before attempting to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [connectionFailure show];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //Has recieved a response, so reset the data
    [self.recievedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //Append the new data to recievedData
    [self.recievedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Finished recieving data, parse through it now with JSON methodology
    NSArray *allDataArray = [NSJSONSerialization JSONObjectWithData:self.recievedData options:0 error:nil];
    //Clear out old data manager
    ITDataManager *dataManager = [ITDataManager sharedInstance];
    [dataManager.dictIT removeAllObjects];
    
    //Initialize data manager arrays
    NSMutableArray *allItems = [[NSMutableArray alloc]init];
    NSMutableArray *imgItems = [[NSMutableArray alloc]init];
    NSMutableArray *txtItems = [[NSMutableArray alloc]init];
    //Push arrays to the data manager dictionary
    [dataManager.dictIT setObject:allItems forKey:ALL_ITEMS];
    [dataManager.dictIT setObject:imgItems forKey:IMAGE_ITEMS];
    [dataManager.dictIT setObject:txtItems forKey:TEXT_ITEMS];
    
    //For each object in the JSON Array
    for(NSDictionary *dict in allDataArray) {
        ITItem *newItem = [[ITItem alloc]init];
        newItem.sID = [dict objectForKey:@"id"];
        newItem.type = [dict objectForKey:@"type"];
        newItem.data = [dict objectForKey:@"data"];
        
        //Push item to all array
        NSMutableArray *allItems = [dataManager.dictIT objectForKey:ALL_ITEMS];
        [allItems addObject:newItem];
        
        //Check type then push into respective array
        if([newItem.type isEqualToString:IMAGE_ITEMS]) {
            NSMutableArray *imgItems = [dataManager.dictIT objectForKey:IMAGE_ITEMS];
            [imgItems addObject:newItem];
        } else if ([newItem.type isEqualToString:TEXT_ITEMS]) {
            NSMutableArray *txtItems = [dataManager.dictIT objectForKey:TEXT_ITEMS];
            [txtItems addObject:newItem];
        }
    }
    
    //Send Notification that Image/Text JSON parsing has finished.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IT Parsing Finished" object:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Inform the user that the connection failed.
    UIAlertView *connectionFailure = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"There was an error in sending the connection request. Please make sure that you have a connection before attempting to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [connectionFailure show];
}

@end
