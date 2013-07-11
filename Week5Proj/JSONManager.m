//
//  JSONManager.m
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/29/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import "JSONManager.h"

@implementation JSONManager

+ (NSArray*)readTemperatures
{
    NSString *filePath = [[NSBundle mainBundle] resourcePath];
    NSString *file = [filePath stringByAppendingPathComponent:@"bath.json"];
    NSData *data = [NSData dataWithContentsOfFile:file];
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSNumber *hot = [jsonDict objectForKey:@"hot_water"];
    NSNumber *cold = [jsonDict objectForKey:@"cold_water"];
    NSArray *returnArray = [NSArray arrayWithObjects:hot, cold, nil];
    return returnArray;
}

@end
