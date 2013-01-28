//
//  JagerAnnotation.m
//  MapkitAppCitygame
//
//  Created by Wim on 14/01/13.
//  Copyright (c) 2013 Wim. All rights reserved.
//

#import "JagerAnnotation.h"

@implementation JagerAnnotation
@synthesize titel = _titel;

- (CLLocationCoordinate2D)coordinate;
{
    return self.coordinaat;

}

- (NSString *)title
{
    return self.titel;
}

// optional
- (NSString *)subtitle
{
    return self.subTitel;
}
@end
