namespace RemObjects.Elements.System
{
	public class MemoryException: Exception { }

	public interface IMemory
	{
		object GetValue();
		void SetValue(object aValue);
	}

	public __extension class MemoryExtension<T>: Memory<T> {
		public MemoryExtension(T value)
		{
			var v = value;
			return &v;
		}
	}

	public struct Memory<T>: IMemory {
		private Object inst;
		private IntPtr offset;

		private static void CheckMemorySpace(Memory<T> a, Memory<T> b)
		{
			if (a.inst != b.inst) throw new MemoryException("Can not compare items in different memory space");
		}

		public Memory(Object inst, IntPtr offset)
		{
			this.inst = inst;
			this.offset = offset;
		}

		public unsafe ref T Ref() {
			if (inst == null) {
				return ref (*((T*)offset));
			}

			ref T res = (T*)(*((IntPtr*)(&inst)) + offset);
			return ref res;
		}

		public T Value {
		  get {
			return Ref();
		  }
		  set {
			var x = ref Ref();
			x = value;
		  }
		}

		object GetValue()
		{
			return Value;
		}

		void SetValue(object aValue)
		{
			Value = (T)aValue;
		}

		public override int GetHashCode()
		{
			return (inst == null ? 0 : Tuple.R3(inst.GetHashCode())) ^ offset.GetHashCode();
		}

		public override bool Equals(object val)
		{
			var realVal = val as Memory<T>;
			if (realVal == null) return false;

			return (realVal.inst == inst) && (realVal.offset == offset);
		}

		public Memory<TN> Cast<TN>()
		{
			return new Memory<TN>(inst, offset);
		}

		public static bool operator null (Memory<T> a)
		{
			return a.offset == 0 && a.inst == null;
		}

		public static bool operator == (Memory<T> a, Memory<T> b)
		{
			return a.inst == b.inst && a.offset == b.offset;
		}

		public static bool operator >= (Memory<T> a, Memory<T> b)
		{
			CheckMemorySpace(a, b);
			return a.offset >= b.offset;
		}

		public static bool operator <= (Memory<T> a, Memory<T> b)
		{
			CheckMemorySpace(a, b);
			return a.offset <= b.offset;
		}

		public static bool operator < (Memory<T> a, Memory<T> b)
		{
			CheckMemorySpace(a, b);
			return a.offset < b.offset;
		}

		public static bool operator > (Memory<T> a, Memory<T> b)
		{
			CheckMemorySpace(a, b);
			return a.offset > b.offset;
		}

		public static bool operator != (Memory<T> a, Memory<T> b)
		{
			return !(a.inst == b.inst && a.offset == b.offset);
		}
	}
}