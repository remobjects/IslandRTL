'''<summary>A key range can be a single value or a range with upper and lower bounds or endpoints. If the key range has both upper and lower bounds, then it is bounded; if it has no bounds, it is unbounded. A bounded key range can either be open (the endpoints are excluded) or closed (the endpoints are included). To retrieve all keys within a certain range, you can use the following code constructs:</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBKeyRange]
  '''<summary>Lower bound of the key range.</summary>
  ReadOnly Property [lower] As Integer
  '''<summary>Upper bound of the key range.</summary>
  ReadOnly Property [upper] As Integer
  '''<summary>Returns false if the lower-bound value is included in the key range.</summary>
  ReadOnly Property [lowerOpen] As Boolean
  '''<summary>Returns false if the upper-bound value is included in the key range.</summary>
  ReadOnly Property [upperOpen] As Boolean
  '''<summary>Creates a new key range with upper and lower bounds.</summary>
  Function [bound]([parlower] As Dynamic, [parupper] As Dynamic, [parlowerOpen] As Dynamic, [parupperOpen] As Dynamic) As IDBKeyRange
  '''<summary>Creates a new key range containing a single value.</summary>
  Function [only]() As Dynamic
  '''<summary>Creates a new key range with only a lower bound.</summary>
  Function [lowerBound]([parlower] As Dynamic, [paropen] As Dynamic) As IDBKeyRange
  '''<summary>Creates a new upper-bound key range.</summary>
  Function [upperBound]() As Integer
  '''<summary>Returns a boolean indicating whether a specified key is inside the key range.</summary>
  Function [includes]() As Boolean
End Interface