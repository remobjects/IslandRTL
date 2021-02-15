'''<summary>The NavigatorStorage mixin adds to the Navigator and WorkerNavigator interfaces the Navigator.storage property, which provides access to the StorageManager singleton used for controlling the persistence of data stores as well as obtaining information</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NavigatorStorage]
  '''<summary>Returns the StorageManager singleton object which is used to access the Storage Manager. Through the returned object, you can control persistence of data stores as well as get estimates of how much space is left for your site or appliation to store data.</summary>
  ReadOnly Property [storage] As Dynamic
End Interface