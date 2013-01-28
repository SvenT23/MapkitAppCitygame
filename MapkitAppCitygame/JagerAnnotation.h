//
//  JagerAnnotation.h
//  MapkitAppCitygame
//
//  Created by Wim on 14/01/13.
//  Copyright (c) 2013 Wim. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface JagerAnnotation : NSObject <MKAnnotation>

@property (nonatomic) NSString *titel;
@property (nonatomic) NSString *subTitel;
@property (nonatomic) CLLocationCoordinate2D coordinaat;
@end
