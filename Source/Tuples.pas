namespace RemObjects.Elements.System;


type
  Tuple<T1> = public record
  public
    constructor(aItem1: T1);
    begin
      Item1 := aItem1;
    end;

    property Item1: T1; readonly;
    method GetHashCode: Integer; override;
    begin
      if Item1 = nil then exit 0;
      exit Item1.GetHashCode;
    end;

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1>(arg1);
      exit (lTuple.Item1.Equals(Item1));
    end;


    class operator Equal(a, b: &Tuple<T1>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1));
    end;

    class operator NotEqual(a, b: &Tuple<T1>): Boolean;
    begin
      exit not (a = b);
    end;
  end;

  Tuple<T1, T2> = public record
  public
    constructor(aItem1: T1; aItem2: T2);
    begin
      Item1 := aItem1;
      Item2 := aItem2;
    end;

    property Item1: T1; readonly;
    property Item2: T2; readonly;
    method GetHashCode: Integer; override;
    begin
      result := 0;
      if Item1 <> nil then result := Tuple.R3(result) xor Item1.GetHashCode;
      if Item2 <> nil then result := Tuple.R3(result) xor Item2.GetHashCode;
    end;

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1, T2>(arg1);
      exit lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2);
    end;


    class operator Equal(a, b: &Tuple<T1, T2>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1)) and (EqualityComparer.Equals(a.Item2, b.Item2));
    end;

    class operator NotEqual(a, b: &Tuple<T1, T2>): Boolean;
    begin
      exit not (a = b);
    end;
  end;

  Tuple<T1, T2, T3> = public record
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3);
    begin
      Item1 := aItem1;
      Item2 := aItem2;
      Item3 := aItem3;
    end;

    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    method GetHashCode: Integer; override;
    begin
      result := 0;
      if Item1 <> nil then result := Tuple.R3(result) xor Item1.GetHashCode;
      if Item2 <> nil then result := Tuple.R3(result) xor Item2.GetHashCode;
      if Item3 <> nil then result := Tuple.R3(result) xor Item3.GetHashCode;
    end;

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1, T2, T3>(arg1);
      exit lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3);
    end;


    class operator Equal(a, b: &Tuple<T1, T2, T3>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1)) and (EqualityComparer.Equals(a.Item2, b.Item2)) and (EqualityComparer.Equals(a.Item3, b.Item3));
    end;

    class operator NotEqual(a, b: &Tuple<T1, T2, T3>): Boolean;
    begin
      exit not (a = b);
    end;
  end;

  Tuple<T1, T2, T3, T4> = public record
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4);
    begin
      Item1 := aItem1;
      Item2 := aItem2;
      Item3 := aItem3;
      Item4 := aItem4;
    end;

    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    method GetHashCode: Integer; override;
    begin
      result := 0;
      if Item1 <> nil then result := Tuple.R3(result) xor Item1.GetHashCode;
      if Item2 <> nil then result := Tuple.R3(result) xor Item2.GetHashCode;
      if Item3 <> nil then result := Tuple.R3(result) xor Item3.GetHashCode;
      if Item4 <> nil then result := Tuple.R3(result) xor Item4.GetHashCode;
    end;

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1, T2, T3, T4>(arg1);
      exit lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4);
    end;


    class operator Equal(a, b: &Tuple<T1, T2, T3, T4>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1)) and (EqualityComparer.Equals(a.Item2, b.Item2)) and (EqualityComparer.Equals(a.Item3, b.Item3)) and (EqualityComparer.Equals(a.Item4, b.Item4));
    end;

    class operator NotEqual(a, b: &Tuple<T1, T2, T3, T4>): Boolean;
    begin
      exit not (a = b);
    end;
  end;

  Tuple<T1, T2, T3, T4, T5> = public record
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5);
    begin
      Item1 := aItem1;
      Item2 := aItem2;
      Item3 := aItem3;
      Item4 := aItem4;
      Item5 := aItem5;
    end;

    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    method GetHashCode: Integer; override;
    begin
      result := 0;
      if Item1 <> nil then result := Tuple.R3(result) xor Item1.GetHashCode;
      if Item2 <> nil then result := Tuple.R3(result) xor Item2.GetHashCode;
      if Item3 <> nil then result := Tuple.R3(result) xor Item3.GetHashCode;
      if Item4 <> nil then result := Tuple.R3(result) xor Item4.GetHashCode;
      if Item5 <> nil then result := Tuple.R3(result) xor Item5.GetHashCode;
    end;

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1, T2, T3, T4, T5>(arg1);
      exit lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5);
    end;


    class operator Equal(a, b: &Tuple<T1, T2, T3, T4, T5>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1)) and (EqualityComparer.Equals(a.Item2, b.Item2)) and (EqualityComparer.Equals(a.Item3, b.Item3)) and (EqualityComparer.Equals(a.Item4, b.Item4)) and (EqualityComparer.Equals(a.Item5, b.Item5));
    end;

    class operator NotEqual(a, b: &Tuple<T1, T2, T3, T4, T5>): Boolean;
    begin
      exit not (a = b);
    end;
  end;

  Tuple<T1, T2, T3, T4, T5, T6> = public record
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6);
    begin
      Item1 := aItem1;
      Item2 := aItem2;
      Item3 := aItem3;
      Item4 := aItem4;
      Item5 := aItem5;
      Item6 := aItem6;
    end;

    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    property Item6: T6; readonly;
    method GetHashCode: Integer; override;
    begin
      result := 0;
      if Item1 <> nil then result := Tuple.R3(result) xor Item1.GetHashCode;
      if Item2 <> nil then result := Tuple.R3(result) xor Item2.GetHashCode;
      if Item3 <> nil then result := Tuple.R3(result) xor Item3.GetHashCode;
      if Item4 <> nil then result := Tuple.R3(result) xor Item4.GetHashCode;
      if Item5 <> nil then result := Tuple.R3(result) xor Item5.GetHashCode;
      if Item6 <> nil then result := Tuple.R3(result) xor Item6.GetHashCode;
    end;

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1, T2, T3, T4, T5, T6>(arg1);
      exit lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5)
        and lTuple.Item6.Equals(Item6);
    end;


    class operator Equal(a, b: &Tuple<T1, T2, T3, T4, T5, T6>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1)) and (EqualityComparer.Equals(a.Item2, b.Item2)) and (EqualityComparer.Equals(a.Item3, b.Item3)) and (EqualityComparer.Equals(a.Item4, b.Item4)) and (EqualityComparer.Equals(a.Item5, b.Item5)) and (EqualityComparer.Equals(a.Item6, b.Item6));
    end;

    class operator NotEqual(a, b: &Tuple<T1, T2, T3, T4, T5, T6>): Boolean;
    begin
      exit not (a = b);
    end;
  end;

  Tuple<T1, T2, T3, T4, T5, T6, T7> = public record
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7);
    begin
      Item1 := aItem1;
      Item2 := aItem2;
      Item3 := aItem3;
      Item4 := aItem4;
      Item5 := aItem5;
      Item6 := aItem6;
      Item7 := aItem7;
    end;

    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    property Item6: T6; readonly;
    property Item7: T7; readonly;
    method GetHashCode: Integer; override;
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

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1, T2, T3, T4, T5, T6, T7>(arg1);
      exit lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5)
        and lTuple.Item6.Equals(Item6) and lTuple.Item7.Equals(Item7);
    end;


    class operator Equal(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1)) and (EqualityComparer.Equals(a.Item2, b.Item2)) and (EqualityComparer.Equals(a.Item3, b.Item3)) and (EqualityComparer.Equals(a.Item4, b.Item4)) and (EqualityComparer.Equals(a.Item5, b.Item5)) and (EqualityComparer.Equals(a.Item6, b.Item6)) and (EqualityComparer.Equals(a.Item7, b.Item7));
    end;

    class operator NotEqual(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7>): Boolean;
    begin
      exit not (a = b);
    end;
  end;

  Tuple<T1, T2, T3, T4, T5, T6, T7, T8> = public record
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8);
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

    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    property Item6: T6; readonly;
    property Item7: T7; readonly;
    property Item8: T8; readonly;
    method GetHashCode: Integer; override;
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

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1, T2, T3, T4, T5, T6, T7, T8>(arg1);
      exit lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5)
        and lTuple.Item6.Equals(Item6) and lTuple.Item7.Equals(Item7) and lTuple.Item8.Equals(Item8);
    end;


    class operator Equal(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1)) and (EqualityComparer.Equals(a.Item2, b.Item2)) and (EqualityComparer.Equals(a.Item3, b.Item3)) and (EqualityComparer.Equals(a.Item4, b.Item4)) and (EqualityComparer.Equals(a.Item5, b.Item5)) and (EqualityComparer.Equals(a.Item6, b.Item6)) and (EqualityComparer.Equals(a.Item7, b.Item7)) and (EqualityComparer.Equals(a.Item8, b.Item8));
    end;

    class operator NotEqual(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8>): Boolean;
    begin
      exit not (a = b);
    end;
  end;


  Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9> = public record
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8; aItem9: T9);
    begin
      Item1 := aItem1;
      Item2 := aItem2;
      Item3 := aItem3;
      Item4 := aItem4;
      Item5 := aItem5;
      Item6 := aItem6;
      Item7 := aItem7;
      Item8 := aItem8;
      Item9 := aItem9;
    end;

    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    property Item6: T6; readonly;
    property Item7: T7; readonly;
    property Item8: T8; readonly;
    property Item9: T9; readonly;
    method GetHashCode: Integer; override;
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
      if Item9 <> nil then result := Tuple.R3(result) xor Item9.GetHashCode;
    end;

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9>(arg1);
      exit lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5)
        and lTuple.Item6.Equals(Item6) and lTuple.Item7.Equals(Item7) and lTuple.Item8.Equals(Item8)and lTuple.Item9.Equals(Item9);
    end;


    class operator Equal(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1)) and (EqualityComparer.Equals(a.Item2, b.Item2)) and (EqualityComparer.Equals(a.Item3, b.Item3)) and (EqualityComparer.Equals(a.Item4, b.Item4)) and
      (EqualityComparer.Equals(a.Item5, b.Item5)) and (EqualityComparer.Equals(a.Item6, b.Item6)) and (EqualityComparer.Equals(a.Item7, b.Item7)) and (EqualityComparer.Equals(a.Item8, b.Item8))
      and (EqualityComparer.Equals(a.Item9, b.Item9));
    end;

    class operator NotEqual(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9>): Boolean;
    begin
      exit not (a = b);
    end;
  end;

  Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> = public record
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8; aItem9: T9; aItem10: T10);
    begin
      Item1 := aItem1;
      Item2 := aItem2;
      Item3 := aItem3;
      Item4 := aItem4;
      Item5 := aItem5;
      Item6 := aItem6;
      Item7 := aItem7;
      Item8 := aItem8;
      Item9 := aItem9;
      Item10 := aItem10;
    end;

    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    property Item6: T6; readonly;
    property Item7: T7; readonly;
    property Item8: T8; readonly;
    property Item9: T9; readonly;
    property Item10: T10; readonly;
    method GetHashCode: Integer; override;
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
      if Item9 <> nil then result := Tuple.R3(result) xor Item9.GetHashCode;
      if Item10 <> nil then result := Tuple.R3(result) xor Item10.GetHashCode;
    end;

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(arg1);
      exit lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5)
        and lTuple.Item6.Equals(Item6) and lTuple.Item7.Equals(Item7) and lTuple.Item8.Equals(Item8)and lTuple.Item9.Equals(Item9)and lTuple.Item10.Equals(Item10);
    end;


    class operator Equal(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1)) and (EqualityComparer.Equals(a.Item2, b.Item2)) and (EqualityComparer.Equals(a.Item3, b.Item3)) and (EqualityComparer.Equals(a.Item4, b.Item4)) and
      (EqualityComparer.Equals(a.Item5, b.Item5)) and (EqualityComparer.Equals(a.Item6, b.Item6)) and (EqualityComparer.Equals(a.Item7, b.Item7)) and (EqualityComparer.Equals(a.Item8, b.Item8))
      and (EqualityComparer.Equals(a.Item9, b.Item9))and (EqualityComparer.Equals(a.Item10, b.Item10));
    end;

    class operator NotEqual(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>): Boolean;
    begin
      exit not (a = b);
    end;
  end;

  Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> = public record
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8; aItem9: T9; aItem10: T10; aItem11: T11);
    begin
      Item1 := aItem1;
      Item2 := aItem2;
      Item3 := aItem3;
      Item4 := aItem4;
      Item5 := aItem5;
      Item6 := aItem6;
      Item7 := aItem7;
      Item8 := aItem8;
      Item9 := aItem9;
      Item10 := aItem10;
      Item11 := aItem11;
    end;

    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    property Item6: T6; readonly;
    property Item7: T7; readonly;
    property Item8: T8; readonly;
    property Item9: T9; readonly;
    property Item10: T10; readonly;
    property Item11: T11; readonly;
    method GetHashCode: Integer; override;
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
      if Item9 <> nil then result := Tuple.R3(result) xor Item9.GetHashCode;
      if Item10 <> nil then result := Tuple.R3(result) xor Item10.GetHashCode;
      if Item11 <> nil then result := Tuple.R3(result) xor Item11.GetHashCode;
    end;

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(arg1);
      exit lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5)
        and lTuple.Item6.Equals(Item6) and lTuple.Item7.Equals(Item7) and lTuple.Item8.Equals(Item8)and lTuple.Item9.Equals(Item9)and lTuple.Item10.Equals(Item10)
        and lTuple.Item11.Equals(Item11);
    end;


    class operator Equal(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1)) and (EqualityComparer.Equals(a.Item2, b.Item2)) and (EqualityComparer.Equals(a.Item3, b.Item3)) and (EqualityComparer.Equals(a.Item4, b.Item4)) and
      (EqualityComparer.Equals(a.Item5, b.Item5)) and (EqualityComparer.Equals(a.Item6, b.Item6)) and (EqualityComparer.Equals(a.Item7, b.Item7)) and (EqualityComparer.Equals(a.Item8, b.Item8))
      and (EqualityComparer.Equals(a.Item9, b.Item9))and (EqualityComparer.Equals(a.Item10, b.Item10))and (EqualityComparer.Equals(a.Item11, b.Item11));
    end;

    class operator NotEqual(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>): Boolean;
    begin
      exit not (a = b);
    end;
  end;
  Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> = public record
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8; aItem9: T9; aItem10: T10; aItem11: T11; aItem12: T12);
    begin
      Item1 := aItem1;
      Item2 := aItem2;
      Item3 := aItem3;
      Item4 := aItem4;
      Item5 := aItem5;
      Item6 := aItem6;
      Item7 := aItem7;
      Item8 := aItem8;
      Item9 := aItem9;
      Item10 := aItem10;
      Item11 := aItem11;
      Item12 := aItem12;
    end;

    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    property Item6: T6; readonly;
    property Item7: T7; readonly;
    property Item8: T8; readonly;
    property Item9: T9; readonly;
    property Item10: T10; readonly;
    property Item11: T11; readonly;
    property Item12: T12; readonly;
    method GetHashCode: Integer; override;
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
      if Item9 <> nil then result := Tuple.R3(result) xor Item9.GetHashCode;
      if Item10 <> nil then result := Tuple.R3(result) xor Item10.GetHashCode;
      if Item11 <> nil then result := Tuple.R3(result) xor Item11.GetHashCode;
      if Item12 <> nil then result := Tuple.R3(result) xor Item12.GetHashCode;
    end;

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(arg1);
      exit lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5)
        and lTuple.Item6.Equals(Item6) and lTuple.Item7.Equals(Item7) and lTuple.Item8.Equals(Item8)and lTuple.Item9.Equals(Item9)and lTuple.Item10.Equals(Item10)
        and lTuple.Item11.Equals(Item11)and lTuple.Item12.Equals(Item12);
    end;


    class operator Equal(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1)) and (EqualityComparer.Equals(a.Item2, b.Item2)) and (EqualityComparer.Equals(a.Item3, b.Item3)) and (EqualityComparer.Equals(a.Item4, b.Item4)) and
      (EqualityComparer.Equals(a.Item5, b.Item5)) and (EqualityComparer.Equals(a.Item6, b.Item6)) and (EqualityComparer.Equals(a.Item7, b.Item7)) and (EqualityComparer.Equals(a.Item8, b.Item8))
      and (EqualityComparer.Equals(a.Item9, b.Item9))and (EqualityComparer.Equals(a.Item10, b.Item10))and (EqualityComparer.Equals(a.Item11, b.Item11))and (EqualityComparer.Equals(a.Item12, b.Item12));
    end;

    class operator NotEqual(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>): Boolean;
    begin
      exit not (a = b);
    end;
  end;

  Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> = public record
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8; aItem9: T9; aItem10: T10; aItem11: T11; aItem12: T12; aItem13: T13);
    begin
      Item1 := aItem1;
      Item2 := aItem2;
      Item3 := aItem3;
      Item4 := aItem4;
      Item5 := aItem5;
      Item6 := aItem6;
      Item7 := aItem7;
      Item8 := aItem8;
      Item9 := aItem9;
      Item10 := aItem10;
      Item11 := aItem11;
      Item12 := aItem12;
      Item13 := aItem13;
    end;

    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    property Item6: T6; readonly;
    property Item7: T7; readonly;
    property Item8: T8; readonly;
    property Item9: T9; readonly;
    property Item10: T10; readonly;
    property Item11: T11; readonly;
    property Item12: T12; readonly;
    property Item13: T13; readonly;
    method GetHashCode: Integer; override;
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
      if Item9 <> nil then result := Tuple.R3(result) xor Item9.GetHashCode;
      if Item10 <> nil then result := Tuple.R3(result) xor Item10.GetHashCode;
      if Item11 <> nil then result := Tuple.R3(result) xor Item11.GetHashCode;
      if Item12 <> nil then result := Tuple.R3(result) xor Item12.GetHashCode;
      if Item13 <> nil then result := Tuple.R3(result) xor Item13.GetHashCode;
    end;

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(arg1);
      exit lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5)
        and lTuple.Item6.Equals(Item6) and lTuple.Item7.Equals(Item7) and lTuple.Item8.Equals(Item8)and lTuple.Item9.Equals(Item9)and lTuple.Item10.Equals(Item10)
        and lTuple.Item11.Equals(Item11)and lTuple.Item12.Equals(Item12)and lTuple.Item13.Equals(Item13);
    end;


    class operator Equal(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1)) and (EqualityComparer.Equals(a.Item2, b.Item2)) and (EqualityComparer.Equals(a.Item3, b.Item3)) and (EqualityComparer.Equals(a.Item4, b.Item4)) and
      (EqualityComparer.Equals(a.Item5, b.Item5)) and (EqualityComparer.Equals(a.Item6, b.Item6)) and (EqualityComparer.Equals(a.Item7, b.Item7)) and (EqualityComparer.Equals(a.Item8, b.Item8))
      and (EqualityComparer.Equals(a.Item9, b.Item9))and (EqualityComparer.Equals(a.Item10, b.Item10))and (EqualityComparer.Equals(a.Item11, b.Item11))and (EqualityComparer.Equals(a.Item12, b.Item12))
      and (EqualityComparer.Equals(a.Item13, b.Item13));
    end;

    class operator NotEqual(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>): Boolean;
    begin
      exit not (a = b);
    end;
  end;


  Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> = public record
  public
    constructor(aItem1: T1; aItem2: T2; aItem3: T3; aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8; aItem9: T9; aItem10: T10; aItem11: T11; aItem12: T12; aItem13: T13; aItem14: T14);
    begin
      Item1 := aItem1;
      Item2 := aItem2;
      Item3 := aItem3;
      Item4 := aItem4;
      Item5 := aItem5;
      Item6 := aItem6;
      Item7 := aItem7;
      Item8 := aItem8;
      Item9 := aItem9;
      Item10 := aItem10;
      Item11 := aItem11;
      Item12 := aItem12;
      Item13 := aItem13;
      Item14 := aItem14;
    end;

    property Item1: T1; readonly;
    property Item2: T2; readonly;
    property Item3: T3; readonly;
    property Item4: T4; readonly;
    property Item5: T5; readonly;
    property Item6: T6; readonly;
    property Item7: T7; readonly;
    property Item8: T8; readonly;
    property Item9: T9; readonly;
    property Item10: T10; readonly;
    property Item11: T11; readonly;
    property Item12: T12; readonly;
    property Item13: T13; readonly;
    property Item14: T14; readonly;
    method GetHashCode: Integer; override;
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
      if Item9 <> nil then result := Tuple.R3(result) xor Item9.GetHashCode;
      if Item10 <> nil then result := Tuple.R3(result) xor Item10.GetHashCode;
      if Item11 <> nil then result := Tuple.R3(result) xor Item11.GetHashCode;
      if Item12 <> nil then result := Tuple.R3(result) xor Item12.GetHashCode;
      if Item13 <> nil then result := Tuple.R3(result) xor Item13.GetHashCode;
      if Item14 <> nil then result := Tuple.R3(result) xor Item14.GetHashCode;
    end;

    method &Equals(arg1: Object): Boolean; override;
    begin
      var lTuple := Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(arg1);
      exit lTuple.Item1.Equals(Item1) and lTuple.Item2.Equals(Item2) and lTuple.Item3.Equals(Item3) and lTuple.Item4.Equals(Item4) and lTuple.Item5.Equals(Item5)
        and lTuple.Item6.Equals(Item6) and lTuple.Item7.Equals(Item7) and lTuple.Item8.Equals(Item8)and lTuple.Item9.Equals(Item9)and lTuple.Item10.Equals(Item10)
        and lTuple.Item11.Equals(Item11)and lTuple.Item12.Equals(Item12)and lTuple.Item13.Equals(Item13)and lTuple.Item14.Equals(Item14);
    end;


    class operator Equal(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>): Boolean;
    begin
      exit (EqualityComparer.Equals(a.Item1, b.Item1)) and (EqualityComparer.Equals(a.Item2, b.Item2)) and (EqualityComparer.Equals(a.Item3, b.Item3)) and (EqualityComparer.Equals(a.Item4, b.Item4)) and
      (EqualityComparer.Equals(a.Item5, b.Item5)) and (EqualityComparer.Equals(a.Item6, b.Item6)) and (EqualityComparer.Equals(a.Item7, b.Item7)) and (EqualityComparer.Equals(a.Item8, b.Item8))
      and (EqualityComparer.Equals(a.Item9, b.Item9))and (EqualityComparer.Equals(a.Item10, b.Item10))and (EqualityComparer.Equals(a.Item11, b.Item11))and (EqualityComparer.Equals(a.Item12, b.Item12))
      and (EqualityComparer.Equals(a.Item13, b.Item13))and (EqualityComparer.Equals(a.Item14, b.Item14));
    end;

    class operator NotEqual(a, b: &Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>): Boolean;
    begin
      exit not (a = b);
    end;
  end;


  Tuple = public static class
  assembly
    class method R3(i: Integer): Integer;
    begin
      exit (i shl 29) or (i shr 3);
    end;

  public
    class method &New<T1>(aItem1: T1): Tuple<T1>;
    begin
      exit new Tuple<T1>(aItem1);
    end;

    class method &New<T1, T2>(aItem1: T1; aItem2: T2): Tuple<T1, T2>;
    begin
      exit new Tuple<T1, T2>(aItem1, aItem2);
    end;

    class method &New<T1, T2, T3>(aItem1: T1; aItem2: T2; aItem3: T3): Tuple<T1, T2, T3>;
    begin
      exit new Tuple<T1, T2, T3>(aItem1, aItem2, aItem3);
    end;

    class method &New<T1, T2, T3, T4>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4): Tuple<T1, T2, T3, T4>;
    begin
      exit new Tuple<T1, T2, T3, T4>(aItem1, aItem2, aItem3, aItem4);
    end;

    class method &New<T1, T2, T3, T4, T5>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5): Tuple<T1, T2, T3, T4, T5>;
    begin
      exit new Tuple<T1, T2, T3, T4, T5>(aItem1, aItem2, aItem3, aItem4, aItem5);
    end;

    class method &New<T1, T2, T3, T4, T5, T6>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5; aItem6: T6): Tuple<T1, T2, T3, T4, T5, T6>;
    begin
      exit new Tuple<T1, T2, T3, T4, T5,T6>(aItem1, aItem2, aItem3, aItem4, aItem5, aItem6);
    end;

    class method &New<T1, T2, T3, T4, T5, T6, T7>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7): Tuple<T1, T2, T3, T4, T5, T6, T7>;
    begin
      exit new Tuple<T1, T2, T3, T4, T5,T6, T7>(aItem1, aItem2, aItem3, aItem4, aItem5, aItem6, aItem7);
    end;

    class method &New<T1, T2, T3, T4, T5, T6, T7, T8>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8): Tuple<T1, T2, T3, T4, T5, T6, T7, T8>;
    begin
      exit new Tuple<T1, T2, T3, T4, T5,T6, T7, T8>(aItem1, aItem2, aItem3, aItem4, aItem5, aItem6, aItem7, aItem8);
    end;

    class method &New<T1, T2, T3, T4, T5, T6, T7, T8,T9>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8; aItem9: T9): Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9>;
    begin
      exit new Tuple<T1, T2, T3, T4, T5,T6, T7, T8, T9>(aItem1, aItem2, aItem3, aItem4, aItem5, aItem6, aItem7, aItem8, aItem9);
    end;

    class method &New<T1, T2, T3, T4, T5, T6, T7, T8,T9, T10>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8; aItem9: T9; aItem10: T10): Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>;
    begin
      exit new Tuple<T1, T2, T3, T4, T5,T6, T7, T8, T9, T10>(aItem1, aItem2, aItem3, aItem4, aItem5, aItem6, aItem7, aItem8, aItem9, aItem10);
    end;

    class method &New<T1, T2, T3, T4, T5, T6, T7, T8,T9, T10, T11>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8; aItem9: T9; aItem10: T10; aItem11: T11): Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>;
    begin
      exit new Tuple<T1, T2, T3, T4, T5,T6, T7, T8, T9, T10, T11>(aItem1, aItem2, aItem3, aItem4, aItem5, aItem6, aItem7, aItem8, aItem9, aItem10, aItem11);
    end;

    class method &New<T1, T2, T3, T4, T5, T6, T7, T8,T9, T10, T11, T12>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8; aItem9: T9; aItem10: T10; aItem11: T11; aItem12: T12): Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>;
    begin
      exit new Tuple<T1, T2, T3, T4, T5,T6, T7, T8, T9, T10, T11, T12>(aItem1, aItem2, aItem3, aItem4, aItem5, aItem6, aItem7, aItem8, aItem9, aItem10, aItem11, aItem12);
    end;


    class method &New<T1, T2, T3, T4, T5, T6, T7, T8,T9, T10, T11, T12, T13>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8; aItem9: T9; aItem10: T10; aItem11: T11; aItem12: T12; aItem13: T13): Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>;
    begin
      exit new Tuple<T1, T2, T3, T4, T5,T6, T7, T8, T9, T10, T11, T12, T13>(aItem1, aItem2, aItem3, aItem4, aItem5, aItem6, aItem7, aItem8, aItem9, aItem10, aItem11, aItem12, aItem13);
    end;

    class method &New<T1, T2, T3, T4, T5, T6, T7, T8,T9, T10, T11, T12, T13, T14>(aItem1: T1; aItem2: T2; aItem3: T3;  aItem4: T4; aItem5: T5; aItem6: T6; aItem7: T7; aItem8: T8; aItem9: T9; aItem10: T10; aItem11: T11; aItem12: T12; aItem13: T13; aItem14: T14): Tuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>;
    begin
      exit new Tuple<T1, T2, T3, T4, T5,T6, T7, T8, T9, T10, T11, T12, T13, T14>(aItem1, aItem2, aItem3, aItem4, aItem5, aItem6, aItem7, aItem8, aItem9, aItem10, aItem11, aItem12, aItem13, aItem14);
    end;
  end;


end.