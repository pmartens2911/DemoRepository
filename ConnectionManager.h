//
//  ConnectionManager.h
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/28/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionManager : NSObject <NSURLConnectionDataDelegate, NSXMLParserDelegate>
@property (strong, nonatomic) NSMutableData *recievedData;
@property (strong, nonatomic) NSMutableString *soapResult;
@property (strong, nonatomic) NSNumber *elementFound;
- (void)sendDataRequest;

@end
