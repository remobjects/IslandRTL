namespace RemObjects.Elements.System;

interface

type
  Tuple<T1> = public class
  public
    constructor(aItem1: T1);
    property Item1: T1; readonly;
    method GetHashCode: Integer; override;
    method &Equals(arg1: Object): Boolean; override;
  end;

  Tuple<T1, T2> = public class
  public
    constructor(aItem1: T1; aItem2: T2);
    property Item1: T1; readonly;
    property Item2: T2; readonly;
    method GetHashCode: Integer; override;
    method &Equals(arg1: Object): Boolean; override;
  end;

  Tuple<T1, T2, T3> = public class
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3);
    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    method GetHashCode: Integer; override;
    method &Equals(arg1: Object): Boolean; override;
  end;

  Tuple<T1, T2, T3, T4> = public class
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4);
    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    method GetHashCode: Integer; override;
    method &Equals(arg1: Object): Boolean; override;
  end;

  Tuple<T1, T2, T3, T4, T5> = public class
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5);
    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    method GetHashCode: Integer; override;
    method &Equals(arg1: Object): Boolean; override;
  end;

  Tuple<T1, T2, T3, T4, T5, T6> = public class
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6);
    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    property Item6: T6; readonly;
    method GetHashCode: Integer; override;
    method &Equals(arg1: Object): Boolean; override;
  end;

  Tuple<T1, T2, T3, T4, T5, T6, T7> = public class
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7);
    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    property Item6: T6; readonly;
    property Item7: T7; readonly;
    method GetHashCode: Integer; override;
    method &Equals(arg1: Object): Boolean; override;
  end;

  Tuple<T1, T2, T3, T4, T5, T6, T7, T8> = public class
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8);
    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    property Item6: T6; readonly;
    property Item7: T7; readonly;
    property Item8: T8; readonly;
    method GetHashCode: Integer; override;
    method &Equals(arg1: Object): Boolean; override;
  end;

  Tuple = public static class
  assembly
    class method R3(i: Integer): Integer;
  public
     class method &New<T1>(aItem1: T1): Tuple<T1>;
     class method &New<T1, T2>(aItem1: T1; aItem2: T2): Tuple<T1, T2>;
     class method &New<T1, T2, T3>(aItem1: T1; aItem2: T2; aItem3: T3): Tuple<T1, T2, T3>;
     class method &New<T1, T2, T3, T4>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4): Tuple<T1, T2, T3, T4>;
     class method &New<T1, T2, T3, T4, T5>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5): Tuple<T1, T2, T3, T4, T5>;
     class method &New<T1, T2, T3, T4, T5, T6>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5; aItem6: T6): Tuple<T1, T2, T3, T4, T5, T6>;
     class method &New<T1, T2, T3, T4, T5, T6, T7>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7): Tuple<T1, T2, T3, T4, T5, T6, T7>;
     class method &New<T1, T2, T3, T4, T5, T6, T7, T8>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8): Tuple<T1, T2, T3, T4, T5, T6, T7, T8>;
  end;


implementation


constructor Tuple<T1>(aItem1: T1);
begin
  Item1 := aItem1;
end;

method Tuple<T1>.GetHashCode: Integer;
begin
  if Item1 = nil then exit 0;
  exit Item1.GetHashCode;
end;

method Tuple<T1>.&Equals(arg1: Object): Boolean;
begin
  var lTuple := Tuple<T1>(arg1);
  exit assigned(lTuple) and (lTuple.Item1.Equals(Item1));
end;

constructor Tuple<T1, T2>(aItem1: T1; aItem2: T2);
begin
  Item1 := aItem1;
  Item2 := aItem2;
end;

method Tuple<T1, T2>.GetHashCode: Integer;
begin
  result := 0;
  if Item1 <> nil then result := Tuple.R3(result) xor Item1.GetHashCode;
  if Item2 <> nil then result := Tuple.R3(result) xor Item2.GetHashCode;
end;

method Tuple<T1, T2>.&Equals(arg1: Object): Boolean;
begin
  var lTuple := Tuple<T1, T2>(arg1);
  exit assigned(lTuple) and lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2);
end;

constructor Tuple<T1, T2, T3>(aItem1: T1; aItem2: T2; aItem3: T3);
begin
  Item1 := aItem1;
  Item2 := aItem2;
  Item3 := aItem3;
end;


