## objc-msgenv-NSDNC
Requires c++17.

**Yes, the ME for macOS, is this simple!**

Unfortunately due to a bug in Apple's code. When "nil" is specified as name when subscribing as an observer, the notification center should send out all notifications when the app is not sandboxed. However, this is not the case.  Apple needs to update the documentation or fix the code.

https://developer.apple.com/documentation/foundation/nsdistributednotificationcenter/1414151-addobserver

```
#import "msgenv_NSDNC.h"

void handler_(NSString* nsstr_msg, NSString* object)
{
  // object is unused (unless you make use of the hack)
  
}

int main(int argc, char* argv[])
{
  @autoreleasepool
  {
    [IPSME_MsgEnv subscribe:handler_];

    // ...
    
    [IPSME_MsgEnv publish:nsstr_msg];
  }
  return 0;
}
```
