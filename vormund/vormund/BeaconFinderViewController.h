//
//  BeaconFinderViewController.h
//  vormund
//
//  Created by Saravanan ImmaMaheswaran on 3/8/14.
//  Copyright (c) 2014 Pluggables. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BeaconFinderViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelStatus;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
