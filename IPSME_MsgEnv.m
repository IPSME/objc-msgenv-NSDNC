//
//  msgenv_NSDNC.m
//  objc-zmq-reflector
//
//  Created by dev on 2021-10-27.
//  Copyright © 2021 Root Interface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPSME_MsgEnv.h"

NSString* gk_NAME= @"IPSME";
NSString* gk_MSG= @"msg";

void notification_callback(CFNotificationCenterRef center,
				  void* p_observer,
				  CFNotificationName name,
				  const void* object,
				  CFDictionaryRef userInfo)
{
	// NSString *nsstr_name= (__bridge NSString *)name; // == @"IPSME"
    NSString *nsstr_obj= (__bridge NSString *)object;
    NSDictionary* nsdic_userInfo= (__bridge NSDictionary*)userInfo;
    NSString* nsstr_msg= nsdic_userInfo[gk_MSG];
    assert(nsstr_msg != nil);
    
	((tp_handler)p_observer)(nsstr_msg, nsstr_obj);
}

// Sandboxing:
//		https://stackoverflow.com/questions/36687525/nsdistributednotificationcenter-not-working
//		https://developer.apple.com/forums/thread/129437
// Example: https://github.com/RabbitMC/DistributedNotifications/blob/master/DistributedNotifications/NotificationsManager/NotificationsManager.m

@implementation IPSME_MsgEnv

+ (void) subscribe:(tp_handler)p_handler;
{
	CFNotificationCenterRef ncref_Distributed = CFNotificationCenterGetDistributedCenter();
	CFNotificationCenterAddObserver(ncref_Distributed,				        // CFNotificationCenterRef center
									(const void*)p_handler,		          	// const void *observer
									notification_callback,		        	// CFNotificationCallback callBack
									(__bridge CFStringRef)gk_NAME,          // CFStringRef name
									NULL, 						        	// const void *object
									CFNotificationSuspensionBehaviorDeliverImmediately // CFNotificationSuspensionBehavior suspensionBehavior
		);
}

+ (void) unsubscribe:(tp_handler)p_handler;
{
	CFNotificationCenterRef ncref_Distributed = CFNotificationCenterGetDistributedCenter();
	CFNotificationCenterRemoveObserver(ncref_Distributed,		        	// CFNotificationCenterRef center
									   (const void*)p_handler,	        	// const void *observer
                                       (__bridge CFStringRef)gk_NAME,       // CFNotificationName name
									   NULL					    	    	// const void *object
		);
}

+ (void) publish:(NSString*)nsstr
{
    NSDictionary* nsdic= @{
        gk_MSG : nsstr
    };
    
	CFNotificationCenterRef ncref_Distributed = CFNotificationCenterGetDistributedCenter();
	CFNotificationCenterPostNotification(ncref_Distributed,			    	// CFNotificationCenterRef center
                                         (__bridge CFStringRef)gk_NAME,     // CFNotificationName name
										 NULL,					    		// const void *object
										 (__bridge CFDictionaryRef)nsdic,   // CFDictionaryRef userInfo
										 YES					    		// Boolean deliverImmediately
		);
}

@end

@implementation IPSME_MsgEnv (Reflector)


// Even though object is a (const void*), if you don't pass an NSString*,
// you get an access exception.
//
+ (void) publish:(NSString*)nsstr withObject:(NSString*)object
{
    NSDictionary* nsdic= @{
        gk_MSG : nsstr
    };
    
	CFNotificationCenterRef ncref_Distributed = CFNotificationCenterGetDistributedCenter();
	CFNotificationCenterPostNotification(ncref_Distributed,			    	// CFNotificationCenterRef center
                                         (__bridge CFStringRef)gk_NAME,     // CFNotificationName name
										 (__bridge CFStringRef)object,  	// const void *object
                                         (__bridge CFDictionaryRef)nsdic,   // CFDictionaryRef userInfo
										 YES						    	// Boolean deliverImmediately
		);
}

@end
