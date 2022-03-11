namespace RemObjects.Elements.System;

{$IF NOT WEBASSEMBLY}

type
  {$HIDE H7}{$HIDE H8}
  IslandResource = record
  public
    HDR: array[0..7] of Byte;
    HeaderSize: Integer;
    NameSize: Integer;
    DataSize: Integer;
  end;
  {$SHOW H7}{$SHOW H8}

  IslandResourceData = public class
  public
    property Name: String read assembly write;
    property Data: Span<Byte> read assembly write;
  end;

  Resources = public static class
  private
    {$IFDEF WINDOWS}
    var
      {$HIDE H8}
      [SymbolName('__elements_ISLNDRESStart'), SectionName('ISLNDRES$a'), StaticallyInitializedField]
      fStartRes: IslandResource := default(IslandResource); readonly;
      [SymbolName('__elements_ISLNDRESEnd'), SectionName('ISLNDRES$z'), StaticallyInitializedField]
      fEndRes: IslandResource := default(IslandResource); readonly;
      {$SHOW H8}

    method GetResourceRange(out aStart, aEnd: ^IslandResource); assembly;
    begin
      aStart := @(@fStartRes)[1];
      aEnd := @fEndRes;
    end;
    {$ENDIF}
    {$IFDEF LINUX OR FUCHSIA}
    {$HIDE H8}
    var
      [SymbolName('__start_island_res')]
      fStartRes: IslandResource; external;
      [SymbolName('__stop_island_res')]
      fEndRes: IslandResource; external;
    {$SHOW H8}

    method GetResourceRange(out aStart, aEnd: ^IslandResource); assembly;
    begin
      aStart := @fStartRes;
      aEnd := @fEndRes;
    end;
    {$ENDIF}
    {$IFDEF DARWIN}
    method GetResourceRange(out aStart, aEnd: ^IslandResource); assembly;
    begin
      var lSize: {$IF CPU64}UInt64{$ELSE}UInt32{$ENDIF};
      var hdr := &Type.GetHDR;
      aStart := ^IslandResource(rtl.getsectiondata(hdr, "__DATA", "__island_res", @lSize));
      aEnd := ^IslandResource(^Byte(aStart) + lSize);
    end;
    {$ENDIF}
  public
    method EnumerateResources: sequence of IslandResourceData; iterator;
    begin
      GetResourceRange(out var lStart, out var lEnd);
      if lStart = nil then
        exit;

      while lStart < lEnd do begin
        var lName := String.FromPAnsiChars(@^AnsiChar(lStart)[8 + 4+ lStart.HeaderSize], lStart^.NameSize);
        var lData := @^Byte(lStart)[8 + 4+ lStart.HeaderSize + lStart.NameSize];
        var lLength := lStart.DataSize;
        lStart := ^IslandResource(@^Byte(lStart)[8 + 4+ lStart.HeaderSize + lStart.NameSize + lStart.DataSize]);
        if (IntPtr(lStart) mod 4) <> 0 then
          lStart := ^IslandResource(IntPtr(lStart) + 4 - (IntPtr(lStart) mod 4));
        yield new IslandResourceData(Name := lName, Data := new Span<Byte>(lData, lLength));
      end;
    end;

    method FindResource(aName: String): IslandResourceData;
    begin
      GetResourceRange(out var lStart, out var lEnd);
      if lStart = nil then
        exit nil;

      while lStart < lEnd do begin
        var lName := String.FromPAnsiChars(@^AnsiChar(lStart)[8 + 4 + lStart.HeaderSize], lStart^.NameSize);
        var lData := @^Byte(lStart)[8 + 4 + lStart.HeaderSize + lStart.NameSize];
        var lLength := lStart.DataSize;
        lStart := ^IslandResource(@^Byte(lStart)[8 + 4 + lStart.HeaderSize + lStart.NameSize + lStart.DataSize]);
        if (IntPtr(lStart) mod 4) <> 0 then
          lStart := ^IslandResource(IntPtr(lStart) + 4 - (IntPtr(lStart) mod 4));
        if lName = aName then
          exit new IslandResourceData(Name := lName, Data := new Span<Byte>(lData, lLength));
      end;
      exit nil;
    end;
  end;

{$ENDIF}

end.