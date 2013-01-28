//
//  ProoiAnnotation.m
//  MapkitAppCitygame
//
//  Created by Wim on 15/01/13.
//  Copyright (c) 2013 Wim. All rights reserved.
//

#import "ProoiAnnotation.h"

@implementation ProoiAnnotation
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
