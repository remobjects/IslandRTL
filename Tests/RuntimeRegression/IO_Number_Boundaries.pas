// Regression guards for invalid numeric input and real file-stream behavior.
// Temporary files are unique, small and removed in finally blocks; large seeks
// never write or extend a file. These checks exercise actual OS handles.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  {$IF NOT NOFILES}
  FlushFailureStream = class(FileStream)
  public
    FlushCount: Integer;
    Failure: IOException := new IOException('injected flush failure');
    constructor(aName: String);
    begin
      inherited constructor(aName, FileMode.CreateNew, FileAccess.ReadWrite, FileShare.None);
    end;

    method Flush; override;
    begin
      inc(FlushCount);
      raise Failure;
    end;
  end;
  {$ENDIF}

  IO_Number_Boundaries = public class(Test)
  public
    method InvalidIntegerText;
    begin
      for each text in ['', ' ', '   ', '+', '-', ' + ', ' - ', '1 2', 'x'] do begin
        var signed: Int64;
        var unsigned: UInt64;
        Assert.IsFalse(Convert.TryParseInt64(text, out signed, false));
        Assert.IsFalse(Convert.TryParseUInt64(text, out unsigned, false));
      end;
      var value: Int64;
      Assert.IsTrue(Convert.TryParseInt64(' -9223372036854775808 ', out value, false));
      Assert.AreEqual(Int64.MinValue, value);
      Assert.IsFalse(Convert.TryParseInt64('9223372036854775808', out value, false));
      var u: UInt64;
      Assert.IsTrue(Convert.TryParseUInt64('18446744073709551615', out u, false));
      Assert.AreEqual(UInt64.MaxValue, u);
      Assert.IsFalse(Convert.TryParseUInt64('18446744073709551616', out u, false));
    end;

    method IntegerRoundTripsAndMalformedHex;
    begin
      for i := -500 to 500 do begin
        var original := Int64(i) * 7919123456789;
        var value: Int64;
        Assert.IsTrue(Convert.TryParseInt64(' ' + original.ToString + ' ', out value, false));
        Assert.AreEqual(original, value);
      end;
      var value: Int64;
      Assert.IsFalse(Convert.TryParseInt64('999999999999999999999999x', out value, true));
      var caught := false;
      try Convert.TryParseInt64('999999999999999999999999', out value, true);
      except on e: OverflowException do caught := true; end;
      Assert.IsTrue(caught);
      var hex: UInt64;
      for each text in ['', ' ', '   ', '-', '+', 'xyz', '0x1'] do
        Assert.IsFalse(Convert.TryHexStringToUInt64(text, out hex));
      Assert.IsTrue(Convert.TryHexStringToUInt64(' FfFfFfFfFfFfFfFf ', out hex));
      Assert.AreEqual(UInt64.MaxValue, hex);
      Assert.IsFalse(Convert.TryHexStringToUInt64('10000000000000000', out hex));
    end;

    method MemoryWriteToHandlesPartialWrites;
    begin
      var source := new MemoryStream;
      var dest := new ShortWriteStream;
      source.WriteTo(dest);
      var bytes: array of Byte := [1, 2, 3, 4, 5, 6, 7];
      source.Write(bytes, 0, bytes.Length);
      source.Position := 3;
      source.WriteTo(dest);
      Assert.AreEqual(Int64(3), source.Position);
      Assert.AreEqual(Int64(7), dest.Length);
      var actual := dest.ToArray;
      for i := 0 to bytes.Length - 1 do Assert.AreEqual(bytes[i], actual[i]);
    end;

    method MemoryWriteToSelfUsesOriginalContents;
    begin
      // Cover append, overlapping overwrite and a gap, with both buffer reuse
      // and growth. Partial writes must not read bytes overwritten by an earlier
      // write; on the old growing-length loop even append never finished.
      for partial := 0 to 1 do
        for each capacity in [4, 32] do
          for each position in [0, 1, 4, 6] do begin
            var source: MemoryStream := if partial = 0 then new MemoryStream else new ShortWriteStream;
            source.Capacity := capacity;
            var bytes: array of Byte := [11, 22, 33, 44];
            for i := 0 to bytes.Length - 1 do source.Write(bytes, i, 1);
            source.Position := position;
            source.WriteTo(source);
            Assert.AreEqual(Int64(position + 4), source.Position);
            Assert.AreEqual(Int64(position + 4), source.Length);
            var actual := source.ToArray;
            for i := 0 to position - 1 do
              Assert.AreEqual(if i < 4 then bytes[i] else Byte(0), actual[i]);
            for i := 0 to 3 do Assert.AreEqual(bytes[i], actual[position + i]);
          end;
      var empty := new MemoryStream;
      empty.WriteTo(empty);
      Assert.AreEqual(Int64(0), empty.Length);
    end;

    {$IF NOT NOFILES}
    method CloseReleasesHandleAfterFlushFailure;
    begin
      // Inject at the virtual Flush boundary, without depending on a full disk.
      // Close must preserve that error but relinquish the real OS handle once.
      var name := Path.Combine(Environment.TempFolder.FullName, 'IslandRTL-' + Guid.NewGuid.ToString + '.tmp');
      var lFile: FlushFailureStream;
      try
        lFile := new FlushFailureStream(name);
        var caught := false;
        try lFile.Close;
        except on e: IOException do begin
          caught := true;
          Assert.IsTrue(Object.ReferenceEquals(e, lFile.Failure));
        end; end;
        Assert.IsTrue(caught);
        Assert.IsFalse(lFile.CanRead);
        Assert.IsFalse(lFile.CanWrite);
        Assert.IsFalse(lFile.CanSeek);
        lFile.Close;
        Assert.AreEqual(1, lFile.FlushCount);
        // Windows sharing is exclusive: reopening also checks actual release.
        var reopened := new FileStream(name, FileMode.Open, FileAccess.Read, FileShare.None);
        reopened.Close;
      finally
        if lFile <> nil then lFile.Close;
        if File.Exists(name) then File.Delete(name);
      end;
    end;

    method FileAccessSeekAndFlush;
    begin
      var name := Path.Combine(Environment.TempFolder.FullName, 'IslandRTL-' + Guid.NewGuid.ToString + '.tmp');
      var lFile: FileStream;
      try
        lFile := new FileStream(name, FileMode.CreateNew, FileAccess.ReadWrite, FileShare.ReadWrite);
        var data: array of Byte := [11, 22, 33, 44];
        Assert.AreEqual(4, lFile.Write(data, 0, 4));
        Assert.AreEqual(Int64(1), lFile.Seek(1, SeekOrigin.Begin));
        var read := new Byte[2];
        Assert.AreEqual(2, lFile.Read(read, 0, 2));
        Assert.AreEqual(Byte(22), read[0]);
        Assert.AreEqual(Byte(33), read[1]);
        lFile.Position := 0;
        lFile.Write([Byte(99)], 0, 1);
        lFile.Flush;
        var second := new FileStream(name, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
        try
          Assert.AreEqual(1, second.Read(read, 0, 1));
          Assert.AreEqual(Byte(99), read[0]);
        finally second.Close; end;
        var far := (Int64(1) shl 32) + 17;
        Assert.AreEqual(far, lFile.Seek(far, SeekOrigin.Begin));
        Assert.AreEqual(far, lFile.Position);
        Assert.AreEqual(Int64(4), lFile.Length);
      finally
        if lFile <> nil then lFile.Close;
        if File.Exists(name) then File.Delete(name);
      end;
    end;

    method CreateNewDoesNotOverwrite;
    begin
      var name := Path.Combine(Environment.TempFolder.FullName, 'IslandRTL-' + Guid.NewGuid.ToString + '.tmp');
      try
        var lFile := new FileStream(name, FileMode.CreateNew, FileAccess.Write);
        try lFile.Write(new Byte[3], 0, 3); finally lFile.Close; end;
        var caught := false;
        try
          var duplicate := new FileStream(name, FileMode.CreateNew, FileAccess.Write);
          duplicate.Close;
        except on e: Exception do caught := true; end;
        Assert.IsTrue(caught);
        var read := new FileStream(name, FileMode.Open, FileAccess.Read);
        try Assert.AreEqual(Int64(3), read.Length); finally read.Close; end;
      finally
        if File.Exists(name) then File.Delete(name);
      end;
    end;
    {$ENDIF}
  end;
end.
