//
//  ITDataManager.m
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/29/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import "ITDataManager.h"
#import "ITConnectionManager.h"


@implementation ITDataManager

+ (ITDataManager *)sharedInstance
{
    static ITDataManager *sharedInstance;
    if(sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL]init];
        //Initialize data
        sharedInstance.dictIT = [[NSMutableDictionary alloc]init];
    }
    return sharedInstance;
}

+ (void)sendDataRequest
{
    ITConnectionManager *connectionManager = [[ITConnectionManager alloc]init];
    [connectionManager sendDataRequest];
}



@end
