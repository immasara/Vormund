//
//  BroadcastBeaconViewController.m
//  vormund
//
//  Created by Saravanan ImmaMaheswaran on 3/8/14.
//  Copyright (c) 2014 Pluggables. All rights reserved.
//

#import "BroadcastBeaconViewController.h"
#import "GlobalConstants.h"

@interface BroadcastBeaconViewController ()

@end

@implementation BroadcastBeaconViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *beaconRegionIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    beaconRegionIdentifier = [beaconRegionIdentifier stringByAppendingString:kBeaconRegionBroadcast];
    
    // Create a NSUUID object
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:kTestBeaconId];
    
    // Initialize the Beacon Region
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                  major:1
                                                                  minor:1
                                                             identifier:beaconRegionIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonBroadcast_click:(id)sender {
    // Get the beacon data to advertise
    self.beaconData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    
    // Start the peripheral manager
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager*)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        // Bluetooth is on
        
        // Update our status label
        self.labelStatus.text = @"Broadcasting...";
        
        // Start broadcasting
        [self.peripheralManager startAdvertising:self.beaconData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        // Update our status label
        self.labelStatus.text = @"Stopped";
        
        // Bluetooth isn't on. Stop broadcasting
        [self.peripheralManager stopAdvertising];
    }
    else if (peripheral.state == CBPeripheralManagerStateUnsupported)
    {
        self.labelStatus.text = @"Unsupported";
    }
}

@end
