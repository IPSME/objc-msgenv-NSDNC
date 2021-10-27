//
//  msgenv_NSDNC.h
//  objc-zmq-reflector
//
//  Created by dev on 2021-10-27.
//  Copyright © 2021 Root Interface. All rights reserved.
//

typedef void (*t_handler_ptr)(NSString*);
						  
@interface MsgEnv_NSDNC : NSObject

+ (void) subscribe:(t_handler_ptr)handler_ptr;
+ (void) unsubscribe;
+ (void) publish:(NSString*)nsstr;

@end
