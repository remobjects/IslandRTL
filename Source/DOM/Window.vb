'''<Summary>The Window interface represents a window containing a DOM document; the document property points to the DOM document loaded in that window.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Window]
  '''<Summary>Returns a reference to the console object which provides access to the browser's debugging console.</Summary>
  ReadOnly Property [console] As Dynamic
  '''<Summary>returns a reference to the CustomElementRegistry object, which can be used to register new custom elements and get information about previously registered custom elements.</Summary>
  ReadOnly Property [customElements] As Dynamic
  '''<Summary>Returns the browser crypto object.</Summary>
  ReadOnly Property [crypto] As Dynamic
  '''<Summary>Gets the arguments passed to the window (if it's a dialog box) at the time window.showModalDialog() was called. This is an nsIArray.</Summary>
  ReadOnly Property [dialogArguments] As Dynamic
  '''<Summary>Returns a reference to the document that the window contains.</Summary>
  ReadOnly Property [document] As Dynamic
  '''<Summary>Returns the current event, which is the event currently being handled by the JavaScript code's context, or undefined if no event is currently being handled. The Event object passed directly to event handlers should be used instead whenever possible.</Summary>
  ReadOnly Property [event] As Dynamic
  '''<Summary>Returns the element in which the window is embedded, or null if the window is not embedded.</Summary>
  ReadOnly Property [frameElement] As Element
  '''<Summary>Returns an array of the subframes in the current window.</Summary>
  ReadOnly Property [frames] As Document()
  '''<Summary>This property indicates whether the window is displayed in full screen or not.</Summary>
  Property [fullScreen] As Dynamic
  '''<Summary>Returns a reference to the history object.</Summary>
  ReadOnly Property [history] As Dynamic
  '''<Summary>Gets the height of the content area of the browser window including, if rendered, the horizontal scrollbar.</Summary>
  ReadOnly Property [innerHeight] As Integer
  '''<Summary>Gets the width of the content area of the browser window including, if rendered, the vertical scrollbar.</Summary>
  ReadOnly Property [innerWidth] As Integer
  '''<Summary>Returns the number of frames in the window. See also window.frames.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Gets/sets the location, or current URL, of the window object.</Summary>
  Property [location] As Dynamic
  '''<Summary>Returns the locationbar object, whose visibility can be toggled in the window.</Summary>
  ReadOnly Property [locationbar] As Dynamic
  '''<Summary>Returns a reference to the local storage object used to store data that may only be accessed by the origin that created it.</Summary>
  ReadOnly Property [localStorage] As Dynamic
  '''<Summary>Returns the menubar object, whose visibility can be toggled in the window.</Summary>
  ReadOnly Property [menubar] As Dynamic
  '''<Summary>Returns the message manager object for this window.</Summary>
  Property [messageManager] As Dynamic
  '''<Summary>Gets/sets the name of the window.</Summary>
  Property [name] As String
  '''<Summary>Returns a reference to the navigator object.</Summary>
  ReadOnly Property [navigator] As Dynamic
  '''<Summary>Returns a reference to the window that opened this current window.</Summary>
  Property [opener] As Dynamic
  '''<Summary>Gets the height of the outside of the browser window.</Summary>
  ReadOnly Property [outerHeight] As Integer
  '''<Summary>Gets the width of the outside of the browser window.</Summary>
  ReadOnly Property [outerWidth] As Integer
  '''<Summary>Returns a reference to the parent of the current window or subframe.</Summary>
  ReadOnly Property [parent] As Dynamic
  '''<Summary>Returns a Performance object, which includes the timing and navigation attributes, each of which is an object providing performance-related data. See also Using Navigation Timing for additional information and examples.</Summary>
  ReadOnly Property [performance] As Dynamic
  '''<Summary>Returns the personalbar object, whose visibility can be toggled in the window.</Summary>
  ReadOnly Property [personalbar] As Dynamic
  '''<Summary>Returns a reference to the screen object associated with the window.</Summary>
  ReadOnly Property [screen] As Dynamic
  '''<Summary>Both properties return the horizontal distance from the left border of the user's browser viewport to the left side of the screen.</Summary>
  ReadOnly Property [screenX] As Dynamic
  '''<Summary>Both properties return the vertical distance from the top border of the user's browser viewport to the top side of the screen.</Summary>
  ReadOnly Property [screenY] As Dynamic
  '''<Summary>Returns the scrollbars object, whose visibility can be toggled in the window.</Summary>
  ReadOnly Property [scrollbars] As Dynamic
  '''<Summary>Returns the number of pixels that the document has already been scrolled horizontally.</Summary>
  ReadOnly Property [scrollX] As Integer
  '''<Summary>Returns the number of pixels that the document has already been scrolled vertically.</Summary>
  ReadOnly Property [scrollY] As Integer
  '''<Summary>Returns a reference to the session storage object used to store data that may only be accessed by the origin that created it.</Summary>
  Property [sessionStorage] As Dynamic
  '''<Summary>Gets/sets the text in the statusbar at the bottom of the browser.</Summary>
  Property [status] As String
  '''<Summary>Returns the statusbar object, whose visibility can be toggled in the window.</Summary>
  ReadOnly Property [statusbar] As Dynamic
  '''<Summary>Returns the toolbar object, whose visibility can be toggled in the window.</Summary>
  ReadOnly Property [toolbar] As Dynamic
  '''<Summary>Returns a reference to the topmost window in the window hierarchy. This property is read only.</Summary>
  ReadOnly Property [top] As Dynamic
  '''<Summary>Returns a VisualViewport object which represents the visual viewport for a given window.</Summary>
  ReadOnly Property [visualViewport] As Dynamic
  '''<Summary>Returns a reference to the current window.</Summary>
  ReadOnly Property [window] As Dynamic
  '''<Summary>Returns the CacheStorage object associated with the current context. This object enables functionality such as storing assets for offline use, and generating custom responses to requests.</Summary>
  ReadOnly Property [caches] As Dynamic
  '''<Summary>Provides a mechanism for applications to asynchronously access capabilities of indexed databases; returns an IDBFactory object.</Summary>
  ReadOnly Property [indexedDB] As Dynamic
  '''<Summary>Returns a boolean indicating whether the current context is secure (true) or not (false).</Summary>
  ReadOnly Property [isSecureContext] As Boolean
  '''<Summary>Returns the global object's origin, serialized as a string. (This does not yet appear to be implemented in any browser.)</Summary>
  ReadOnly Property [origin] As String
  '''<Summary>Called when the page is installed as a webapp. See appinstalled event.</Summary>
  Property [onappinstalled] As EventListener
  '''<Summary>An event handler property dispatched before a user is prompted to save a web site to a home screen on mobile.</Summary>
  Property [onbeforeinstallprompt] As EventListener
  '''<Summary>An event handler property for any ambient light levels changes</Summary>
  Property [ondevicelight] As EventListener
  '''<Summary>Called if accelerometer detects a change (For mobile devices)</Summary>
  Property [ondevicemotion] As EventListener
  '''<Summary>Called when the orientation is changed (For mobile devices)</Summary>
  Property [ondeviceorientation] As EventListener
  '''<Summary>An event handler property for device proximity event</Summary>
  Property [ondeviceproximity] As EventListener
  '''<Summary>Represents an event handler that will run when a gamepad is connected (when the gamepadconnected event fires).</Summary>
  Property [ongamepadconnected] As EventListener
  '''<Summary>Represents an event handler that will run when a gamepad is disconnected (when the gamepaddisconnected event fires).</Summary>
  Property [ongamepaddisconnected] As EventListener
  '''<Summary>An event handler property for the MozBeforePaint event, which is sent before repainting the window if the event has been requested by a call to the Window.mozRequestAnimationFrame() method.</Summary>
  Property [onmozbeforepaint] As EventListener
  '''<Summary>An event handler property for paint events on the window.</Summary>
  Property [onpaint] As EventListener
  '''<Summary>An event handler property for user proximity events.</Summary>
  Property [onuserproximity] As EventListener
  '''<Summary>Represents an event handler that will run when a compatible VR device has been connected to the computer (when the vrdisplayconnected event fires).</Summary>
  Property [onvrdisplayconnect] As EventListener
  '''<Summary>Represents an event handler that will run when a compatible VR device has been disconnected from the computer (when the vrdisplaydisconnected event fires).</Summary>
  Property [onvrdisplaydisconnect] As EventListener
  '''<Summary>Represents an event handler that will run when a display is able to be presented to (when the vrdisplayactivate event fires), for example if an HMD has been moved to bring it out of standby, or woken up by being put on.</Summary>
  Property [onvrdisplayactivate] As EventListener
  '''<Summary>Represents an event handler that will run when a display can no longer be presented to (when the vrdisplaydeactivate event fires), for example if an HMD has gone into standby or sleep mode due to a period of inactivity.</Summary>
  Property [onvrdisplaydeactivate] As EventListener
  '''<Summary>Represents an event handler that will run when presentation to a display has been paused for some reason by the browser, OS, or VR hardware (when the vrdisplayblur event fires) — for example, while the user is interacting with a system menu or browser, to prevent tracking or loss of experience.</Summary>
  Property [onvrdisplayblur] As EventListener
  '''<Summary>Represents an event handler that will run when presentation to a display has resumed after being blurred (when the vrdisplayfocus event fires).</Summary>
  Property [onvrdisplayfocus] As EventListener
  '''<Summary>represents an event handler that will run when the presenting state of a VR device changes — i.e. goes from presenting to not presenting, or vice versa (when the vrdisplaypresentchange event fires).</Summary>
  Property [onvrdisplaypresentchange] As EventListener
End Interface