method Tuple<T1, T2, T3>.GetHashCode: Integer;
begin
  result := 0;
  if Item1 <> nil then result := Tuple.R3(result) xor Item1.GetHashCode;
  if Item2 <> nil then result := Tuple.R3(result) xor Item2.GetHashCode;
  if Item3 <> nil then result := Tuple.R3(result) xor Item3.GetHashCode;
end;

method Tuple<T1, T2, T3>.&Equals(arg1: Object): Boolean;
begin
  var lTuple := Tuple<T1, T2, T3>(arg1);
  exit assigned(lTuple) and lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3);
end;


constructor Tuple<T1, T2, T3, T4>(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4);
begin
  Item1 := aItem1;
  Item2 := aItem2;
  Item3 := aItem3;
  Item4 := aItem4;
end;


method Tuple<T1, T2, T3, T4>.GetHashCode: Integer;
begin
  result := 0;
  if Item1 <> nil then result := Tuple.R3(result) xor Item1.GetHashCode;
  if Item2 <> nil then result := Tuple.R3(result) xor Item2.GetHashCode;
  if Item3 <> nil then result := Tuple.R3(result) xor Item3.GetHashCode;
  if Item4 <> nil then result := Tuple.R3(result) xor Item4.GetHashCode;
end;

method Tuple<T1, T2, T3, T4>.&Equals(arg1: Object): Boolean;
begin
  var lTuple := Tuple<T1, T2, T3, T4>(arg1);
  exit assigned(lTuple) and lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4);
end;

constructor Tuple<T1, T2, T3, T4, T5>(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5);
begin
  Item1 := aItem1;
  Item2 := aItem2;
  Item3 := aItem3;
  Item4 := aItem4;
  Item5 := aItem5;
end;

method Tuple<T1, T2, T3, T4, T5>.GetHashCode: Integer;
begin
  result := 0;
  if Item1 <> nil then result := Tuple.R3(result) xor Item1.GetHashCode;
  if Item2 <> nil then result := Tuple.R3(result) xor Item2.GetHashCode;
  if Item3 <> nil then result := Tuple.R3(result) xor Item3.GetHashCode;
  if Item4 <> nil then result := Tuple.R3(result) xor Item4.GetHashCode;
  if Item5 <> nil then result := Tuple.R3(result) xor Item5.GetHashCode;
end;

method Tuple<T1, T2, T3, T4, T5>.&Equals(arg1: Object): Boolean;
begin
  var lTuple := Tuple<T1, T2, T3, T4, T5>(arg1);
  exit assigned(lTuple) and lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5);
end;

constructor Tuple<T1, T2, T3, T4, T5, T6>(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6);
begin
  Item1 := aItem1;
  Item2 := aItem2;
  Item3 := aItem3;
  Item4 := aItem4;
  Item5 := aItem5;
  Item6 := aItem6;
end;

method Tuple<T1, T2, T3, T4, T5, T6>.GetHashCode: Integer;
begin
  result := 0;
  if Item1 <> nil then result := Tuple.R3(result) xor Item1.GetHashCode;
  if Item2 <> nil then result := Tuple.R3(result) xor Item2.GetHashCode;
  if Item3 <> nil then result := Tuple.R3(result) xor Item3.GetHashCode;
  if Item4 <> nil then result := Tuple.R3(result) xor Item4.GetHashCode;
  if Item5 <> nil then result := Tuple.R3(result) xor Item5.GetHashCode;
  if Item6 <> nil then result := Tuple.R3(result) xor Item6.GetHashCode;
end;

method Tuple<T1, T2, T3, T4, T5, T6>.&Equals(arg1: Object): Boolean;
begin
  var lTuple := Tuple<T1, T2, T3, T4, T5, T6>(arg1);
  exit assigned(lTuple) and lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5)
    and lTuple.Item6.Equals(Item6);
end;


constructor Tuple<T1, T2, T3, T4, T5, T6, T7>(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7);
begin
  Item1 := aItem1;
  Item2 := aItem2;
  Item3 := aItem3;
  Item4 := aItem4;
  Item5 := aItem5;
  Item6 := aItem6;
  Item7 := aItem7;
end;

method Tuple<T1, T2, T3, T4, T5, T6, T7>.GetHashCode: Integer;
begin
  result := 0;
  if Item1 <> nil then result := Tuple.R3(result) xor Item1.GetHashCode;
  if Item2 <> nil then result := Tuple.R3(result) xor Item2.GetHashCode;
  if Item3 <> nil then result := Tuple.R3(result) xor Item3.GetHashCode;
  if Item4 <> nil then result := Tuple.R3(result) xor Item4.GetHashCode;
  if Item5 <> nil then result := Tuple.R3(result) xor Item5.GetHashCode;
  if Item6 <> nil then result := Tuple.R3(result) xor Item6.GetHashCode;
  if Item7 <> nil then result := Tuple.R3(result) xor Item7.GetHashCode;
