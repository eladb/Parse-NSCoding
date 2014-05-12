//
//  PFGeoPoint+NSCoding.m
//  Created by Pedro Almeida on 5/1/14.
//
//

#import "PFGeoPoint+NSCoding.h"
#import "NSObject+Properties.h"

@implementation PFGeoPoint (NSCoding)


#define kPFGeoPointLatitude   @"_latitude"
#define kPFGeoPointLongitude  @"_longitude"

- (void)encodeWithCoder:(NSCoder*)encoder
{
	//Serialize Parse-specific values
	[encoder encodeDouble:[self latitude] forKey:kPFGeoPointLatitude];
	[encoder encodeDouble:[self longitude] forKey:kPFGeoPointLongitude];
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	//Deserialize Parse-specific values
    double latitude = [aDecoder decodeDoubleForKey:kPFGeoPointLatitude];
    double longitude = [aDecoder decodeDoubleForKey:kPFGeoPointLongitude];
    
    self = [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];
    
    return self;
}

@end