//
//  ExifGeolocation.mm
//  PhotoShare
//
//  Created by Bryce Cogswell on 7/21/21.
//  Copyright © 2021 Bryce Cogswell. All rights reserved.
//

#import "ExifGeolocation.h"
#import "easyexif/exif.h"

@implementation ExifGeolocation {
	void * pointer;
}

- (instancetype)initWithData:(NSData *)data
{
	easyexif::EXIFInfo * result = new easyexif::EXIFInfo();
	self->pointer = result;
	if ( result->parseFrom((unsigned char *)data.bytes, (unsigned int)data.length) != 0 ) {
		return nil;
	}
	return self;
}

-(void)dealloc {
	easyexif::EXIFInfo * result = (easyexif::EXIFInfo *)self->pointer;
	self->pointer = nullptr;
	delete result;
}

- (NSString *)lensModel
{
	easyexif::EXIFInfo * result = (easyexif::EXIFInfo *)self->pointer;
	const char * str = result->LensInfo.Model.c_str();
	return [NSString stringWithUTF8String:str];
}

- (CLLocation *)location
{
	easyexif::EXIFInfo * result = (easyexif::EXIFInfo *)self->pointer;
	double direction = result->GeoLocation.imgDirection;
	CLLocationCoordinate2D coord;
	coord.latitude = result->GeoLocation.Latitude;
	coord.longitude = result->GeoLocation.Longitude;

	NSString * dateString = [NSString stringWithUTF8String:result->DateTime.c_str()];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
	NSDate * date = [dateFormatter dateFromString:dateString];

	CLLocation * loc = [[CLLocation alloc] initWithCoordinate:coord
													 altitude:0.0
										   horizontalAccuracy:0.0
											 verticalAccuracy:0.0
													   course:direction
														speed:0.0
													timestamp:date];
	return loc;
}

@end
