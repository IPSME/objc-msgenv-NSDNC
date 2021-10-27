//
//  msgenv_NSDNC.m
//  objc-zmq-reflector
//
//  Created by dev on 2021-10-27.
//  Copyright © 2021 Root Interface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "msgenv_NSDNC.h"

t_handler_ptr g_handler_ptr_= NULL;

void notification_callback(CFNotificationCenterRef center,
				  void* observer,
				  CFNotificationName name,
				  const void* object,
				  CFDictionaryRef userInfo)
{
	NSLog(@"nfy_callback: %@", name);
	
	NSString *nsstr= (__bridge NSString *)name;
	g_handler_ptr_(nsstr);
}

@implementation MsgEnv_NSDNC

+ (void) subscribe:(t_handler_ptr)handler_ptr
{
	g_handler_ptr_= handler_ptr;
	
	CFNotificationCenterRef ncref_Distributed = CFNotificationCenterGetDistributedCenter();
	CFNotificationCenterAddObserver(ncref_Distributed,				// CFNotificationCenterRef center
									(const void*)g_handler_ptr_,	// const void *observer
									notification_callback,			// CFNotificationCallback callBack
									NULL, 							// CFStringRef name
									NULL, 							// const void *object
									CFNotificationSuspensionBehaviorDeliverImmediately // CFNotificationSuspensionBehavior suspensionBehavior
		);
}

+ (void) unsubscribe
{
	CFNotificationCenterRef ncref_Distributed = CFNotificationCenterGetDistributedCenter();
	CFNotificationCenterRemoveObserver(ncref_Distributed,			// CFNotificationCenterRef center
									   (const void*)g_handler_ptr_,	// const void *observer
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
