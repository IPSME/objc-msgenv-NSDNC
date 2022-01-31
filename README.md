## objc-msgenv-NSDNC

Yes, the ME for macOS, is that simple!

```
void handler_(NSString* nsstr_msg, NSString* object)
{
  // object is unused (unless you make use of the hack)
  
}

int main(int argc, char* argv[])
{
  @autoreleasepool
  {
    [MsgEnv_NSDNC subscribe:handler_];

    // ...
    
    [MsgEnv_NSDNC publish:nsstr_msg];
  }
  return 0;
}
```
