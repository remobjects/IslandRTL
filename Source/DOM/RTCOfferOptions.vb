'''<Summary>The RTCOfferOptions dictionary is used to provide optional settings when creating an RTCPeerConnection offer with the createOffer() method.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCOfferOptions]
  '''<Summary>A Boolean which, when set to true, tells createOffer() to generate and use new values for the identifying properties of the SDP it creates, resulting in a request that triggers renegotiation of the ICE connection. This is useful if network conditions have changed in a way that make the current configuration untenable or impractical, for instance.</Summary>
  Property [iceRestart] As RTCPeerConnection
End Interface