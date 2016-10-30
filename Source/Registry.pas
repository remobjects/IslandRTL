namespace RemObjects.Elements.System;

type
  RegistryValueKind = public enum (String, ExpandString, Binary, DWord, MultiString, QWord, Unknown, None);

  Registry = public static class
  private
  
    method ParseKeyName(keyName: String; out subKeyName: String): rtl.HKEY;
    begin
      if keyName = nil then raise new Exception('keyName cannot be null');
      var idx := keyName.IndexOf('\');
      var l_hkey: String; 
      if idx <> -1 then begin
        l_hkey := keyName.Substring(0, idx).ToUpper;
        subKeyName := keyName.Substring(idx+1,keyName.Length - idx-1);
      end
      else begin
        l_hkey := keyName.ToUpper;
        subKeyName := '';
      end;
      if l_hkey = CurrentUser then exit rtl.HKEY_CURRENT_USER
      else if l_hkey = LocalMachine then exit rtl.HKEY_LOCAL_MACHINE
      else if l_hkey = ClassesRoot then exit rtl.HKEY_CLASSES_ROOT
      else if l_hkey = Users then exit rtl.HKEY_USERS
      else if l_hkey = PerformanceData then exit rtl.HKEY_PERFORMANCE_DATA
      else if l_hkey = CurrentConfig then exit rtl.HKEY_CURRENT_CONFIG
      else if l_hkey = DynData then exit rtl.HKEY_DYN_DATA
      else raise new Exception('invalid keyName');
    end;

  public
    const CurrentUser = 'HKEY_CURRENT_USER';
    const  LocalMachine = 'HKEY_LOCAL_MACHINE';
    const  ClassesRoot = 'HKEY_CLASSES_ROOT';
    const  Users = 'HKEY_USERS';
    const  PerformanceData = 'HKEY_PERFORMANCE_DATA';
    const  CurrentConfig = 'HKEY_CURRENT_CONFIG';
    const  DynData = 'HKEY_DYN_DATA';

    method GetValue(keyName: String; valueName: String;  defaultValue: Object): Object;
    begin
      var subKeyName: string;
      var lrootkey := ParseKeyName(keyName, out subKeyName);
      var lsubKey := subKeyName.ToLPCWSTR;
      var lvaluename := valueName.ToLPCWSTR;
      var &flags := rtl.RRF_RT_ANY;
      var dwtype : rtl.DWORD;
      var pcbData: rtl.DWORD;
      var res := rtl.RegGetValueW(lrootkey, lsubKey, lvaluename,&flags,@dwtype,nil, @pcbData);
      if res = rtl.ERROR_SUCCESS  then begin
        var buf := new array of Byte(pcbData);
        var bufref: ^void := @buf[0];
        res:= rtl.RegGetValueW(lrootkey, lsubKey, lvaluename,&flags,@dwtype,bufref, @pcbData);
        if res = rtl.ERROR_SUCCESS  then begin
          case dwtype of
            rtl.REG_NONE,
            rtl.REG_BINARY:     exit buf;            

            rtl.REG_DWORD:      exit ^Int32(bufref)^;
            rtl.REG_DWORD_BIG_ENDIAN: begin
              var temp: UInt32 := UInt32(buf[0]) shl 24 + 
                                  UInt32(buf[1]) shl 16 +
                                  UInt32(buf[2]) shl 8  +
                                  UInt32(buf[3]);
              exit ^Int32(@temp)^;
            end;
            rtl.REG_SZ,
            rtl.REG_EXPAND_SZ,
            rtl.REG_LINK:      exit String.FromPChar(^Char(bufref));

            rtl.REG_MULTI_SZ:begin
              var s:= String.FromPChar(^Char(bufref),pcbData);
              if s.EndsWith(#0#0) then s:= s.Substring(0,s.Length-2);
              exit s.Split(#0);
            end;

            rtl.REG_QWORD:      exit ^Int64(bufref)^;
          end;
        end;
      end;      
      if res <> rtl.ERROR_SUCCESS then 
        raise new Exception('error code is '+res.tostring);
    end;

    method SetValue(keyName: String; valueName: String;  value: Object);
    begin
      SetValue(keyName,valueName,value,RegistryValueKind.Unknown);
    end;

    method SetValue(keyName: String; valueName: String;  value: Object; valueKind: RegistryValueKind);
    begin
      var cbData: ^void;
      var cbDataSize: rtl.DWORD;
      var cbDatatype: rtl.DWORD;

      case ValueKind of
        RegistryValueKind.String: begin
          var str:= value.ToString;
          cbData := str.ToLPCWSTR;
          cbDataSize := str.Length*2+2;
          cbDatatype := rtl.REG_SZ;
        end;
        RegistryValueKind.ExpandString: begin
          var str:= value.ToString;
          cbData := str.ToLPCWSTR;
          cbDataSize := str.Length*2+2;
          cbDatatype := rtl.REG_EXPAND_SZ;
        end;
        RegistryValueKind.Binary: begin
          if value is array of byte then begin
            var temp := value as array of byte ;
            cbData := @temp[0];
            cbDataSize := temp.Length;
            cbDatatype := rtl.REG_BINARY;
          end
          else begin
            raise new Exception('only `array of Byte` object is supported yet');
          end;
        end;
        RegistryValueKind.DWord: begin
          if value is Int32 then begin
            var temp := value as Int32;
            cbData := @temp;
            cbDataSize := 4;
            cbDatatype := rtl.REG_DWORD;
          end
          else begin
            raise new Exception('only `Int32` object is supported yet');
          end;
        end;
        RegistryValueKind.MultiString: begin
          if value is array of string then begin
            var temp := value as array of string;
            var cb:= new StringBuilder;
            for each m in temp do begin
              cb.Append(m);
              cb.Append(#0);
            end;
            cbData := cb.ToString.ToLPCWSTR;
            cbDataSize := cb.Length*2+2;
            cbDatatype := rtl.REG_MULTI_SZ;
          end
          else begin
            raise new Exception('only `array of String` object is supported yet');
          end;
        end;
        RegistryValueKind.QWord: begin
          if value is Int64 then begin
            var temp := value as Int64;
            cbData := @temp;
            cbDataSize := 8;
            cbDatatype := rtl.REG_QWORD;
          end
          else begin
            raise new Exception('only `Int64` object is supported yet');
          end;
        end;
        else begin
          // handle all other cases
          if value is String then SetValue(keyName,valueName,value,RegistryValueKind.String)
          else if value is Int32 then SetValue(keyName,valueName,value,RegistryValueKind.DWord)
          else if value is Int64 then SetValue(keyName,valueName,value,RegistryValueKind.QWord)
          else if value is array of string then SetValue(keyName,valueName,value,RegistryValueKind.MultiString)
          else if value is array of byte then SetValue(keyName,valueName,value,RegistryValueKind.Binary)
          else raise new Exception('unsupported value');
          exit;
        end;
      end;

      var subKeyName: string;
      var lrootkey := ParseKeyName(keyName, out subKeyName);
      var lsubKey := subKeyName.ToLPCWSTR;

      var res :=  rtl.RegSetKeyValueW(lrootkey, lsubKey, valueName.ToLPCWSTR,cbDatatype,cbData, cbDataSize);
      if res <> rtl.ERROR_SUCCESS then 
        raise new Exception('error code is '+res.tostring);
    end;
  end;

end.
