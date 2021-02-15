'''<summary>The WebXR Device API's XRSession interface represents an ongoing XR session, providing methods and properties used to interact with and control the session. To open a WebXR session, use the XRSystem interface's requestSession() method.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRSession]
Inherits EventTarget

  '''<summary>Removes a callback from the animation frame painting callback from XRSession's set of animation frame rendering callbacks, given the identifying handle returned by a previous call to requestAnimationFrame().</summary>
  Function [cancelAnimationFrame]([parhandle] As Dynamic) As Dynamic
  '''<summary>Ends the WebXR session. Returns a promise which resolves when the session has been shut down.</summary>
  Function [end]() As Dynamic
  '''<summary>Schedules the specified method to be called the next time the user agent is working on rendering an animation frame for the WebXR device. Returns an integer value which can be used to identify the request for the purposes of canceling the callback using cancelAnimationFrame(). This method is comparable to the Window.requestAnimationFrame() method.</summary>
  Function [requestAnimationFrame]([paranimationFrameCallback] As Dynamic) As Integer
  '''<summary>Requests that a new XRReferenceSpace of the specified type be created. Returns a promise which resolves with the XRReferenceSpace or XRBoundedReferenceSpace which was requested, or throws a NotSupportedError if the requested space type isn't supported by the device.</summary>
  Function [requestReferenceSpace]([partype] As Dynamic) As Dynamic
  '''<summary>Updates the properties of the session's render state to match the values specified in the specified XRRenderStateInit dictionary. Any properties not included in the given dictionary are left unchanged from their current values.</summary>
  Function [updateRenderState]([parnewState] As Dynamic) As Integer
End Interface