
# objc-msgenv-NSDNC :: UE5

This library contains the wrapper code for sending messages to the macOS messaging environment (ME). The ready available pubsub between processes on macOS is the `NSDistributedNotificationCenter`.

> ### IPSME- Idempotent Publish/Subscribe Messaging Environment
> https://dl.acm.org/doi/abs/10.1145/3458307.3460966

#### Subscribing
```
void handler_(const char* psz_msg, void* p_void)
{
	try
	{
		// add handlers ...
	}
	catch (...) {
		UE_LOG(LogTemp, Error, TEXT("handler_(): Exception "));
	}

	 UE_LOG(LogTemp, Warning, TEXT("handler_(): DROP! [%s]"), *FString(psz_msg) );
}


IPSME_MsgEnv::subscribe(handler_, NULL);
```

It is by design that a participant receives the messages it has published itself. If this is not desirable, each message can contain a "referer" (sic) identifier and a clause added in the `ipsme_handler_` to drop those messages containing the participant's own referer id.

#### Publishing
```
IPSME_MsgEnv::publish("...");
```

## Discussion

The ME utilized, as so mentioned in the name, is `NSDistributedNotificationCenter`. This "library" is entirely optional. IPSME dictates the use of a readily available pubsub. That means the code is roughly equal to the following:

 #### Subscribing
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
I have chosen to use the 'IPSME' channel name although the IPSME specification doesn't divide communication into different channels; all IPSME participants receive all messages. Each channel is equal to a different ME with respect to the IPSME conventions.

**Note:** Because there is a bug in Apple's code and `nil` is no longer accepted a filter for `name`. The workaround is to use "IPSME" as `name` and send the message in `userInfo`. The problem with this approach is that Apple has forbidden this approach for sandboxed applications.

> https://developer.apple.com/documentation/security/app_sandbox/protecting_user_data_with_app_sandbox?language=objc
>
> "Certain activities are forbidden by the operating system when an app runs in a sandbox.
>  ... Sending `userInfo` dictionaries in distributed notifications to other tasks."

IPSME dictates the use of any ready available pubsub. It is entirely possible to use a third-party pubsub via networking to avoid Apple's overly stringent measures.

#### Publishing
```
{
	NSDictionary* nsdic_UserInfo= @{
		@"msg" : @"a message"
	};

	NSDistributedNotificationCenter* dnc= [NSDistributedNotificationCenter defaultCenter];
	[dnc postNotificationName:@"IPSME" object:nil userInfo:nsdic_UserInfo deliverImmediately:TRUE];
}
```

