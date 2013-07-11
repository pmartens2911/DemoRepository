//
//  ITConnectionManager.h
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/29/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITConnectionManager : NSObject <NSURLConnectionDataDelegate>
@property (strong, nonatomic) NSMutableData *recievedData;
@property (strong, nonatomic) NSMutableString *soapResult;
@property (strong, nonatomic) NSNumber *elementFound;
- (void)sendDataRequest;
@end
