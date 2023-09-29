//
//  IPSME_MsgEnv.h
//
//  Created by dev on 2021-10-27.
//  Copyright © 2021 Root Interface. All rights reserved.
//

#ifndef IPSME_MsgEnv_h
#define IPSME_MsgEnv_h

namespace IPSME_MsgEnv
{
	typedef void (*tp_callback)(const char* psz_msg, void* p_void);
	typedef int RET_TYPE;

	// https://developer.apple.com/documentation/foundation/nsdistributednotificationcenter
	// For multithreaded applications running in macOS 10.3 and later,
	// distributed notifications are always delivered to the main thread.
	//
	RET_TYPE subscribe(tp_callback p_callback, void* p_void);
	RET_TYPE unsubscribe(tp_callback p_callback);

	// https://developer.apple.com/documentation/foundation/nsdistributednotificationcenter
	// Posting a distributed notification is an expensive operation. The notification gets sent to a
	// system-wide server that distributes it to all the tasks that have objects registered for distributed
	// notifications. The latency between posting the notification and the notification’s arrival in
	// another task is unbounded. In fact, when too many notifications are posted and the server’s queue
	// fills up, notifications may be dropped.
	//
	RET_TYPE publish(const char* psz_msg);

	RET_TYPE process_requests(int i_timeout= 0);
}

#endif /* IPSME_MsgEnv_h */
 
