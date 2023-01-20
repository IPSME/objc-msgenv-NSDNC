
# objc-msgenv-NSDNC

Unfortunately due to a bug in Apple's code, specifying `nil` as the `name` does not work. 

When `nil` is specified as `name` when subscribing as an observer, the notification center **should** send out all notifications to the handler, when the app is not sandboxed. However, this is not the case.  
Apple has been contacted and is aware of the bug, but had no plans of addressing it.

It would be good if Apple either fixed the code or updated the documentation.

> https://developer.apple.com/documentation/foundation/nsdistributednotificationcenter/1414151-addobserver
> 
> *"When `nil`, the notification center doesn’t use a notification’s name to decide whether to deliver it to the observer."*

### As a workaround, please use the `userInfo` branch of this repository

https://github.com/IPSME/objc-msgenv-NSDNC/tree/userInfo

