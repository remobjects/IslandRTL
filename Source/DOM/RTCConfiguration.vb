'''<summary>The RTCConfiguration dictionary is used to provide configuration options for an RTCPeerConnection. It may be passed into the constructor when instantiating a connection, or used with the RTCPeerConnection.getConfiguration() and RTCPeerConnection.setConfiguration() methods, which allow inspecting and changing the configuration while a connection is established.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCConfiguration]
  '''<summary>Specifies how to handle negotiation of candidates when the remote peer is not compatible with the SDP BUNDLE standard. This must be one of the values from the enum RTCBundlePolicy. If this value isn't included in the dictionary, "balanced" is assumed.</summary>
  Property [bundlePolicy] As Dynamic
  '''<summary>An Array of objects of type RTCCertificate which are used by the connection for authentication. If this property isn't specified, a set of certificates is generated automatically for each RTCPeerConnection instance. Although only one certificate is used by a given connection, providing certificates for multiple algorithms may improve the odds of successfully connecting in some circumstances. See Using certificates below for additional information.</summary>
  Property [certificates] As RTCCertificate()
  '''<summary>An unsigned 16-bit integer value which specifies the size of the prefetched ICE candidate pool. The default value is 0 (meaning no candidate prefetching will occur). You may find in some cases that connections can be established more quickly by allowing the ICE agent to start fetching ICE candidates before you start trying to connect, so that they're already available for inspection when RTCPeerConnection.setLocalDescription() is called.</summary>
  Property [iceCandidatePoolSize] As Integer
  '''<summary>The current ICE transport policy; this must be one of the values from the RTCIceTransportPolicy enum. If this isn't specified, "all" is assumed.</summary>
  Property [iceTransportPolicy] As Dynamic
  '''<summary>A DOMString which specifies the target peer identity for the RTCPeerConnection. If this value is set (it defaults to null), the RTCPeerConnection will not connect to a remote peer unless it can successfully authenticate with the given name.</summary>
  Property [peerIdentity] As String
  '''<summary>The RTCP mux policy to use when gathering ICE candidates, in order to support non-multiplexed RTCP. The value must be one of those from the RTCRtcpMuxPolicy enum. The default is "require".</summary>
  Property [rtcpMuxPolicy] As Dynamic
End Interface