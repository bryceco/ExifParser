//
//  ExifGeolocation.h
//  PhotoShare
//
//  Created by Bryce Cogswell on 7/21/21.
//  Copyright © 2021 Bryce Cogswell. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExifGeolocation: NSObject 
- (nullable instancetype)initWithData:(NSData *)data;
- (CLLocation *)location;
- (NSString *)lensModel;
@end

NS_ASSUME_NONNULL_END
