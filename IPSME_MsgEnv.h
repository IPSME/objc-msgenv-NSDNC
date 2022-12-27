//
//  msgenv_NSDNC.h
//
//  Created by dev on 2021-10-27.
//  Copyright © 2021 Root Interface. All rights reserved.
//

// The second NSString* is NULL, unless the Reflector hack below is used
//
typedef void (*tp_handler)(NSString*,NSString*);


@interface IPSME_MsgEnv : NSObject

// https://developer.apple.com/documentation/foundation/nsdistributednotificationcenter
// For multithreaded applications running in macOS 10.3 and later,
// distributed notifications are always delivered to the main thread.
//
+ (void) subscribe:(tp_handler)p_handler DEPRECATED_MSG_ATTRIBUTE("Apple silently fails to support nil as name, contrary to docs; use repo branch: userInfo");
+ (void) unsubscribe:(tp_handler)p_handler DEPRECATED_MSG_ATTRIBUTE("Apple silently fails to support nil as name, contrary to docs; use repo branch: userInfo");

// https://developer.apple.com/documentation/foundation/nsdistributednotificationcenter
// Posting a distributed notification is an expensive operation. The notification gets sent to a
// system-wide server that distributes it to all the tasks that have objects registered for distributed
// notifications. The latency between posting the notification and the notification’s arrival in
// another task is unbounded. In fact, when too many notifications are posted and the server’s queue
// fills up, notifications may be dropped.
//
+ (void) publish:(NSString*)nsstr DEPRECATED_MSG_ATTRIBUTE("Apple silently fails to support nil as name, contrary to docs; use repo branch: userInfo");

@end

// This hack allows for an object to be sent,
// which in turn can be used to remove ricocheted messages
// e.g., send a UUID and drop incoming messages with that UUID
//
@interface IPSME_MsgEnv (Reflector)

+ (void) publish:(NSString*)nsstr withObject:(NSString*)object;

@end
