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
  where T is unconstrained;
    method GetEnumerator: IEnumerator<T>;
  end;

  IEnumerator<T> = public interface(IEnumerator)
  where T is unconstrained;
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

  IList = public interface(ICollection)
    method Add(val: Object);
    method Clear;
    method Contains(val: Object): Boolean;
    method Remove(val: Object): Boolean;
    property Item[i: Integer]: Object read write; default;
  end;

  IList<T> = public interface(ICollection<T>, IList)
    method Add(val: T);
    method Clear;
    method Contains(val: T): Boolean;
    method Remove(val: T): Boolean;
    property Item[i: Integer]: T read write; default;
  end;

  INotifyPropertyChanged = public interface
    event PropertyChanged: Action<Object, String>;
  end;

  INotifyPropertyChanging = public interface
    event PropertyChanging: Action<Object, String>;
  end;

end.