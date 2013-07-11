//
//  ConnectionManager.m
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/28/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import "ConnectionManager.h"
#import "MusicDataManager.h"

@implementation ConnectionManager
NSString *matchingElementSong = @"im:collection";
NSString *matchingElementArtist = @"im:artist";
NSString *matchingElementGenre = @"category";

//Connection Delegate

- (void)sendDataRequest
{
    //URL and Connection Code
    NSURL *tempNSURL = [NSURL URLWithString:@"https://itunes.apple.com/us/rss/topsongs/limit=100/xml"];
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
    //Finished recieving data, parse through it now
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithData:self.recievedData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    //XMLParser *parserDelegate = [[XMLParser alloc]init];
    //parserDelegate.vcReturn = self;
    //[XMLParser parseWithData:self.recievedData andDelegateParser:parserDelegate];
}

//Parser Delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([matchingElementSong isEqualToString:elementName]) {
        if(!self.soapResult) {
            self.soapResult = [[NSMutableString alloc]init];
        }
        self.elementFound = [NSNumber numberWithBool:YES];
    } else if([matchingElementArtist isEqualToString:elementName]) {
        if(!self.soapResult) {
            self.soapResult = [[NSMutableString alloc]init];
        }
        self.elementFound = [NSNumber numberWithBool:YES];
    } else if([matchingElementGenre isEqualToString:elementName]) {
        if(!self.soapResult) {
            self.soapResult = [[NSMutableString alloc]init];
        }
        self.soapResult = [attributeDict objectForKey:@"term"];
        self.elementFound = [NSNumber numberWithBool:NO];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([self.elementFound boolValue] == YES) {
        [self.soapResult appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    MusicDataManager *data = [MusicDataManager sharedInstance];
    //Set the data
    if([matchingElementSong isEqualToString:elementName]) {
        [data.arrAlbums addObject:self.soapResult];
        self.elementFound = [NSNumber numberWithBool:NO];
        self.soapResult = NULL;
    } else if([matchingElementArtist isEqualToString:elementName]) {
        [data.arrArtists addObject:self.soapResult];
        self.elementFound = [NSNumber numberWithBool:NO];
        self.soapResult = NULL;
    } else if([matchingElementGenre isEqualToString:elementName]) {
        [data.arrGenres addObject:self.soapResult];
        self.elementFound = [NSNumber numberWithBool:NO];
        self.soapResult = NULL;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //Load arrays into the coredata
    [MusicDataManager setCoreData];
    
    //Send Notification that parsin has finished.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Music parsing finished" object:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Inform the user that the connection failed.
    UIAlertView *connectionFailure = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"There was an error in sending the connection request. Please make sure that you have a connection before attempting to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [connectionFailure show];
}
@end
