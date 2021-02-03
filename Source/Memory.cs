namespace RemObjects.Elements.System
{
    public __extension class MemoryExtension<T>: Memory<T> {
        public MemoryExtension(T value) 
        {
            var v = value;
            return &v;
        }
    }
    
	public struct Memory<T> {
		private Object inst;
		private IntPtr offset;

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
		public static bool operator null (Memory<T> a)
		{
			return a.offset == 0 && a.inst == null;
		}
	}
}