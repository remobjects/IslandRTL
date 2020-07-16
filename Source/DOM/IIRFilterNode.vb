'''<Summary>The IIRFilterNode interface of the Web Audio API is a AudioNode processor which implements a general infinite impulse response (IIR)  filter; this type of filter can be used to implement tone control devices and graphic equalizers as well. It lets the parameters of the filter response be specified, so that it can be tuned as needed.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IIRFilterNode]
Inherits AudioNode

  '''<Summary>Uses the filter's current parameter settings to calculate the response for frequencies specified in the provided array of frequencies.</Summary>
  Sub [getFrequencyResponse]([parfrequencyArray] As Dynamic, [parmagResponseOutput] As Dynamic, [parphaseResponseOutput] As Dynamic)
End Interface