//
//  msgenv_NSDNC.h
//  objc-zmq-reflector
//
//  Created by dev on 2021-10-27.
//  Copyright © 2021 Root Interface. All rights reserved.
//

// The (const void*) is NULL, unless the Reflector hack below is used
//
typedef void (*t_handler_ptr)(NSString*,NSString*);
						  
@interface MsgEnv_NSDNC : NSObject

+ (void) subscribe:(t_handler_ptr)handler_ptr;
+ (void) unsubscribe:(t_handler_ptr)handler_ptr;
+ (void) publish:(NSString*)nsstr;

@end

// This hack allows for an object to be sent,
// which in turn can be used to remove ricocheted messages
// e.g., send a UUID and drop incoming messages with that UUID
//
@interface MsgEnv_NSDNC (Reflector)

+ (void) publish:(NSString*)nsstr withObject:(NSString*)object;

@end
