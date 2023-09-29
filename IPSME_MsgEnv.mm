//
//  msgenv_NSDNC.m
//
//  Created by dev on 2021-10-27.
//  Copyright © 2021 Root Interface. All rights reserved.
//

#include <unordered_map>
#include <functional>

#import <Foundation/Foundation.h>
#import "IPSME_MsgEnv.h"
using IPSME_MsgEnv::RET_TYPE;

NSString* gk_NAME= @"IPSME";
NSString* gk_MSG= @"msg";

//-----------------------------------------------------------------------------------------------------------------------------------------

typedef std::unordered_map<IPSME_MsgEnv::tp_callback, void*> t_umap;
t_umap umap_;

void notification_callback(CFNotificationCenterRef center,
						   void* p_observer,
						   CFNotificationName name,
						   const void* object,
						   CFDictionaryRef userInfo)
{
	// NSString *nsstr_name= (__bridge NSString *)name; // == @"IPSME"
    NSString *nsstr_obj= (__bridge NSString *)object;
    NSDictionary* nsdic_userInfo= (__bridge NSDictionary*)userInfo;
	id id_msg= nsdic_userInfo[gk_MSG];
    assert(id_msg != nil);
    
	if (! [id_msg isKindOfClass:[NSString class] ])
		return;
	
	NSString* nsstr_msg= (NSString*)id_msg;
	
	// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Exceptions/Tasks/HandlingExceptions.html
	@try {
		IPSME_MsgEnv::tp_callback p_callback= (IPSME_MsgEnv::tp_callback)p_observer;
		
		assert(umap_.find(p_callback) != umap_.end());
		void* p_void= umap_[p_callback];
		
		p_callback([nsstr_msg UTF8String], p_void);
	}
	@catch (id ue) {
		// NSLog(@"notification_callback: DROP!");
		assert(false);
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------------

// Sandboxing:
//		https://stackoverflow.com/questions/36687525/nsdistributednotificationcenter-not-working
//		https://developer.apple.com/forums/thread/129437
// Example: https://github.com/RabbitMC/DistributedNotifications/blob/master/DistributedNotifications/NotificationsManager/NotificationsManager.m


RET_TYPE IPSME_MsgEnv::subscribe(IPSME_MsgEnv::tp_callback p_callback, void* p_void)
{
	umap_[p_callback]= p_void;
	
	@autoreleasepool
	{
		// Even though *object is a (const void*), if you don't pass an NSString*,
		// you get an access exception.
		//
		CFNotificationCenterRef ncref_Distributed = CFNotificationCenterGetDistributedCenter();
		CFNotificationCenterAddObserver(ncref_Distributed,				        // CFNotificationCenterRef center
										(const void*)p_callback,	          	// const void *observer
										notification_callback,		        	// CFNotificationCallback callBack
										(__bridge CFStringRef)gk_NAME,          // CFStringRef name
										NULL, 						        	// const void *object
										CFNotificationSuspensionBehaviorDeliverImmediately // CFNotificationSuspensionBehavior suspensionBehavior
			);
	}

	return 0;
}

RET_TYPE IPSME_MsgEnv::unsubscribe(IPSME_MsgEnv::tp_callback p_callback)
{
	@autoreleasepool
	{
		CFNotificationCenterRef ncref_Distributed = CFNotificationCenterGetDistributedCenter();
		CFNotificationCenterRemoveObserver(ncref_Distributed,		        	// CFNotificationCenterRef center
										   (const void*)p_callback,	   			// const void *observer
										   (__bridge CFStringRef)gk_NAME,       // CFNotificationName name
										   NULL					    	    	// const void *object
			);
	}
	
	umap_.erase(p_callback);
	return 0;
}

RET_TYPE IPSME_MsgEnv::publish(const char* psz_msg)
{
	@autoreleasepool
	{
		NSString* nsstr_msg = [NSString stringWithUTF8String:psz_msg];
		NSDictionary* nsdic= @{
			gk_MSG : nsstr_msg
		};
		
		CFNotificationCenterRef ncref_Distributed = CFNotificationCenterGetDistributedCenter();
		CFNotificationCenterPostNotification(ncref_Distributed,			    	// CFNotificationCenterRef center
											 (__bridge CFStringRef)gk_NAME,     // CFNotificationName name
											 NULL,					    		// const void *object
											 (__bridge CFDictionaryRef)nsdic,   // CFDictionaryRef userInfo
											 YES					    		// Boolean deliverImmediately
			);
	}

	return 0;
}

// This hack allows for an object to be sent,
// which in turn can be used to remove ricocheted messages
// e.g., send a UUID and drop incoming messages with that UUID
//
/*

@interface IPSME_MsgEnv_NSDNC (Reflector)
+ (void) publish:(id)msg withObject:(NSString*)object;
@end
 
@implementation IPSME_MsgEnv (Reflector)

// Even though object is a (const void*), if you don't pass an NSString*,
// you get an access exception.
//
+ (void) publish:(id)id_msg withObject:(NSString*)object
{
	NSDictionary* nsdic= @{
		gk_MSG : id_msg
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
*/

RET_TYPE IPSME_MsgEnv::process_requests(int i_timeout) {
	return 0;
}
