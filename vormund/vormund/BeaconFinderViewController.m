//
//  BeaconFinderViewController.m
//  vormund
//
//  Created by Saravanan ImmaMaheswaran on 3/8/14.
//  Copyright (c) 2014 Pluggables. All rights reserved.
//

#import "BeaconFinderViewController.h"
#import "GlobalConstants.h"

@interface BeaconFinderViewController ()

@end

@implementation BeaconFinderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *beaconRegionIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    beaconRegionIdentifier = [beaconRegionIdentifier stringByAppendingString:kBeaconRegionBroadcast];

    // Initialize location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:kEstimoteBeaconId];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                             identifier:beaconRegionIdentifier];
    
    // Tell location manager to start monitoring for the beacon region
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.labelStatus.text = @"No";
    
    //Local Push Notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotification.alertBody = [NSString stringWithFormat:@"Beacon out of range"];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    NSString *statusText = [NSString stringWithFormat:@"Beacon found (%d)! ", (int)beacons.count];
    
    for (int indexCount=0; indexCount<beacons.count; indexCount++)
    {
        CLBeacon *foundBeacon = [beacons objectAtIndex:indexCount];
        
        // You can retrieve the beacon data from its properties
        statusText = [statusText stringByAppendingFormat:@" [%@ - %@.%@],", foundBeacon.proximityUUID.UUIDString, foundBeacon.major, foundBeacon.minor];
    }

    self.labelStatus.text = statusText;
    
    //Local Push Notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotification.alertBody = [NSString stringWithFormat:@"Beacon found (%d)! ", (int)beacons.count];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
