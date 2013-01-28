//
//  WebserviceConnection.m
//  MapkitAppCitygame
//
//  Created by Wim on 16/01/13.
//  Copyright (c) 2013 Wim. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //background queue
#define webserviceURL [NSURL URLWithString:@"http://webservice.citygamephl.be/TestWebserver1/webresources/generic/coordinates"] //URL webservice

#import "WebserviceConnection.h"

@implementation WebserviceConnection

-(void)getData
{
    //data wordt geladen in background queue
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        webserviceURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];

    
    NSArray* latitude = [json objectForKey:@"Latitude"]; //2
    
    NSArray* longitude = [json objectForKey:@"Longitude"]; //2

    NSLog(@"loans: %@", latitude);
    NSLog(@"loans: %@", longitude);

}
@end
