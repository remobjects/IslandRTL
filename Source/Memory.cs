namespace RemObjects.Elements.System
{
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
	}
}