namespace IslandSocketTests;

type
  Program = class
  private

    class var fChecks: Integer;

    class method Check(aValue: Boolean; aMessage: String);
    begin
      if not aValue then
        raise new Exception('FAIL: '+aMessage);
      inc(fChecks);
      writeLn('PASS: '+aMessage);
    end;

    class method NewSocket(aIPv6: Boolean; aUDP: Boolean := false): Socket;
    begin
      result := new Socket(if aIPv6 then AddressFamily.InterNetworkV6 else AddressFamily.InterNetwork,
                           if aUDP then SocketType.Dgram else SocketType.Stream,
                           if aUDP then ProtocolType.Udp else ProtocolType.Tcp);
    end;

    class method Loopback(aIPv6: Boolean): IPAddress;
    begin
      result := IPAddress.Parse(if aIPv6 then '::1' else '127.0.0.1');
    end;

    class method TestAddresses;
    begin
      var lBytes: array of Byte := [$fe, $80, $12, $34, $56, $78, $9a, $bc, $de, $f0, 1, 2, 3, 4, 5, 6];
      var lAddress := new IPAddress(lBytes, 7);
      var lRoundTrip := lAddress.GetAddressBytes;
      for i := 0 to 15 do
        Check(lBytes[i] = lRoundTrip[i], 'IPv6 byte '+i.ToString);
      Check(lAddress.ScopeId = 7, 'IPv6 scope ID');
      Check(new IPEndPoint(lAddress, 43210).AddressFamily = AddressFamily.InterNetworkV6, 'endpoint family');
      var lParsed: IPAddress;
      Check(not IPAddress.TryParse('256.0.0.1', out lParsed), 'reject invalid IPv4 octet');
      Check(not IPAddress.TryParse('not::an::address', out lParsed), 'reject invalid numeric IPv6');
      Check(IPAddress.TryParse('[fe80::1234%7]', out lParsed) and (lParsed.ScopeId = 7), 'parse IPv6 with scope');
      var lAddresses := Dns.GetHostAddresses('localhost');
      Check(length(lAddresses) > 0, 'DNS localhost');
      try
        Dns.GetHostAddresses('elements-socket-tests.invalid');
        Check(false, 'DNS failure throws');
      except
        on e: SocketException do
          Check(e.ErrorCode <> 0, 'DNS native error');
      end;
    end;

    class method TestTCP(aIPv6: Boolean);
    begin
      using lListener := NewSocket(aIPv6) do begin
        lListener.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, true);
        lListener.Bind(new IPEndPoint(Loopback(aIPv6), 0));
        lListener.Listen(4);
        var lLocal := IPEndPoint(lListener.LocalEndPoint);
        Check(lLocal.Port > 0, 'TCP ephemeral port');
        using lClient := NewSocket(aIPv6) do begin
          lClient.SetSocketOption(SocketOptionLevel.Tcp, SocketOptionName.NoDelay, true);
          {$IF FUCHSIA}
          try
            lClient.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.Linger, new LingerOption(false, 0));
          except
            on e: SocketException do
              Check(e.ErrorCode = rtl.EOPNOTSUPP, 'unsupported linger reports native error');
          end;
          {$ELSE}
          lClient.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.Linger, new LingerOption(false, 0));
          {$ENDIF}
          lClient.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReceiveTimeout, 3000);
          lClient.Connect(lLocal);
          using lAccepted := lListener.Accept do begin
            lAccepted.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReceiveTimeout, 3000);
            Check(lAccepted.AddressFamily = lListener.AddressFamily, 'accepted socket family');
            Check(IPEndPoint(lAccepted.RemoteEndPoint).Port = IPEndPoint(lClient.LocalEndPoint).Port, 'peer endpoint port');
            Check(IPEndPoint(lAccepted.LocalEndPoint).Port = lLocal.Port, 'accepted local port');
            var lPayload: array of Byte := [99, 21, 22, 23, 98];
            var lSent := 0;
            while lSent < 3 do
              lSent := lSent + lClient.Send(lPayload, 1 + lSent, 3 - lSent, SocketFlags.None);
            var lAvailable := 0;
            for i := 1 to 3000 do begin
              lAvailable := lAccepted.DataAvailable;
              if lAvailable >= 3 then
                break;
              Thread.Sleep(1);
            end;
            Check(lAvailable = 3, 'TCP available byte count');
            var lPeek := new Byte[1];
            Check((lAccepted.Receive(lPeek, 1, SocketFlags.Peek) = 1) and (lPeek[0] = 21), 'TCP peek flag');
            var lRead := new Byte[6];
            var lCount := 0;
            while lCount < 3 do
              lCount := lCount + lAccepted.Receive(lRead, 2 + lCount, 3 - lCount, SocketFlags.None);
            Check((lRead[2] = 21) and (lRead[3] = 22) and (lRead[4] = 23) and (lRead[0] = 0), 'TCP offsets and partial reads');
            lClient.Shutdown(SocketShutdown.Send);
            Check(lAccepted.Receive(lRead) = 0, 'TCP orderly EOF');
          end;
          lClient.Close;
          lClient.Close;
          Check(not lClient.Connected, 'idempotent close');
        end;
      end;
    end;

    class method TestUDP(aIPv6: Boolean);
    begin
      using lReceiver := NewSocket(aIPv6, true) do
      using lSender := NewSocket(aIPv6, true) do begin
        lReceiver.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReceiveTimeout, 3000);
        lReceiver.Bind(new IPEndPoint(Loopback(aIPv6), 0));
        var lPayload: array of Byte := [99, 41, 42, 43, 98];
        Check(lSender.SendTo(lPayload, 1, 3, SocketFlags.None, lReceiver.LocalEndPoint) = 3, 'UDP send offset');
        var lBuffer := new Byte[7];
        var lPeer: EndPoint;
        Check(lReceiver.ReceiveFrom(lBuffer, 2, 3, SocketFlags.None, var lPeer) = 3, 'UDP receive size');
        Check((lBuffer[2] = 41) and (lBuffer[3] = 42) and (lBuffer[4] = 43) and (lBuffer[0] = 0), 'UDP receive offset');
        Check(IPEndPoint(lPeer).Port = IPEndPoint(lSender.LocalEndPoint).Port, 'UDP peer port');
        var lEmpty := new Byte[0];
        Check(lSender.SendTo(lEmpty, 0, 0, SocketFlags.None, lReceiver.LocalEndPoint) = 0, 'empty UDP send');
        Check(lReceiver.ReceiveFrom(lBuffer, 0, 1, SocketFlags.None, var lPeer) = 0, 'empty UDP receive');
        lReceiver.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReceiveTimeout, 50);
        try
          lReceiver.ReceiveFrom(lBuffer, 0, length(lBuffer), SocketFlags.None, var lPeer);
          Check(false, 'UDP receive timeout throws');
        except
          on e: SocketException do
            Check(e.ErrorCode <> 0, 'UDP receive timeout native error');
        end;
      end;
    end;

    class method TestReadShutdown;
    begin
      using lListener := NewSocket(false) do begin
        lListener.Bind(new IPEndPoint(Loopback(false), 0));
        lListener.Listen(1);
        using lClient := NewSocket(false) do begin
          lClient.Connect(lListener.LocalEndPoint);
          using lAccepted := lListener.Accept do
          using lStarted := new EventWaitHandle(false, false) do
          using lFinished := new EventWaitHandle(false, false) do begin
            var lReleased := false;
            var lThread := new Thread(-> begin
              var lBuffer := new Byte[1];
              lStarted.Set;
              try
                lReleased := lAccepted.Receive(lBuffer) = 0;
              except
                on e: SocketException do
                  lReleased := e.ErrorCode <> 0;
              end;
              lFinished.Set;
            end);
            lThread.Start;
            lStarted.Wait;
            Thread.Sleep(50);
            lAccepted.Close;
            Check(lFinished.Wait(3000) and lReleased, 'blocked receive completes on close');
          end;
        end;
      end;
    end;

    class method TestShutdown;
    begin
      for i := 1 to 5 do begin
        using lListener := NewSocket(false) do begin
          lListener.Bind(new IPEndPoint(Loopback(false), 0));
          lListener.Listen(1);
          using lStarted := new EventWaitHandle(false, false) do
          using lFinished := new EventWaitHandle(false, false) do begin
            var lInterrupted := false;
            var lUnexpected: Exception;
            var lThread := new Thread(-> begin
              lStarted.Set;
              try
                using lAccepted := lListener.Accept do
                  lUnexpected := new Exception('Unexpected accept success');
              except
                on e: SocketAcceptInterruptedException do
                  lInterrupted := true;
                on e: Exception do
                  lUnexpected := e;
              end;
              lFinished.Set;
            end);
            lThread.Start;
            lStarted.Wait;
            Thread.Sleep(50);
            lListener.Close;
            Check(lFinished.Wait(3000), 'blocked accept completes on close');
            Check(lInterrupted and (lUnexpected = nil), 'intentional accept interruption');
          end;
        end;
      end;
      using lNotListening := NewSocket(false) do begin
        try
          lNotListening.Accept;
          Check(false, 'genuine accept failure throws');
        except
          on e: SocketException do
            Check(e.ErrorCode <> 0, 'genuine accept failure preserves native error');
        end;
      end;
    end;

  public

    class method Main(aArgs: array of String): Integer;
    begin
      try
        TestAddresses;
        TestTCP(false);
        TestTCP(true);
        TestUDP(false);
        TestUDP(true);
        TestReadShutdown;
        TestShutdown;
        writeLn('SOCKET TESTS PASSED: '+fChecks.ToString);
      except
        on e: Exception do begin
          writeLn(e.ToString);
          exit 1;
        end;
      end;
    end;

  end;

end.