end;

method Tuple<T1, T2, T3, T4, T5, T6, T7>.&Equals(arg1: Object): Boolean;
begin
  var lTuple := Tuple<T1, T2, T3, T4, T5, T6, T7>(arg1);
  exit assigned(lTuple) and lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5)
    and lTuple.Item6.Equals(Item6) and lTuple.Item7.Equals(Item7);
end;

constructor Tuple<T1, T2, T3, T4, T5, T6, T7, T8>(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8);
begin
  Item1 := aItem1;
  Item2 := aItem2;
  Item3 := aItem3;
  Item4 := aItem4;
  Item5 := aItem5;
  Item6 := aItem6;
  Item7 := aItem7;
  Item8 := aItem8;
end;

method Tuple<T1, T2, T3, T4, T5, T6, T7, T8>.GetHashCode: Integer;
begin
  result := 0;
  if Item1 <> nil then result := Tuple.R3(result) xor Item1.GetHashCode;
  if Item2 <> nil then result := Tuple.R3(result) xor Item2.GetHashCode;
  if Item3 <> nil then result := Tuple.R3(result) xor Item3.GetHashCode;
  if Item4 <> nil then result := Tuple.R3(result) xor Item4.GetHashCode;
  if Item5 <> nil then result := Tuple.R3(result) xor Item5.GetHashCode;
  if Item6 <> nil then result := Tuple.R3(result) xor Item6.GetHashCode;
  if Item7 <> nil then result := Tuple.R3(result) xor Item7.GetHashCode;
  if Item8 <> nil then result := Tuple.R3(result) xor Item8.GetHashCode;
end;

method Tuple<T1, T2, T3, T4, T5, T6, T7, T8>.&Equals(arg1: Object): Boolean;
begin
  var lTuple := Tuple<T1, T2, T3, T4, T5, T6, T7, T8>(arg1);
  exit assigned(lTuple) and lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5)
    and lTuple.Item6.Equals(Item6) and lTuple.Item7.Equals(Item7) and lTuple.Item8.Equals(Item8);
end;

class method Tuple.&New<T1>(aItem1: T1): Tuple<T1>;
begin
  exit new Tuple<T1>(aItem1);
end;

class method Tuple.&New<T1,T2>(aItem1: T1; aItem2: T2): Tuple<T1, T2>;
begin
  exit new Tuple<T1, T2>(aItem1, aItem2);
end;

class method Tuple.&New<T1,T2,T3>(aItem1: T1; aItem2: T2; aItem3: T3): Tuple<T1, T2, T3>;
begin
  exit new Tuple<T1, T2, T3>(aItem1, aItem2, aItem3);
end;

class method Tuple.&New<T1,T2,T3,T4>(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4): Tuple<T1, T2, T3, T4>;
begin
  exit new Tuple<T1, T2, T3, T4>(aItem1, aItem2, aItem3, aItem4);
end;

class method Tuple.&New<T1,T2,T3,T4,T5>(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5): Tuple<T1, T2, T3, T4, T5>;
begin
  exit new Tuple<T1, T2, T3, T4, T5>(aItem1, aItem2, aItem3, aItem4, aItem5);
end;

class method Tuple.&New<T1,T2,T3,T4,T5,T6>(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6): Tuple<T1, T2, T3, T4, T5, T6>;
begin
  exit new Tuple<T1, T2, T3, T4, T5,T6>(aItem1, aItem2, aItem3, aItem4, aItem5, aItem6);
end;

class method Tuple.&New<T1,T2,T3,T4,T5,T6,T7>(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7): Tuple<T1, T2, T3, T4, T5, T6, T7>;
begin
  exit new Tuple<T1, T2, T3, T4, T5,T6, T7>(aItem1, aItem2, aItem3, aItem4, aItem5, aItem6, aItem7);
end;

class method Tuple.&New<T1,T2,T3,T4,T5,T6,T7,T8>(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8): Tuple<T1, T2, T3, T4, T5, T6, T7, T8>;
begin
  exit new Tuple<T1, T2, T3, T4, T5,T6, T7, T8>(aItem1, aItem2, aItem3, aItem4, aItem5, aItem6, aItem7, aItem8);
end;

class method &Tuple.R3(i: Integer): Integer;
begin
  exit (i shl 29) or (i shr 3);
end;

end.