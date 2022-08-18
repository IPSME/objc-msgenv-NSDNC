
## objc-msgenv-NSDNC

<!--- Requires c++17. -->

**Yes, the ME for macOS, is this simple!**

I might be noted that in the code below, all messages are sent using an "IPSME" name and therefore not all notifications are received on the ME. This is unfortunately due to a bug in Apple's code. When "nil" is specified as name when subscribing as an observer, the notification center should send out all notifications when the app is not sandboxed. However, this is not the case.  Apple needs to update the documentation or fix the code.
https://developer.apple.com/documentation/foundation/nsdistributednotificationcenter/1414151-addobserver


### Subscribing
```
#import "IPSME_MsgEnv.h"

void handler_(NSString* nsstr_msg, NSString* object)
{
	// object is unused (unless you make use of the hack)
  
	// ...
}

int main(int argc, char* argv[])
{
	// ...
	
	[IPSME_MsgEnv subscribe:handler_];
	
	// ...
	
	return 0;
}
```

If you would like to avoid using this wrapper functions, the equivalent native Objective-C code produces the same effect.
```
{
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self
							    selector:@selector(recvd:)
						 		name:@"IPSME"
							      object:nil];
}

- (void) recvd:(NSNotification *)notification {
	NSLog(@"recvd %@", notification.userInfo[@"msg"]);
}

```

----

### Publishing
```
{
	[IPSME_MsgEnv publish:nsstr_msg];
}
```

If you would like to avoid using this wrapper functions, the equivalent native Objective-C code produces the same effect.
```
{
	NSDictionary* nsdic_UserInfo= @{
		@"msg" : @"a message"
	};

	NSDistributedNotificationCenter* dnc= [NSDistributedNotificationCenter defaultCenter];
	[dnc postNotificationName:@"IPSME" object:nil userInfo:nsdic_UserInfo deliverImmediately:TRUE];
}
```
