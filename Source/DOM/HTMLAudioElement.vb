'''<Summary>The HTMLAudioElement interface provides access to the properties of &lt;audio> elements, as well as methods to manipulate them.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLAudioElement]
'Defined on this type 
  '''<Summary>Creates and returns a new HTMLAudioElement object, optionally starting the process of loading an audio file into it if the file URL is given.</Summary>
  Function [Audio]([parurl] As Dynamic) As HTMLAudioElement
End Interface