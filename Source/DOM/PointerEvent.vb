'''<Summary>The PointerEvent interface represents the state of a DOM event produced by a pointer such as the geometry of the contact point, the device type that generated the event, the amount of pressure that was applied on the contact surface, etc.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PointerEvent]
'Defined on this type 
  '''<Summary>A unique identifier for the pointer causing the event.</Summary>
  ReadOnly Property [pointerId] As Integer
  '''<Summary>The width (magnitude on the X axis), in CSS pixels, of the contact geometry of the pointer.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>The height (magnitude on the Y axis), in CSS pixels, of the contact geometry of the pointer.</Summary>
  ReadOnly Property [height] As Integer
  '''<Summary>The normalized pressure of the pointer input in the range 0 to 1, where 0 and 1 represent the minimum and maximum pressure the hardware is capable of detecting, respectively.</Summary>
  ReadOnly Property [pressure] As Integer
  '''<Summary>The normalized tangential pressure of the pointer input (also known as barrel pressure or cylinder stress) in the range -1 to 1, where 0 is the neutral position of the control.</Summary>
  ReadOnly Property [tangentialPressure] As Integer
  '''<Summary>The plane angle (in degrees, in the range of -90 to 90) between the Y–Z plane and the plane containing both the pointer (e.g. pen stylus) axis and the Y axis.</Summary>
  ReadOnly Property [tiltX] As Double
  '''<Summary>The plane angle (in degrees, in the range of -90 to 90) between the X–Z plane and the plane containing both the pointer (e.g. pen stylus) axis and the X axis.</Summary>
  ReadOnly Property [tiltY] As Double
  '''<Summary>The clockwise rotation of the pointer (e.g. pen stylus) around its major axis in degrees, with a value in the range 0 to 359.</Summary>
  ReadOnly Property [twist] As Dynamic
  '''<Summary>Indicates the device type that caused the event (mouse, pen, touch, etc.)</Summary>
  ReadOnly Property [pointerType] As Dynamic
  '''<Summary>Indicates if the pointer represents the primary pointer of this pointer type.</Summary>
  ReadOnly Property [isPrimary] As Boolean
End Interface