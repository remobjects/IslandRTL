'''<Summary>The pan property takes a unitless value between -1 (full left pan) and 1 (full right pan). This interface was introduced as a much simpler way to apply a simple panning effect than having to use a full PannerNode.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [StereoPannerNode]
Inherits AudioNode

  '''<Summary>Is an a-rate AudioParam representing the amount of panning to apply.</Summary>
  ReadOnly Property [pan] As AudioParam
End Interface