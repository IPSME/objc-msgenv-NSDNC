//
//  msgenv_NSDNC.m
//  objc-zmq-reflector
//
//  Created by dev on 2021-10-27.
//  Copyright © 2021 Root Interface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "msgenv_NSDNC.h"

void notification_callback(CFNotificationCenterRef center,
				  void* observer,
				  CFNotificationName name,
				  const void* object,
				  CFDictionaryRef userInfo)
{
	NSString *nsstr_name= (__bridge NSString *)name;
	NSString *nsstr_obj= (__bridge NSString *)object;
	((t_handler_ptr)observer)(nsstr_name, nsstr_obj);
}

// Sandboxing:
//		https://stackoverflow.com/questions/36687525/nsdistributednotificationcenter-not-working
//		https://developer.apple.com/forums/thread/129437
// Example: https://github.com/RabbitMC/DistributedNotifications/blob/master/DistributedNotifications/NotificationsManager/NotificationsManager.m

@implementation MsgEnv_NSDNC

+ (void) subscribe:(t_handler_ptr)handler_ptr
{
	CFNotificationCenterRef ncref_Distributed = CFNotificationCenterGetDistributedCenter();
	CFNotificationCenterAddObserver(ncref_Distributed,				// CFNotificationCenterRef center
									(const void*)handler_ptr,		// const void *observer
									notification_callback,			// CFNotificationCallback callBack
									NULL, 							// CFStringRef name
									NULL, 							// const void *object
									CFNotificationSuspensionBehaviorDeliverImmediately // CFNotificationSuspensionBehavior suspensionBehavior
		);
}

+ (void) unsubscribe:(t_handler_ptr)handler_ptr
{
	CFNotificationCenterRef ncref_Distributed = CFNotificationCenterGetDistributedCenter();
	CFNotificationCenterRemoveObserver(ncref_Distributed,			// CFNotificationCenterRef center
									   (const void*)handler_ptr,	// const void *observer
									   NULL, 						// CFNotificationName name
									   NULL							// const void *object
		);
}

+ (void) publish:(NSString*)nsstr
{
	CFNotificationCenterRef ncref_Distributed = CFNotificationCenterGetDistributedCenter();
	CFNotificationCenterPostNotification(ncref_Distributed,				// CFNotificationCenterRef center
										 (__bridge CFStringRef)nsstr,	// CFNotificationName name
										 NULL,							// const void *object
										 NULL,							// CFDictionaryRef userInfo
										 YES							// Boolean deliverImmediately
		);
}

@end

@implementation MsgEnv_NSDNC (Reflector)


// Even though object is a (const void*), if you don't pass an NSString*,
// you get an access exception.
//
+ (void) publish:(NSString*)nsstr withObject:(NSString*)object
{
	CFNotificationCenterRef ncref_Distributed = CFNotificationCenterGetDistributedCenter();
	CFNotificationCenterPostNotification(ncref_Distributed,				// CFNotificationCenterRef center
										 (__bridge CFStringRef)nsstr,	// CFNotificationName name
										 (__bridge CFStringRef)object,	// const void *object
										 NULL,							// CFDictionaryRef userInfo
										 YES							// Boolean deliverImmediately
		);
}

@end
