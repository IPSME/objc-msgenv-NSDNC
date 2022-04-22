## objc-msgenv-NSDNC
Requires c++17.

Yes, the ME for macOS, is that simple!

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
