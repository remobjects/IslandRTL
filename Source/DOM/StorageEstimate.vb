'''<summary>The StorageEstimate dictionary is used by the StorageManager to provide estimates of the size of a site's or application's data store and how much of it is in use. The estimate() method returns an object that conforms to this dictionary when its Promise resolves.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [StorageEstimate]
  '''<summary>A numeric value in bytes which provides a conservative approximation of the total storage the user's device or computer has available for the site origin or Web app. It's possible that there's more than this amount of space available though you can't rely on that being the case.</summary>
  Property [quota] As Double
  '''<summary>A numeric value in bytes approximating the amount of storage space currently being used by the site or Web app, out of the available space as indicated by quota. Unit is byte.</summary>
  Property [usage] As Double
  '''<summary>A dictionary containing a breakdown of usage by storage system.  All included members will have a usage greater than 0 and any storage system with 0 usage will be excluded from the dictionary.  </summary>
  Property [usageDetails] As Dynamic
End Interface