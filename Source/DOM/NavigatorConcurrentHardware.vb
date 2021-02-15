'''<summary>The NavigatorConcurrentHardware mixin adds to the Navigator interface features which allow Web content to determine how many logical processors the user has available, in order to let content and Web apps optimize their operations to best take advantage of the user's CPU.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NavigatorConcurrentHardware]
  '''<summary>Returns the number of logical processors which may be available to the user agent. This value is always at least 1, and will be 1 if the actual number of logical processors can't be determined.</summary>
  ReadOnly Property [hardwareConcurrency] As Double
End Interface