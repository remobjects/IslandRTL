'''<Summary>A key range can be a single value or a range with upper and lower bounds or endpoints. If the key range has both upper and lower bounds, then it is bounded; if it has no bounds, it is unbounded. A bounded key range can either be open (the endpoints are excluded) or closed (the endpoints are included). To retrieve all keys within a certain range, you can use the following code constructs:</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBKeyRange]
  '''<Summary>Lower bound of the key range.</Summary>
  ReadOnly Property [lower] As Integer
  '''<Summary>Upper bound of the key range.</Summary>
  ReadOnly Property [upper] As Integer
  '''<Summary>Returns false if the lower-bound value is included in the key range.</Summary>
  ReadOnly Property [lowerOpen] As Boolean
  '''<Summary>Returns false if the upper-bound value is included in the key range.</Summary>
  ReadOnly Property [upperOpen] As Boolean
End Interface