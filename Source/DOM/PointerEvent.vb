'''<summary>The PointerEvent interface represents the state of a DOM event produced by a pointer such as the geometry of the contact point, the device type that generated the event, the amount of pressure that was applied on the contact surface, etc.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PointerEvent]
  '''<summary>A unique identifier for the pointer causing the event.</summary>
  ReadOnly Property [pointerId] As Integer
  '''<summary>The width (magnitude on the X axis), in CSS pixels, of the contact geometry of the pointer.</summary>
  ReadOnly Property [width] As Integer
  '''<summary>The height (magnitude on the Y axis), in CSS pixels, of the contact geometry of the pointer.</summary>
  ReadOnly Property [height] As Integer
  '''<summary>The normalized pressure of the pointer input in the range 0 to 1, where 0 and 1 represent the minimum and maximum pressure the hardware is capable of detecting, respectively.</summary>
  ReadOnly Property [pressure] As Integer
  '''<summary>The normalized tangential pressure of the pointer input (also known as barrel pressure or cylinder stress) in the range -1 to 1, where 0 is the neutral position of the control.</summary>
  ReadOnly Property [tangentialPressure] As Integer
  '''<summary>The plane angle (in degrees, in the range of -90 to 90) between the Y–Z plane and the plane containing both the pointer (e.g. pen stylus) axis and the Y axis.</summary>
  ReadOnly Property [tiltX] As Double
  '''<summary>The plane angle (in degrees, in the range of -90 to 90) between the X–Z plane and the plane containing both the pointer (e.g. pen stylus) axis and the X axis.</summary>
  ReadOnly Property [tiltY] As Double
  '''<summary>The clockwise rotation of the pointer (e.g. pen stylus) around its major axis in degrees, with a value in the range 0 to 359.</summary>
  ReadOnly Property [twist] As Dynamic
  '''<summary>Indicates the device type that caused the event (mouse, pen, touch, etc.)</summary>
  ReadOnly Property [pointerType] As Dynamic
  '''<summary>Indicates if the pointer represents the primary pointer of this pointer type.</summary>
  ReadOnly Property [isPrimary] As Boolean
End Interface