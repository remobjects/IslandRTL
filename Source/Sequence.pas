namespace RemObjects.Elements.System;

type
 // ISequence<T> = public IEnumerable<T>;

  IEnumerable = public interface
   method GetEnumerator: IEnumerator;
  end;

  IEnumerator = public interface(IDisposable)
    method MoveNext: Boolean;
    property Current: Object read;
  end;

  IEnumerable<T> = public interface(IEnumerable)
    method GetEnumerator: IEnumerator<T>;
  end;

  IEnumerator<T> = public interface(IEnumerator)
    property Current: T read;
  end;

  ICollection = public interface(IEnumerable)
    property Count: Integer read;
  end;

  ICollection<T> = public interface(IEnumerable<T>, ICollection)
    method Add(val: T);
    method Clear;
    method Contains(val: T): Boolean;
    method Remove(val: T): Boolean;
  end;

  IComparable<T> = public interface
    method CompareTo(a: T): Integer;
  end;

end.