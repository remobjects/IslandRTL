namespace RemObjects.Elements.System;

interface

type
  &Delegate = public abstract class(Object)
  assembly
    fSelf: Object;
    fPtr: ^Void;
  public
    property &Self: Object read fSelf;
    property Ptr: ^Void read fPtr; // Signature varies ofc.
  end;

  Action = public delegate;
  Action<T1> = public delegate(par1: T1);
  Action<T1, T2> = public delegate(par1: T1; par2: T2);
  Action<T1, T2, T3> = public delegate(par1: T1; par2: T2; par3: T3);
  Action<T1, T2, T3, T4> = public delegate (par1: T1; par2: T2; par3: T3; par4: T4);
  Action<T1, T2, T3, T4, T5> = public delegate(par1: T1; par2: T2; par3: T3; par4: T4; par5: T5);
  Action<T1, T2, T3, T4, T5, T6> = public delegate(par1: T1; par2: T2; par3: T3; par4: T4; par5: T5; par6: T6);
  Action<T1, T2, T3, T4, T5, T6, T7> = public delegate(par1: T1; par2: T2; par3: T3; par4: T4; par5: T5; par6: T6; par7: T7);
  Action<T1, T2, T3, T4, T5, T6, T7, T8> = public delegate(par1: T1; par2: T2; par3: T3; par4: T4; par5: T5; par6: T6; par7: T7; par8: T8);
  Func<R> = public delegate(): R;
  Func<T1, R> = public delegate(par1: T1): R;
  Func<T1, T2, R> = public delegate(par1: T1; par2: T2): R;
  Func<T1, T2, T3, R> = public delegate(par1: T1; par2: T2; par3: T3): R;
  Func<T1, T2, T3, T4, R> = public delegate(par1: T1; par2: T2; par3: T3; par4: T4): R;
  Func<T1, T2, T3, T4, T5, R> = public delegate(par1: T1; par2: T2; par3: T3; par4: T4; par5: T5): R;
  Func<T1, T2, T3, T4, T5, T6, R> = public delegate(par1: T1; par2: T2; par3: T3; par4: T4; par5: T5; par6: T6): R;
  Func<T1, T2, T3, T4, T5, T6, T7, R> = public delegate(par1: T1; par2: T2; par3: T3; par4: T4; par5: T5; par6: T6; par7: T7): R;
  Func<T1, T2, T3, T4, T5, T6, T7, T8, R> = public delegate(par1: T1; par2: T2; par3: T3; par4: T4; par5: T5; par6: T6; par7: T7; par8: T8): R;

implementation

end.