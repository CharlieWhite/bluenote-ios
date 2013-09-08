//
//  AppDelegate.m
//  bluenote-ios
//
//  Created by Charlie White on 9/7/13.
//  Copyright (c) 2013 Charlie White. All rights reserved.
//

#import "AppDelegate.h"
#import "Note.h"
#import "User.h"
#import "DetailViewController.h"

NSString *localReceived = @"localReceived";

@implementation AppDelegate

{
    
    CLLocationManager *_locationManager;
    BOOL shouldNotify;

}

@synthesize showDetail;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    shouldNotify = NO;
    // Override point for customization after application launch.
    // Configure the object manager
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://fierce-inlet-6385.herokuapp.com/api"]];
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    //
    //    RKLogConfigureByName("RestKit", RKLogLevelWarning);
    //    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    //    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    
    // user
    RKObjectMapping* noteMapping = [RKObjectMapping mappingForClass:[Note class]];
    [noteMapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"noteId",
                                                      @"message": @"message",
                                                      @"from_user_id": @"fromUserId",
                                                      @"created_at": @"createdAt"
                                                      }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:noteMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"notes" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping* noteRequestMapping = [noteMapping inverseMapping];
    
    // Now configure the request descriptor
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:noteRequestMapping objectClass:[Note class] rootKeyPath:@"note"];
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    // users
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping addAttributeMappingsFromDictionary:@{
                                                      @"name": @"name",
                                                      @"id": @"userId",
                                                      @"at_home": @"atHome"
                                                      }];
    
    RKResponseDescriptor *userResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"users" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:userResponseDescriptor];
    
    RKObjectMapping* userRequestMapping = [userMapping inverseMapping];
    
    // Now configure the request descriptor
    RKRequestDescriptor *userRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:userRequestMapping objectClass:[User class] rootKeyPath:@"user"];
    
    [objectManager addRequestDescriptor:userRequestDescriptor];
    
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:((unsigned short)1)  minor:((unsigned short)1) identifier:@"com.apple.bluenote-ios"];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    region.notifyEntryStateOnDisplay = YES;
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    [_locationManager startMonitoringForRegion:region];
    [_locationManager startRangingBeaconsInRegion:region];

    NSLog(@"TEST Monitor Ranging Init");
    
    return YES;

    
   

}

- (void)locationManager:(CLLocationManager*)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Monitoring Status");
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"%@",[error localizedDescription]);
}


- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
    {
        NSLog(@"BEACON RANGE TEST 1");
    
    if ([beacons count] > 0) {
        CLBeacon *beacon = [beacons firstObject];
        if (beacon.proximity == CLProximityImmediate && shouldNotify == NO){
           
           shouldNotify = YES;
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.alertBody = @"New BlueNote!";
            notification.soundName = UILocalNotificationDefaultSoundName;

            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            NSLog(@"BEACON RANGE TEST 3");
           }
        
        }
    }






- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:localReceived object:self];
    
    NSLog(@"notif");
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
