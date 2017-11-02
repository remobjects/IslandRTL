namespace RemObjects.Elements.System;
// https://github.com/rampantpixels/rpmalloc/blob/master/rpmalloc/rpmalloc.c
//  rpmalloc  -  Memory allocator  -  Public Domain  -  2016 Mattias Jansson / Rampant Pixels
//  *
//  * This library provides a cross-platform lock free thread caching malloc implementation in C11.
//  * The latest source code is always available at
//  *
//  * https://github.com/rampantpixels/rpmalloc
//  *
//  * This library is put in the public domain; you can redistribute it and/or modify it without any restrictions.
//  
{$ifdef CPU64}
{$define ARCH_64BIT}
{$endif}
{$if WINDOWS or __WIN32__ or _WIN32 or _WIN64}
{$define PLATFORM_WINDOWS}
{$else}
{$define PLATFORM_POSIX}
{$endif}
//  Presets, if none is defined it will default to performance priority
// {$define ENABLE_UNLIMITED_CACHE}
// {$define DISABLE_CACHE}
// {$define ENABLE_SPACE_PRIORITY_CACHE}

{$IFDEF WEBASSEMBLY}
{$DEFINE ENABLE_UNLIMITED_CACHE}
{$ENDIF}

type
  rpmalloc_global_statistics_t = public record
  public
    var &mapped: size_t;
    var cached: size_t;
    var cached_large: size_t;
    var mapped_total: size_t;
    var unmapped_total: size_t;
  end;

  rpmalloc_thread_statistics_t = public record
  public
    var requested: size_t;
    var allocated: size_t;
    var active: size_t;
    var sizecache: size_t;
    var spancache: size_t;
    var deferred: size_t;
    var thread_to_global: size_t;
    var global_to_thread: size_t;
  end;

  span_block_t = record
  public
    var free_list: uint16_t;
    var first_autolink: uint16_t;
    var free_count: uint16_t;
    var padding: uint16_t;
  end;

  [&Union]
  span_data_t = record
  public
    var &block: span_block_t;
    var list_size: uint32_t;
  end;

  span_t = record
  public
    var heap_id: atomic32_t;
    var size_class: count_t;
    var data: span_data_t;
    var next_span: ^span_t;
    var prev_span: ^span_t;
  end;

  span_counter_t = record
  public
    var max_allocations: uint32_t;
    var current_allocations: uint32_t;
    var cache_limit: uint32_t;
  end;

  heap_t = record
  public
    var id: int32_t;
    var defer_deallocate: atomicptr_t;
    var active_block: array[0..rpmalloc.SIZE_CLASS_COUNT-1] of span_block_t;
    var active_span: array[0..rpmalloc.SIZE_CLASS_COUNT-1] of ^span_t;
    var size_cache: array[0..rpmalloc.SIZE_CLASS_COUNT-1] of ^span_t;
    var span_cache: array[0..rpmalloc.SIZE_CLASS_COUNT-1] of ^span_t;
    var span_counter: array[0..rpmalloc.SIZE_CLASS_COUNT-1] of span_counter_t;
    var large_cache: array[0..rpmalloc.SIZE_CLASS_COUNT-1] of ^span_t;
    var large_counter: array[0..rpmalloc.SIZE_CLASS_COUNT-1] of span_counter_t;
    var next_heap: ^heap_t;
    var next_orphan: ^heap_t;
    {$IFDEF ENABLE_STATISTICS}
    var requested: size_t;
    var allocated: size_t;
    var thread_to_global: size_t;
    var global_to_thread: size_t;
    {$ENDIF}
  end;

  size_class_t = record
  public
    var size: uint16_t;
    var page_count: uint16_t;
    var block_count: uint16_t;
    var class_idx: uint16_t;
  end;

  
  int32_t = Int32;
  uint16_t = UInt16;
  uint32_t = UInt32;
  atomic32_t = Int32;
  atomic64_t = Int64;
  offset_t = IntPtr;
  count_t = UInt32;
  size_t = IntPtr;
  atomicptr_t = IntPtr;
  uintptr_t = UIntPtr;
  intptr_t = IntPtr;
  int64_t = Int64;

  rpmalloc = public static class
  assembly
    class const RPMALLOC_NO_PRESERVE: Integer = 1;
    {$if ENABLE_UNLIMITED_CACHE}
    //  Presets for cache limits
    //  Unlimited caches
    // 
    class const MIN_SPAN_CACHE_RELEASE: Integer = 16;
    {$ELSEIF DISABLE_CACHE}
    // Disable cache
    // 
    class const MAX_SPAN_CACHE_DIVISOR: Integer = 1;
    class const MIN_SPAN_CACHE_RELEASE: Integer = 1;
    class const MAX_SPAN_CACHE_DIVISOR: Integer = 0;
    {$ELSEIF ENABLE_SPACE_PRIORITY_CACHE}
    //  Space priority cache limits
    // 
    class const MIN_SPAN_CACHE_SIZE: Integer = 8;
    class const MIN_SPAN_CACHE_RELEASE: Integer = 8;
    class const MAX_SPAN_CACHE_DIVISOR: Integer = 16;
    class const GLOBAL_SPAN_CACHE_MULTIPLIER: Integer = 1;
    {$else}
    //  Default - performance priority cache limits
    // ! Limit of thread cache in number of spans for each page count class (undefine for unlimited cache - i.e never release spans to global cache unless thread finishes)
    // ! Minimum cache size to remain after a release to global cache
    // 
    // ! Minimum number of spans to transfer between thread and global cache
    // 
    class const MIN_SPAN_CACHE_SIZE: Integer = 8;
    // ! Maximum cache size divisor (max cache size will be max allocation count divided by this divisor)
    // 
    class const MIN_SPAN_CACHE_RELEASE: Integer = 16;
    // ! Multiplier for global span cache limit (max cache size will be calculated like thread cache and multiplied with this)
    // 
    class const MAX_SPAN_CACHE_DIVISOR: Integer = 8;
    class const GLOBAL_SPAN_CACHE_MULTIPLIER: Integer = 4;
    {$endif}
    // #endif
    // #ifndef ENABLE_ASSERTS
    // #endif
    // #ifndef ENABLE_STATISTICS
    // #endif
    // #ifndef ENABLE_VALIDATE_ARGS
    // ! Enable validation of args to public entry points
    // #define ENABLE_VALIDATE_ARGS      0
    // ! Enable statistics collection
    // #define ENABLE_STATISTICS         0
    // ! Enable asserts
    // #define ENABLE_ASSERTS            0
    // ! Memory page size
    // 
    // ! Size of heap hashmap
    // 
    class const HEAP_ARRAY_SIZE: Integer = 79;
    // ! Granularity of all memory page spans for small & medium block allocations
    // 
    class const PAGE_SIZE: Integer = {$IFDEF WEBASSEMBLY}65536{$ELSE}4096{$ENDIF};
    // ! Maximum size of a span of memory pages
    // 
    class const SPAN_ADDRESS_GRANULARITY: Integer = {$IFDEF WEBASSEMBLY}1048576{$ELSE}4096{$ENDIF};
    // ! Mask for getting the start of a span of memory pages
    // 
    class const SPAN_MAX_SIZE: Integer = SPAN_ADDRESS_GRANULARITY;
    // ! Maximum number of memory pages in a span
    // 
    class const SPAN_MASK: Integer = not uintptr_t(SPAN_MAX_SIZE) - 1;
    // ! Span size class granularity
    // 
    class const SPAN_MAX_PAGE_COUNT: Integer = SPAN_MAX_SIZE / PAGE_SIZE;
    // ! Number of size classes for spans
    // 
    class const SPAN_CLASS_GRANULARITY: Integer = 4;
    // ! Granularity of a small allocation block
    // 
    class const SPAN_CLASS_COUNT: Integer = SPAN_MAX_PAGE_COUNT / SPAN_CLASS_GRANULARITY;
    // ! Small granularity shift count
    // 
    class const SMALL_GRANULARITY: Integer = 16;
    // ! Number of small block size classes
    // 
    class const SMALL_GRANULARITY_SHIFT: Integer = 4;
    // ! Maximum size of a small block
    // 
    class const SMALL_CLASS_COUNT: Integer = (PAGE_SIZE - SPAN_HEADER_SIZE) shr 1 shr SMALL_GRANULARITY_SHIFT;
    // ! Granularity of a medium allocation block
    // 
    class const SMALL_SIZE_LIMIT: Integer = SMALL_CLASS_COUNT * SMALL_GRANULARITY;
    // ! Medimum granularity shift count
    // 
    class const MEDIUM_GRANULARITY: Integer = 512;
    // ! Number of medium block size classes
    // 
    class const MEDIUM_GRANULARITY_SHIFT: Integer = 9;
    // ! Maximum size of a medium block
    // 
    class const MEDIUM_CLASS_COUNT: Integer = 60;
    // ! Total number of small + medium size classes
    // 
    class const MEDIUM_SIZE_LIMIT: Integer = (SMALL_SIZE_LIMIT + (MEDIUM_GRANULARITY * MEDIUM_CLASS_COUNT)) - SPAN_HEADER_SIZE;
    // ! Number of large block size classes
    // 
    class const SIZE_CLASS_COUNT: Integer = SMALL_CLASS_COUNT + MEDIUM_CLASS_COUNT;
    // ! Maximum number of memory pages in a large block
    // 
    class const LARGE_CLASS_COUNT: Integer = 32;
    // ! Maximum size of a large block
    // 
    class const LARGE_MAX_PAGES: Integer = SPAN_MAX_PAGE_COUNT * LARGE_CLASS_COUNT;
    class const LARGE_SIZE_LIMIT: Integer = (LARGE_MAX_PAGES * PAGE_SIZE) - SPAN_HEADER_SIZE;
    class const SPAN_LIST_LOCK_TOKEN: Integer = (1);
    class const SPAN_HEADER_SIZE: Integer = 32;
    method pointer_diff(first: ^Void; second: ^Void): IntPtr;
    begin
      exit ^Byte(first) - ^Byte(second);
    end;

    method pointer_offset(ptr: ^Void; offs: IntPtr): ^Void;
    begin
      exit ^Byte(ptr) + offs;
    end;

  //! Global size classes
    var _memory_size_class: array[0..SIZE_CLASS_COUNT-1]of size_class_t;

    //! Heap ID counter
    var _memory_heap_id: atomic32_t;

    {$if PLATFORM_POSIX}
    //! Virtual memory address counter
    var _memory_addr: atomic64_t;
    {$endif}

    //! Global span cache
    var _memory_span_cache: array[0..SPAN_CLASS_COUNT-1] of atomicptr_t ;

    //! Global large cache
    var _memory_large_cache: array[0..LARGE_CLASS_COUNT-1] of atomicptr_t ;

    //! Current thread heap
    [ThreadLocal]
    var _memory_thread_heap: ^heap_t;

    //! All heaps
    _memory_heaps: array [0..HEAP_ARRAY_SIZE-1]of atomicptr_t ;

    //! Orphaned heaps
    var _memory_orphan_heaps: atomicptr_t ;

    //! Active heap count
    var _memory_active_heaps: atomic32_t;

    //! Adaptive cache max allocation count
    var _memory_max_allocation: array[0..SPAN_CLASS_COUNT-1] of uint32_t ;

    //! Adaptive cache max allocation count
    var _memory_max_allocation_large: array[0..LARGE_CLASS_COUNT-1] of uint32_t ;

    {$IFDEF ENABLE_STATISTICS}
    //! Total number of mapped memory pages
    var _mapped_pages: atomic32_t ;
    //! Running counter of total number of mapped memory pages since start
    var _mapped_total: atomic32_t ;
    //! Running counter of total number of unmapped memory pages since start
    var _unmapped_total: atomic32_t ;
    {$endif}
    // ! Lookup a memory heap from heap ID
    class method _memory_heap_lookup(id: int32_t): ^heap_t;
    begin
      var list_idx: uint32_t := id mod HEAP_ARRAY_SIZE;
      var heap: ^heap_t := ^heap_t(InternalCalls.VolatileRead(var _memory_heaps[list_idx]));
      while assigned(heap) and ((heap)^.id <> id) do
        heap := (heap)^.next_heap;
      exit heap;
    end;
    // ! Get the span size class from page count
    class method _span_class_from_page_count(page_count: size_t): size_t;
    begin
      assert((page_count > 0) and (page_count ≤ 16));
      exit (((page_count + SPAN_CLASS_GRANULARITY) - 1) / SPAN_CLASS_GRANULARITY) - 1;
    end;

    // ! Increase an allocation counter
    class method _memory_counter_increase(counter: ^span_counter_t; global_counter: ^uint32_t);
    begin
      var c := (counter)^.current_allocations + 1;
      (counter)^.current_allocations := c;
      if c > (counter)^.max_allocations then begin
        (counter)^.max_allocations := (counter)^.current_allocations;
    
        {$IFNDEF ENABLE_UNLIMITED_CACHE}
        (counter)^.cache_limit := (counter)^.max_allocations / MAX_SPAN_CACHE_DIVISOR;
        {$ENDIF}
    
        if (counter)^.max_allocations > (global_counter)^ then begin
          (global_counter)^ := (counter)^.max_allocations;
        end;
      end;
    end;


    // ! Insert the given list of memory page spans in the global cache for small/medium blocks
    class method _memory_global_cache_insert(first_span: ^span_t; list_size: size_t; page_count: size_t);
    begin
      assert((list_size = 1) or ((first_span)^.next_span <> nil));
      {$IFNDEF ENABLE_UNLIMITED_CACHE}
      while true do begin
        var span_class_idx: size_t := _span_class_from_page_count(page_count);
        var global_span_ptr: ^Void := ^Void(InternalCalls.VolatileRead(var _memory_span_cache[span_class_idx]));
        if global_span_ptr <> ^Void(SPAN_LIST_LOCK_TOKEN) then begin
          var global_list_size: uintptr_t := uintptr_t(global_span_ptr) and not SPAN_MASK;
          var global_span: ^span_t := ^span_t(^Void(uintptr_t(global_span_ptr) and SPAN_MASK));
          {$IFNDEF DISABLE_CACHE}
          var cache_limit: size_t := GLOBAL_SPAN_CACHE_MULTIPLIER * (_memory_max_allocation[span_class_idx] / MAX_SPAN_CACHE_DIVISOR);
          if (global_list_size ≥ cache_limit) and (global_list_size > MIN_SPAN_CACHE_SIZE) then begin
            break;
          end;
          {$ENDIF}
          // We only have 16 bits for size of list, avoid overflow
          if (global_list_size + list_size) > 65535 then begin
            break;
          end;
          // Use prev_span as skip pointer over this sublist range of spans
          (first_span)^.data.list_size := uint32_t(list_size);
          (first_span)^.prev_span := global_span;
          // Insert sublist into global cache
          global_list_size := global_list_size + list_size;
          var first_span_ptr: ^Void := ^Void(uintptr_t(first_span) or global_list_size);
          if atomic_cas_ptr(@_memory_span_cache[span_class_idx], first_span_ptr, global_span_ptr) then begin
            exit;
          end;
        end
        else begin
          // Atomic operation failed, yield timeslice and retry
          thread_yield();
          atomic_thread_fence_acquire();
        end;
      end;
      {$ENDIF}
      var ispan: size_t := 0;
      while ispan < list_size do begin
        assert(first_span <> nil);
        var next_span: ^span_t := (first_span)^.next_span;
        _memory_unmap(first_span, page_count);
        first_span := next_span;
        inc(ispan);
      end;
    end;
    // ! Extract a number of memory page spans from the global cache for small/medium blocks
    class method _memory_global_cache_extract(page_count: size_t): ^span_t;
    begin
      var span: ^span_t := nil;
      var span_class_idx: size_t := _span_class_from_page_count(page_count);
      var cache: ^atomicptr_t := @_memory_span_cache[span_class_idx];
      atomic_thread_fence_acquire();
      var global_span_ptr: ^Void := ^Void(InternalCalls.VolatileRead(var cache^));
      while global_span_ptr <> nil do begin
        if (global_span_ptr <> ^Void(SPAN_LIST_LOCK_TOKEN)) and atomic_cas_ptr(cache, ^Void(SPAN_LIST_LOCK_TOKEN), global_span_ptr) then begin
          // Grab a number of thread cache spans, using the skip span pointer
          // stored in prev_span to quickly skip ahead in the list to get the new head
          var global_span_count: uintptr_t := uintptr_t(global_span_ptr) and not SPAN_MASK;
          span := ^span_t(^Void(uintptr_t(global_span_ptr) and SPAN_MASK));
          assert(((span)^.data.list_size = 1) or ((span)^.next_span <> nil));
          var new_global_span: ^span_t := (span)^.prev_span;
          global_span_count := global_span_count - (span)^.data.list_size;
          // Set new head of global cache list
          var new_cache_head: ^Void := (if global_span_count <> 0 then (^Void(uintptr_t(new_global_span) or global_span_count)) else (0));
          InternalCalls.VolatileWrite(var cache^, IntPtr(new_cache_head));
          atomic_thread_fence_release();
          break;
        end;
        // List busy, yield timeslice and retry
        thread_yield();
        atomic_thread_fence_acquire();
        global_span_ptr := ^Void(InternalCalls.VolatileRead(var cache^));
      end;
      exit span;
    end;

    // ! Insert the given list of memory page spans in the global cache for large blocks,
    //     similar to _memory_global_cache_insert 
    class method _memory_global_cache_large_insert(span_list: ^span_t; list_size: size_t; span_count: size_t);
    begin
      assert((list_size = 1) or ((span_list)^.next_span <> nil));
      assert((span_list)^.size_class = (SIZE_CLASS_COUNT + (span_count - 1)));
      {$IFNDEF ENABLE_UNLIMITED_CACHE}
      var cache: ^atomicptr_t := @_memory_large_cache[span_count - 1];
      while true do begin
        var global_span_ptr: ^Void := ^Void(InternalCalls.VolatileRead(var cache^));
        if global_span_ptr <> ^Void(SPAN_LIST_LOCK_TOKEN) then begin
          var global_list_size: uintptr_t := uintptr_t(global_span_ptr) and not SPAN_MASK;
          var global_span: ^span_t := ^span_t(^Void(uintptr_t(global_span_ptr) and SPAN_MASK));
          {$IFNDEF DISABLE_CACHE}
          var cache_limit: size_t := GLOBAL_SPAN_CACHE_MULTIPLIER * (_memory_max_allocation_large[span_count - 1] / MAX_SPAN_CACHE_DIVISOR);
          if (global_list_size ≥ cache_limit) and (global_list_size > MIN_SPAN_CACHE_SIZE) then begin
            break;
          end;
          {$ENDIF}
          if (global_list_size + list_size) > 65535 then begin
            break;
          end;
          (span_list)^.data.list_size := uint32_t(list_size);
          (span_list)^.prev_span := global_span;
          global_list_size := global_list_size + list_size;
          var new_global_span_ptr: ^Void := ^Void(uintptr_t(span_list) or global_list_size);
          if atomic_cas_ptr(cache, new_global_span_ptr, global_span_ptr) then begin
            exit;
          end;
        end
        else begin
          thread_yield();
          atomic_thread_fence_acquire();
        end;
      end;
      {$ENDIF}
      //Global cache full, release spans
      var ispan: size_t := 0;
      while ispan < list_size do begin
        assert(span_list <> nil);
        var next_span: ^span_t := (span_list)^.next_span;
        _memory_unmap(span_list, span_count * SPAN_MAX_PAGE_COUNT);
        span_list := next_span;
        inc(ispan);
      end;
    end;

    // ! Extract a number of memory page spans from the global cache for large blocks,
    //     similar to _memory_global_cache_extract 
    class method _memory_global_cache_large_extract(span_count: size_t): ^span_t;
    begin
      var span: ^span_t := nil;
      var cache: ^atomicptr_t := @_memory_large_cache[span_count - 1];
      atomic_thread_fence_acquire();
      var global_span_ptr: ^Void := ^Void(InternalCalls.VolatileRead(var cache^));
      while global_span_ptr <> nil do begin
        if (global_span_ptr <> ^Void(SPAN_LIST_LOCK_TOKEN)) and atomic_cas_ptr(cache, ^Void(SPAN_LIST_LOCK_TOKEN), global_span_ptr) then begin
          var global_list_size: uintptr_t := uintptr_t(global_span_ptr) and not SPAN_MASK;
          span := ^span_t(^Void(uintptr_t(global_span_ptr) and SPAN_MASK));
          assert(((span)^.data.list_size = 1) or ((span)^.next_span <> nil));
          assert((span)^.size_class = (SIZE_CLASS_COUNT + (span_count - 1)));
          var new_global_span: ^span_t := (span)^.prev_span;
          global_list_size := global_list_size - (span)^.data.list_size;
          var new_global_span_ptr: ^Void := (if global_list_size <> 0 then (^Void(uintptr_t(new_global_span) or global_list_size)) else (0));
          InternalCalls.VolatileWrite(var cache^, IntPtr(new_global_span_ptr));
          atomic_thread_fence_release();
          break;
        end;
        thread_yield();
        atomic_thread_fence_acquire();
        global_span_ptr := ^Void(InternalCalls.VolatileRead(var cache^));
      end;
      exit span;
    end;


    // ! Allocate a small/medium sized memory block from the given heap
    class method _memory_allocate_from_heap(heap: ^heap_t; size: size_t): ^Void;
    begin
      {$IFDEF ENABLE_STATISTICS}
	      //For statistics we need to store the requested size in the memory block
	      size := size + sizeof(size_t);
      {$ENDIF}
      var class_idx: size_t := _memory_size_class[(if size ≤ SMALL_SIZE_LIMIT then (((size + (SMALL_GRANULARITY - 1)) shr SMALL_GRANULARITY_SHIFT) - 1) else ((SMALL_CLASS_COUNT + (((size - SMALL_SIZE_LIMIT) + (MEDIUM_GRANULARITY - 1)) shr MEDIUM_GRANULARITY_SHIFT)) - 1))].class_idx;
      var active_block: ^span_block_t := @(heap)^.active_block[class_idx];
      var size_class: ^size_class_t := @_memory_size_class[class_idx];
      var class_size: count_t := (size_class)^.size;
      {$if ENABLE_STATISTICS}
      (heap)^.allocated := (heap)^.allocated + class_size;
      (heap)^.requested := (heap)^.requested + size;
      {$endif}

	    //Step 1: Try to get a block from the currently active span. The span block bookkeeping
	    //        data for the active span is stored in the heap for faster access
      use_active:;
      if (active_block^.free_count <> 0) then begin
        //Happy path, we have a span with at least one free block
        var span: ^span_t := heap^.active_span[class_idx];
        var offset: count_t  := class_size * active_block^.free_list;
        var block: ^uint32_t := ^uint32_t(pointer_offset(span, SPAN_HEADER_SIZE + offset));
        assert(span <> nil);

        dec(active_block^.free_count);
        if active_block^.free_count = 0 then begin 
          //Span is now completely allocated, set the bookkeeping data in the
          //span itself and reset the active span pointer in the heap
          span^.data.block.free_count := 0;
          span^.data.block.first_autolink := uint16_t(size_class^.block_count);
          heap^.active_span[class_idx] := nil;
        end
        else begin
          //Get the next free block, either from linked list or from auto link
          if (active_block^.free_list < active_block^.first_autolink)then begin
            active_block^.free_list := uint16_t(&block^);
          end
          else begin
            inc(active_block^.free_list);
            inc(active_block^.first_autolink);
          end;
          assert(active_block^.free_list < size_class^.block_count);
        end;

      {$if ENABLE_STATISTICS}
	      //Store the requested size for statistics
	      ^size_t(pointer_offset(block, class_size - sizeof(size_t)))^ := size;
      {$ENDIF}

	      exit block;
      end;

	    //Step 2: No active span, try executing deferred deallocations and try again if there
	    //        was at least one of the reqeusted size class
      if (_memory_deallocate_deferred(heap, class_idx)) then begin
        if (active_block^.free_count <> 0) then
			    goto use_active;
      end;

	    //Step 3: Check if there is a semi-used span of the requested size class available
        if (heap^.size_cache[class_idx] <> nil) then begin
		    //Promote a pending semi-used span to be active, storing bookkeeping data in
		    //the heap structure for faster access
          var span: ^span_t  := heap^.size_cache[class_idx];
          active_block^ := span^.data.block;
          assert(active_block^.free_count > 0);
          var next_span: ^span_t := span^.next_span;
          heap^.size_cache[class_idx] := next_span;
          heap^.active_span[class_idx] := span;
          goto use_active;
        end;

	    //Step 4: No semi-used span available, try grab a span from the thread cache
	    var span_class_idx: size_t  := _span_class_from_page_count(size_class^.page_count);
	    var span: ^span_t  := heap^.span_cache[span_class_idx];
	    if (span = nil)  then begin
		    //Step 5: No span available in the thread cache, try grab a list of spans from the global cache
		    span := _memory_global_cache_extract(size_class^.page_count);
        {$IF ENABLE_STATISTICS}
		    if (span) <> nil then
			    heap^.global_to_thread := heap^.global_to_thread +  size_t(span^.data.list_size * size_class^.page_count * PAGE_SIZE);
       {$ENDIF}
	    end;
	    if (span <> nil) then begin
		    if (span^.data.list_size > 1) then begin
			    //We got a list of spans, we will use first as active and store remainder in thread cache
			    var next_span: ^span_t := span^.next_span;
			    assert(next_span <> nil);
			    next_span^.data.list_size := span^.data.list_size - 1;
			    heap^.span_cache[span_class_idx] := next_span;
		    end
		    else begin
			    heap^.span_cache[span_class_idx] := nil;
		    end;
	    end
	    else begin
		    //Step 6: All caches empty, map in new memory pages
		    span := ^span_t(_memory_map(size_class^.page_count));
	    end;

	    //Mark span as owned by this heap and set base data
      InternalCalls.VolatileWrite(var span^.heap_id, heap^.id);
	    atomic_thread_fence_release();

	    span^.size_class := count_t(class_idx);

	    //If we only have one block we will grab it, otherwise
	    //set span as new span to use for next allocation
	    if (size_class^.block_count > 1) then begin
		    //Reset block order to sequential auto linked order
		    active_block^.free_count := uint16_t(size_class^.block_count - 1);
		    active_block^.free_list := 1;
		    active_block^.first_autolink := 1;
		    heap^.active_span[class_idx] := span;
	    end
	    else begin
		    span^.data.block.free_count := 0;
		    span^.data.block.first_autolink := uint16_t(size_class^.block_count);
	    end;

	    //Track counters
	    _memory_counter_increase(@heap^.span_counter[span_class_idx], @_memory_max_allocation[span_class_idx]);

      {$IFDEF ENABLE_STATISTICS}
	      //Store the requested size for statistics
	      (^size_t)(pointer_offset(span, SPAN_HEADER_SIZE + class_size - sizeof(size_t)))^ := size;
      {$ENDIF}

	    //Return first block if memory page span
	    exit pointer_offset(span, SPAN_HEADER_SIZE);
    end;

    // ! Allocate a large sized memory block from the given heap
    class method _memory_allocate_large_from_heap(heap: ^heap_t; size: size_t): ^Void;
    begin
      // Calculate number of needed max sized spans (including header)
      size := size + SPAN_HEADER_SIZE;
      var num_spans: size_t := size / SPAN_MAX_SIZE;
      if (size mod SPAN_MAX_SIZE) <> 0 then begin
        inc(num_spans);
      end;
      var idx: size_t := num_spans - 1;
      if idx = 0 then begin
        var span_class_idx: size_t := _span_class_from_page_count(SPAN_MAX_PAGE_COUNT);
        var span: ^span_t := (heap)^.span_cache[span_class_idx];
        if span = nil then begin
          _memory_deallocate_deferred(heap, 0);
          span := (heap)^.span_cache[span_class_idx];
        end;
        if span = nil then begin
          // Step 5: No span available in the thread cache, try grab a list of spans from the global cache
          span := _memory_global_cache_extract(SPAN_MAX_PAGE_COUNT);
          {$if ENABLE_STATISTICS}
          if span then begin
            (heap)^.global_to_thread := (heap)^.global_to_thread + size_t((span)^.data.list_size) * SPAN_MAX_PAGE_COUNT * PAGE_SIZE;
          end;
          {$endif}
        end;
        if span <> nil then begin
          if (span)^.data.list_size > 1 then begin
            // We got a list of spans, we will use first as active and store remainder in thread cache
            var next_span: ^span_t := (span)^.next_span;
            assert(next_span <> nil);
            (next_span)^.data.list_size := (span)^.data.list_size - 1;
            (heap)^.span_cache[span_class_idx] := next_span;
          end
          else begin
            (heap)^.span_cache[span_class_idx] := nil;
          end;
        end
        else begin
          // Step 6: All caches empty, map in new memory pages
          span := ^span_t(_memory_map(SPAN_MAX_PAGE_COUNT));
        end;
        // Mark span as owned by this heap and set base data
        InternalCalls.VolatileWrite(var (span)^.heap_id, (heap)^.id);
        atomic_thread_fence_release();
        (span)^.size_class := SIZE_CLASS_COUNT;
        // Track counters
        _memory_counter_increase(@(heap)^.span_counter[span_class_idx], @_memory_max_allocation[span_class_idx]);
        exit pointer_offset(span, SPAN_HEADER_SIZE);
      end;
      begin
        use_cache:;
        // Step 1: Check if cache for this large size class (or the following, unless first class) has a span
        while ((heap)^.large_cache[idx] = nil) and (idx < LARGE_CLASS_COUNT) and (idx < (num_spans + 1)) do
          inc(idx);
      end;
      var span: ^span_t := (heap)^.large_cache[idx];
      if span <> nil then begin
        // Happy path, use from cache
        if (span)^.data.list_size > 1 then begin
          var new_head: ^span_t := (span)^.next_span;
          assert(new_head <> nil);
          (new_head)^.data.list_size := (span)^.data.list_size - 1;
          (heap)^.large_cache[idx] := new_head;
        end
        else begin
          (heap)^.large_cache[idx] := nil;
        end;
        (span)^.size_class := SIZE_CLASS_COUNT + count_t(idx);
        // Increase counter
        _memory_counter_increase(@(heap)^.large_counter[idx], @_memory_max_allocation_large[idx]);
        exit pointer_offset(span, SPAN_HEADER_SIZE);
      end;
      // Restore index, we're back to smallest fitting span count
      idx := num_spans - 1;
      // Step 2: Process deferred deallocation
      if _memory_deallocate_deferred(heap, SIZE_CLASS_COUNT + idx) then begin
        goto use_cache;
      end;
      assert((heap)^.large_cache[idx] = nil);
      // Step 3: Extract a list of spans from global cache
      span := _memory_global_cache_large_extract(num_spans);
      if span <> nil then begin
        {$if ENABLE_STATISTICS}
        (heap)^.global_to_thread := (heap)^.global_to_thread + size_t((span)^.data.list_size) * num_spans * SPAN_MAX_SIZE;
        {$endif}
        // We got a list from global cache, store remainder in thread cache
        if (span)^.data.list_size > 1 then begin
          var new_head: ^span_t := (span)^.next_span;
          assert(new_head <> nil);
          (new_head)^.prev_span := nil;
          (new_head)^.data.list_size := (span)^.data.list_size - 1;
          (heap)^.large_cache[idx] := new_head;
        end;
      end
      else begin
        // Step 4: Map in more memory pages
        span := ^span_t(_memory_map(num_spans * SPAN_MAX_PAGE_COUNT));
      end;
      // Mark span as owned by this heap
      InternalCalls.VolatileWrite(var (span)^.heap_id, (heap)^.id);
      atomic_thread_fence_release();
      (span)^.size_class := SIZE_CLASS_COUNT + count_t(idx);
      // Increase counter
      _memory_counter_increase(@(heap)^.large_counter[idx], @_memory_max_allocation_large[idx]);
      exit pointer_offset(span, SPAN_HEADER_SIZE);
    end;



    //! Allocate a new heap
    class method _memory_allocate_heap(): ^heap_t;
    begin
	    var heap, next_heap: ^heap_t;
	    //Try getting an orphaned heap
	    atomic_thread_fence_acquire();
	    repeat
		    heap := ^heap_t(InternalCalls.VolatileRead(var _memory_orphan_heaps));
		    if heap = nil then 
			    break;
		    next_heap := heap^.next_orphan;
	    until atomic_cas_ptr(@_memory_orphan_heaps, next_heap, heap);

        if (heap <> nil) then begin
          heap^.next_orphan := nil;
          exit heap;
        end;

	    //Map in pages for a new heap
	    heap := ^heap_t(_memory_map(2));
	    memset(heap, 0, sizeOf(heap_t));

	    //Get a new heap ID
	    repeat
		    heap^.id := InternalCalls.Increment(var _memory_heap_id);
		    if (_memory_heap_lookup(heap^.id) <> nil) then
			    heap^.id := 0;
	    until heap^.id <> 0;

	    //Link in heap in heap ID map
	    var list_idx: size_t := heap^.id mod HEAP_ARRAY_SIZE;
	    repeat
		    next_heap := ^heap_t(InternalCalls.VolatileRead(var _memory_heaps[list_idx]));
		    heap^.next_heap := next_heap;
	    until atomic_cas_ptr(@_memory_heaps[list_idx], heap, next_heap);

	    exit heap;
    end;

    // ! Add a span to a double linked list
    class method _memory_list_add(head: ^^span_t; span: ^span_t);
    begin
      if (head)^ <> nil then begin
        ((head)^)^.prev_span := span;
        (span)^.next_span := (head)^;
      end
      else begin
        (span)^.next_span := nil;
      end;
      (head)^ := span;
    end;

    // ! Remove a span from a double linked list
    class method _memory_list_remove(head: ^^span_t; span: ^span_t);
    begin
      if (head)^ = span then begin
        (head)^ := (span)^.next_span;
      end
      else begin
        if (span)^.next_span <> nil then begin
          ((span)^.next_span)^.prev_span := (span)^.prev_span;
        end;
        ((span)^.prev_span)^.next_span := (span)^.next_span;
      end;
    end;

    //! Insert span into thread cache, releasing to global cache if overflow
    class method _memory_heap_cache_insert(heap: ^heap_t; span: ^span_t; page_count: size_t);
    begin
      {$if ENABLE_UNLIMITED_CACHE}
	      //(void)sizeof(heap);
	      _memory_global_cache_insert(span, 1, page_count);
      {$else}
	      var span_class_idx: size_t  := _span_class_from_page_count(page_count);
	      var cache: ^^ span_t := @heap^.span_cache[span_class_idx];
	      span^.next_span := cache^;
	      if cache^ <> nil then 
		      span^.data.list_size := (cache^)^.data.list_size + 1
	      else
		      span^.data.list_size := 1;
	      cache^ := span;
      {$IFNDEF DISABLE_CACHE}
	      //Check if cache exceeds limit
	      if ((span^.data.list_size >= (MIN_SPAN_CACHE_RELEASE + MIN_SPAN_CACHE_SIZE)) and
			      (span^.data.list_size > heap^.span_counter[span_class_idx].cache_limit)) then begin
		      //Release to global cache
		      var list_size: count_t := 1;
		      var next: ^span_t := span^.next_span;
		      var last: ^span_t := span;
            while (list_size < MIN_SPAN_CACHE_RELEASE) do begin
              last := next;
              next := next^.next_span;
              inc(list_size);
            end;
		      next^.data.list_size := span^.data.list_size - list_size;
		      last^.next_span := nil; //Terminate list
		      cache^ := next;
		      _memory_global_cache_insert(span, list_size, page_count);
      {$IF ENABLE_STATISTICS}
		      heap^.thread_to_global += list_size * page_count * PAGE_SIZE;
      {$endif}
	      end;
      {$endif}
      {$endif}
    end;



    // ! Deallocate the given small/medium memory block from the given heap
    class method _memory_deallocate_to_heap(heap: ^heap_t; span: ^span_t; p: ^Void);
    begin
      // Check if span is the currently active span in order to operate
      // on the correct bookkeeping data
      var class_idx := span^.size_class;
      var size_class: ^size_class_t := @_memory_size_class[class_idx];
      var is_active: Boolean := (heap)^.active_span[class_idx] = span;
      var block_data: ^span_block_t := (if is_active then (@(heap)^.active_block[class_idx]) else (@(span)^.data.block));
      {$ifdef ENABLE_STATISTICS}
      (heap)^.allocated := (heap)^.allocated - (size_class)^.size;
      (heap)^.requested := (heap)^.requested - (^size_t(pointer_offset(p, (size_class)^.size - sizeOf(size_t))))^;
      {$endif}
      // Check if the span will become completely free
      if (block_data)^.free_count = (count_t((size_class)^.block_count) - 1) then begin
        // Track counters
        var span_class_idx: size_t := _span_class_from_page_count((size_class)^.page_count);
        assert((heap)^.span_counter[span_class_idx].current_allocations > 0);
        dec((heap)^.span_counter[span_class_idx].current_allocations);
        // If it was active, reset counter. Otherwise, if not active, remove from
        // partial free list if we had a previous free block (guard for classes with only 1 block)
        if is_active then begin
          (block_data)^.free_count := 0;
        end
        else begin
          if (block_data)^.free_count > 0 then begin
            _memory_list_remove(@(heap)^.size_cache[class_idx], span);
          end;
        end;
        // Add to span cache
        _memory_heap_cache_insert(heap, span, (size_class)^.page_count);
        exit;
      end;
      // Check if first free block for this span (previously fully allocated)
      if (block_data)^.free_count = 0 then begin
        // add to free list and disable autolink
        _memory_list_add(@(heap)^.size_cache[class_idx], span);
        (block_data)^.first_autolink := uint16_t((size_class)^.block_count);
      end;
      inc((block_data)^.free_count);
      // Span is not yet completely free, so add block to the linked list of free blocks
      var blocks_start: ^Void := pointer_offset(span, SPAN_HEADER_SIZE);
      var block_offset: count_t := count_t(pointer_diff(p, blocks_start));
      var block_idx: count_t := block_offset / count_t((size_class)^.size);
      var &block: ^uint32_t := ^uint32_t(pointer_offset(blocks_start, block_idx * (size_class)^.size));
      (&block)^ := (block_data)^.free_list;
      (block_data)^.free_list := uint16_t(block_idx);
    end;




    // ! Deallocate the given large memory block from the given heap
    class method _memory_deallocate_large_to_heap(heap: ^heap_t; span: ^span_t);
    begin
      // Check if aliased with 64KiB small/medium spans
      if (span)^.size_class = SIZE_CLASS_COUNT then begin
        // Track counters
        var span_class_idx: size_t := _span_class_from_page_count(SPAN_MAX_PAGE_COUNT);
        dec((heap)^.span_counter[span_class_idx].current_allocations);
        // Add to span cache
        _memory_heap_cache_insert(heap, span, SPAN_MAX_PAGE_COUNT);
        exit;
      end;
      // Decrease counter
      var idx: size_t := (span)^.size_class - SIZE_CLASS_COUNT;
      var counter: ^span_counter_t := @(heap)^.large_counter[idx];
      assert((counter)^.current_allocations > 0);
      dec((counter)^.current_allocations);
      {$if ENABLE_UNLIMITED_CACHE}
      _memory_global_cache_large_insert(span, 1, idx + 1);
      {$else}
      // Insert into cache list
      var cache: ^^span_t := @(heap)^.large_cache[idx];
      (span)^.next_span := (cache)^;
      if (cache)^ <> nil then begin
        (span)^.data.list_size := ((cache)^)^.data.list_size + 1;
      end
      else begin
        (span)^.data.list_size := 1;
      end;
      (cache)^ := span;
      {$IFNDEF DISABLE_CACHE}
      // Check if cache exceeds limit
      if ((span)^.data.list_size ≥ (MIN_SPAN_CACHE_RELEASE + MIN_SPAN_CACHE_SIZE)) and ((span)^.data.list_size > (counter)^.cache_limit) then begin
        // Release to global cache
        var list_size: count_t := 1;
        var next: ^span_t := (span)^.next_span;
        var last: ^span_t := span;
        while list_size < MIN_SPAN_CACHE_RELEASE do begin
          last := next;
          next := (next)^.next_span;
          inc(list_size);
        end;
        assert((next)^.next_span <> nil);
        (next)^.data.list_size := (span)^.data.list_size - list_size;
        (last)^.next_span := nil;
        // Terminate list
        (cache)^ := next;
        _memory_global_cache_large_insert(span, list_size, idx + 1);
        {$if ENABLE_STATISTICS}
        (heap)^.thread_to_global := (heap)^.thread_to_global + list_size * (idx + 1) * SPAN_MAX_SIZE;
        {$endif}
      end;
      {$endif}
      {$endif}
    end;
    // ! Process pending deferred cross-thread deallocations
    class method _memory_deallocate_deferred(heap: ^heap_t; size_class: size_t): Boolean;
    begin
      // Grab the current list of deferred deallocations
      atomic_thread_fence_acquire();
      var p: ^Void := ^Void(InternalCalls.VolatileRead(var (heap)^.defer_deallocate));
      if p = nil then begin
        exit false;
      end;
      if not atomic_cas_ptr(@(heap)^.defer_deallocate, ^Void(0), p) then begin
        exit false;
      end;
      // Keep track if we deallocate in the given size class
      var got_class: Boolean := false;
      repeat
        var next: ^Void := (^^Void(p))^;
        // Get span and check which type of block
        var span: ^span_t := ^span_t(uintptr_t(p) and SPAN_MASK);
        if (span)^.size_class < SIZE_CLASS_COUNT then begin
          // Small/medium block
          got_class := got_class or ((span)^.size_class = size_class);
          _memory_deallocate_to_heap(heap, span, p);
        end
        else begin
          // Large block
          got_class := got_class or ((span)^.size_class ≥ size_class) and ((span)^.size_class ≤ (size_class + 2));
          _memory_deallocate_large_to_heap(heap, span);
        end;
        // Loop until all pending operations in list are processed
        p := next;
      until p = nil;
      exit got_class;
    end;

    // ! Defer deallocation of the given block to the given heap
    class method _memory_deallocate_defer(heap_id: int32_t; p: ^Void);
    begin
      // Get the heap and link in pointer in list of deferred opeations
      var heap: ^heap_t := _memory_heap_lookup(heap_id);
      var last_ptr: ^Void;
      repeat
        last_ptr := ^Void(InternalCalls.VolatileRead(var (heap)^.defer_deallocate));
        (^^Void(p))^ := last_ptr;
        // Safe to use block, it's being deallocated
      until atomic_cas_ptr(@(heap)^.defer_deallocate, p, last_ptr);
    end;
    {$IFDEF ARM}
    [SymbolName('llvm.arm.dmb')]
    class method llvmdmb(i: Integer); external;
    
    class method atomic_thread_fence_acquire; inline;
    begin 
      llvmdmb(15);
    end;
    
    class method atomic_thread_fence_release; inline;
    begin 
      llvmdmb(14);
    end;
    {$ELSE}
    class method atomic_thread_fence_acquire; inline;
    begin 
    end;
    
    class method atomic_thread_fence_release; inline;
    begin 
    end;    
    {$ENDIF}

    // ! Allocate a block of the given size
    class method _memory_allocate(size: size_t): ^Void;
    begin
      if size ≤ MEDIUM_SIZE_LIMIT then begin
        exit _memory_allocate_from_heap(_memory_thread_heap, size);
      end
      else begin
        if size ≤ LARGE_SIZE_LIMIT then begin
          exit _memory_allocate_large_from_heap(_memory_thread_heap, size);
        end;
      end;
      // Oversized, allocate pages directly
      size := size + SPAN_HEADER_SIZE;
      var num_pages: size_t := size / PAGE_SIZE;
      if (size mod PAGE_SIZE) <> 0 then begin
        inc(num_pages);
      end;
      var span: ^span_t := ^span_t(_memory_map(num_pages));
      InternalCalls.VolatileWrite(var (span)^.heap_id, 0);
      // Store page count in next_span
      (span)^.next_span := ^span_t(uintptr_t(num_pages));
      exit pointer_offset(span, SPAN_HEADER_SIZE);
    end;
    // ! Deallocate the given block
    class method _memory_deallocate(p: ^Void);
    begin
      if p = nil then begin
        exit;
      end;
      // Grab the span (always at start of span, using 64KiB alignment)
      var span: ^span_t := ^span_t(uintptr_t(p) and SPAN_MASK);
      var heap_id: int32_t := InternalCalls.VolatileRead(var (span)^.heap_id);
      var heap: ^heap_t := _memory_thread_heap;
      // Check if block belongs to this heap or if deallocation should be deferred
      if heap_id = (heap)^.id then begin
        if (span)^.size_class < SIZE_CLASS_COUNT then begin
          _memory_deallocate_to_heap(heap, span, p);
        end
        else begin
          _memory_deallocate_large_to_heap(heap, span);
        end;
      end
      else begin
        if heap_id > 0 then begin
          _memory_deallocate_defer(heap_id, p);
        end
        else begin
          // Oversized allocation, page count is stored in next_span
          var num_pages: size_t := size_t((span)^.next_span);
          _memory_unmap(span, num_pages);
        end;
      end;
    end;

    // ! Reallocate the given block to the given size
    class method _memory_reallocate(p: ^Void; size: size_t; oldsize: size_t; &flags: UInt32): ^Void;
    begin
      if p <> nil then begin
        // Grab the span (always at start of span, using 64KiB alignment)
        var span: ^span_t := ^span_t(uintptr_t(p) and SPAN_MASK);
        var heap_id: int32_t := InternalCalls.VolatileRead(var (span)^.heap_id);
        if heap_id <> 0 then begin
          if (span)^.size_class < SIZE_CLASS_COUNT then begin
            // Small/medium sized block
            var size_class: ^size_class_t := @_memory_size_class[(span)^.size_class];
            if size_t((size_class)^.size) ≥ size then begin
              exit p;
            end;
            // Still fits in block, never mind trying to save memory
            if oldsize = 0 then begin
              oldsize := (size_class)^.size;
            end;
          end
          else begin
            // Large block
            var total_size: size_t := size + SPAN_HEADER_SIZE;
            var num_spans: size_t := total_size / SPAN_MAX_SIZE;
            if (total_size mod SPAN_MAX_SIZE) <> 0 then begin
              inc(num_spans);
            end;
            var current_spans: size_t := ((span)^.size_class - SIZE_CLASS_COUNT) + 1;
            if (current_spans ≥ num_spans) and (num_spans ≥ (current_spans / 2)) then begin
              exit p;
            end;
            // Still fits and less than half of memory would be freed
            if oldsize = 0 then begin
              oldsize := (current_spans * size_t(SPAN_MAX_SIZE)) - SPAN_HEADER_SIZE;
            end;
          end;
        end
        else begin
          // Oversized block
          var total_size: size_t := size + SPAN_HEADER_SIZE;
          var num_pages: size_t := total_size / PAGE_SIZE;
          if (total_size mod PAGE_SIZE) <> 0 then begin
            inc(num_pages);
          end;
          // Page count is stored in next_span
          var current_pages: size_t := size_t((span)^.next_span);
          if (current_pages ≥ num_pages) and (num_pages ≥ (current_pages / 2)) then begin
            exit p;
          end;
          // Still fits and less than half of memory would be freed
          if oldsize = 0 then begin
            oldsize := (current_pages * size_t(PAGE_SIZE)) - SPAN_HEADER_SIZE;
          end;
        end;
      end;
      // Size is greater than block size, need to allocate a new block and deallocate the old
      // Avoid hysteresis by overallocating if increase is small (below 37%)
      var lower_bound: size_t := oldsize + (oldsize shr 2) + (oldsize shr 3);
      var &block: ^Void := _memory_allocate((if size > lower_bound then (size) else (lower_bound)));
      if p <> nil  then begin
        if (&flags and RPMALLOC_NO_PRESERVE) <> 0 then begin
          memcpy(&block, p, (if oldsize < size then (oldsize) else (size)));
        end;
        _memory_deallocate(p);
      end;
      exit &block;

    end;

    // ! Get the usable size of the given block
    class method _memory_usable_size(p: ^Void): size_t;
    begin
      // Grab the span (always at start of span, using 64KiB alignment)
      var span: ^span_t := ^span_t(uintptr_t(p) and SPAN_MASK);
      var heap_id: int32_t := InternalCalls.VolatileRead(var (span)^.heap_id);
      if heap_id <> 0 then begin
        if (span)^.size_class < SIZE_CLASS_COUNT then begin
          // Small/medium block
          var size_class: ^size_class_t := @_memory_size_class[(span)^.size_class];
          exit (size_class)^.size;
        end;
        // Large block
        var current_spans: size_t := ((span)^.size_class - SIZE_CLASS_COUNT) + 1;
        exit (current_spans * size_t(SPAN_MAX_SIZE)) - SPAN_HEADER_SIZE;
      end;
      // Oversized block, page count is stored in next_span
      var current_pages: size_t := size_t((span)^.next_span);
      exit (current_pages * size_t(PAGE_SIZE)) - SPAN_HEADER_SIZE;
    end;

    // ! Adjust and optimize the size class properties for the given class
    class method _memory_adjust_size_class(iclass: size_t);
    begin
      // Calculate how many pages are needed for 255 blocks
      var block_size: size_t := _memory_size_class[iclass].size;
      var page_count: size_t := (block_size * 255) / PAGE_SIZE;
      // Cap to 16 pages (64KiB span granularity)
      page_count := (if page_count = 0 then (1) else ((if page_count > 16 then (16) else (page_count))));
      // Merge page counts to span size class granularity
      page_count := ((page_count + (SPAN_CLASS_GRANULARITY - 1)) / SPAN_CLASS_GRANULARITY) * SPAN_CLASS_GRANULARITY;
      if page_count > 16 then begin
        page_count := 16;
      end;
      var block_count: size_t := ((page_count * PAGE_SIZE) - SPAN_HEADER_SIZE) / block_size;
      // Store the final configuration
      _memory_size_class[iclass].page_count := uint16_t(page_count);
      _memory_size_class[iclass].block_count := uint16_t(block_count);
      _memory_size_class[iclass].class_idx := uint16_t(iclass);
      // Check if previous size classes can be merged
      var prevclass: size_t := iclass;
      while prevclass > 0 do begin
        dec(prevclass);
        // A class can be merged if number of pages and number of blocks are equal
        if (_memory_size_class[prevclass].page_count = _memory_size_class[iclass].page_count) and (_memory_size_class[prevclass].block_count = _memory_size_class[iclass].block_count) then begin
          memcpy(@_memory_size_class[prevclass], @_memory_size_class[iclass], sizeOf(_memory_size_class[iclass]));
        end
        else begin
          break;
        end;
      end;
    end;
  
    method rpmalloc_initialize(): Integer; public;
    begin
      {$ifdef PLATFORM_WINDOWS}
      var system_info: SYSTEM_INFO;
      memset(@system_info, 0, sizeOf(system_info));
      GetSystemInfo(@system_info);
      if system_info.dwAllocationGranularity < SPAN_ADDRESS_GRANULARITY then begin
        exit -1;
      end;
      {$else}
      {$IFDEF CPU64}
      InternalCalls.VolatileWrite(var _memory_addr, 68719476736);
      {$else}
      InternalCalls.VolatileWrite(var _memory_addr, 16777216);
      {$endif}
      {$endif}
      InternalCalls.VolatileWrite(var _memory_heap_id, 0);
      // Setup all small and medium size classes
      var iclass: size_t;
      iclass := 0;
      while iclass < SMALL_CLASS_COUNT do begin
        var size: size_t := (iclass + 1) * SMALL_GRANULARITY;
        _memory_size_class[iclass].size := uint16_t(size);
        _memory_adjust_size_class(iclass);
        inc(iclass);
      end;
      iclass := 0;
      while iclass < MEDIUM_CLASS_COUNT do begin
        var size: size_t := SMALL_SIZE_LIMIT + ((iclass + 1) * MEDIUM_GRANULARITY);
        if size > MEDIUM_SIZE_LIMIT then begin
          size := MEDIUM_SIZE_LIMIT;
        end;
        _memory_size_class[SMALL_CLASS_COUNT + iclass].size := uint16_t(size);
        _memory_adjust_size_class(SMALL_CLASS_COUNT + iclass);
        inc(iclass);
      end;
      // Initialize this thread
      rpmalloc_thread_initialize();
      exit 0;
    end;

    class method rpmalloc_finalize; public;
    begin 
	    atomic_thread_fence_acquire();

	    //Free all thread caches
	    for list_idx: Integer := 0 to HEAP_ARRAY_SIZE -1 do begin 
		    var heap: ^heap_t := ^heap_t(InternalCalls.VolatileRead(var _memory_heaps[list_idx]));
		    while (heap) <> nil do begin
			    _memory_deallocate_deferred(heap, 0);

			    for iclass: Integer := 0 to SPAN_CLASS_COUNT -1 do begin 
				    var page_count: size_t := (iclass + 1) * SPAN_CLASS_GRANULARITY;
				    var span: ^span_t := heap^.span_cache[iclass];
				    var span_count: UInt32 := if span <> nil then span^.data.list_size else 0;
				    for ispan: Integer := 0 to span_count-1 do begin
					    var next_span: ^span_t := span^.next_span;
					    _memory_unmap(span, page_count);
					    span := next_span;
				    end;
			    end;

			    //Free large spans
			    for iclass: Integer := 0 to LARGE_CLASS_COUNT -1 do begin
				    var span_count: size_t := iclass + 1;
				    var span: ^span_t := heap^.large_cache[iclass];
				    while (span) <> nil do begin
					    var next_span: ^span_t := span^.next_span;
					    _memory_unmap(span, span_count * SPAN_MAX_PAGE_COUNT);
					    span := next_span;
				    end;
			    end;

			    var next_heap: ^heap_t := heap^.next_heap;
			    _memory_unmap(heap, 2);
			    heap := next_heap;
		    end;

		    InternalCalls.VolatileWrite(var _memory_heaps[list_idx], 0);
	    end;
	    InternalCalls.VolatileWrite(var _memory_orphan_heaps, 0);

	    //Free global caches
	    for iclass: Integer := 0 to SPAN_CLASS_COUNT -1 do begin
		    var span_ptr: ^Void := ^Void(InternalCalls.VolatileRead(var _memory_span_cache[iclass]));
		    var cache_count: size_t  := uintptr_t(span_ptr) and not SPAN_MASK;
		    var span: ^span_t := ^span_t(^Void(uintptr_t(span_ptr) and SPAN_MASK));
		    while (cache_count <> 0) do begin
			    var skip_span: ^span_t := span^.prev_span;
			    var span_count: UInt32 := span^.data.list_size;
			    for ispan: Integer := 0 to span_count -1 do begin
				    var next_span: ^span_t := span^.next_span;
				    _memory_unmap(span, (iclass + 1) * SPAN_CLASS_GRANULARITY);
				    span := next_span;
			    end;
			    span := skip_span;
			    cache_count := cache_count - span_count;
		    end;
		    InternalCalls.VolatileWrite(var _memory_span_cache[iclass], 0);
	    end;

	    for iclass: Integer := 0 to LARGE_CLASS_COUNT -1 do begin
		    var span_ptr: ^Void := ^Void(InternalCalls.VolatileRead(var _memory_large_cache[iclass]));
		    var cache_count: size_t := uintptr_t(span_ptr) and not SPAN_MASK;
		    var span: ^span_t := ^span_t(^Void(uintptr_t(span_ptr) and SPAN_MASK));
		    while (cache_count) <> 0 do begin
			    var skip_span: ^span_t := span^.prev_span;
			    var span_count: Cardinal := span^.data.list_size;
          var ispan := 0;
          while ispan < span_count do begin
				    var next_span: ^span_t := span^.next_span;
				    _memory_unmap(span, (iclass + 1) * SPAN_MAX_PAGE_COUNT);
				    span := next_span;
            inc(ispan);
			    end;
			    span := skip_span;
			    cache_count := cache_count - span_count;
		    end;
		    InternalCalls.VolatileWrite(var _memory_large_cache[iclass], 0);
	    end;

	    atomic_thread_fence_release();
    end;




    method rpmalloc_thread_initialize; public;
    begin
      if _memory_thread_heap = nil then begin
        var heap: ^heap_t := _memory_allocate_heap();
        {$if ENABLE_STATISTICS}
        (heap)^.thread_to_global := 0;
        (heap)^.global_to_thread := 0;
        {$endif}
        _memory_thread_heap := heap;
        InternalCalls.Increment(var _memory_active_heaps);
      end;
    end;

    method rpmalloc_thread_finalize; public;
    begin
      var heap: ^heap_t := _memory_thread_heap;
      if heap = nil then begin
        exit;
      end;
      InternalCalls.Add(var _memory_active_heaps, -1);
      _memory_deallocate_deferred(heap, 0);
      var iclass: size_t := 0;
      while iclass < SPAN_CLASS_COUNT do begin
        var page_count: size_t := (iclass + 1) * SPAN_CLASS_GRANULARITY;
        var span: ^span_t := (heap)^.span_cache[iclass];
        while span <> nil do begin
          if (span)^.data.list_size > MIN_SPAN_CACHE_RELEASE then begin
            var list_size: count_t := 1;
            var next: ^span_t := (span)^.next_span;
            var last: ^span_t := span;
            while list_size < MIN_SPAN_CACHE_RELEASE do begin
              last := next;
              next := (next)^.next_span;
              inc(list_size);
            end;
            (last)^.next_span := nil;
            // Terminate list
            (next)^.data.list_size := (span)^.data.list_size - list_size;
            _memory_global_cache_insert(span, list_size, page_count);
            span := next;
          end
          else begin
            _memory_global_cache_insert(span, (span)^.data.list_size, page_count);
            span := nil;
          end;
        end;
        (heap)^.span_cache[iclass] := nil;
        inc(iclass);
      end;
      iclass := 0;
      while iclass < LARGE_CLASS_COUNT do begin
        var span_count: size_t := iclass + 1;
        var span: ^span_t := (heap)^.large_cache[iclass];
        while span <> nil do begin
          if (span)^.data.list_size > MIN_SPAN_CACHE_RELEASE then begin
            var list_size: count_t := 1;
            var next: ^span_t := (span)^.next_span;
            var last: ^span_t := span;
            while list_size < MIN_SPAN_CACHE_RELEASE do begin
              last := next;
              next := (next)^.next_span;
              inc(list_size);
            end;
            (last)^.next_span := nil;
            // Terminate list
            (next)^.data.list_size := (span)^.data.list_size - list_size;
            _memory_global_cache_large_insert(span, list_size, span_count);
            span := next;
          end
          else begin
            _memory_global_cache_large_insert(span, (span)^.data.list_size, span_count);
            span := nil;
          end;
        end;
        (heap)^.large_cache[iclass] := nil;
        inc(iclass);
      end;
      // Reset allocation counters
      memset((heap)^.span_counter, 0, (sizeOf(heap^.span_counter)));
      memset((heap)^.large_counter, 0, (sizeOf(heap^.large_counter)));
      {$if ENABLE_STATISTICS}
      (heap)^.requested := 0;
      (heap)^.allocated := 0;
      (heap)^.thread_to_global := 0;
      (heap)^.global_to_thread := 0;
      {$endif}
      // Orphan the heap
      var last_heap: ^heap_t;
      repeat
        last_heap := ^heap_t(InternalCalls.VolatileRead(var _memory_orphan_heaps));
        (heap)^.next_orphan := last_heap;
      until atomic_cas_ptr(@_memory_orphan_heaps, heap, last_heap);
      _memory_thread_heap := nil;
    end;

    method rpmalloc_is_thread_initialized: Boolean;
    begin
      exit _memory_thread_heap <> nil;
    end;

    // ! Map new pages to virtual memory
    class method _memory_map(page_count: size_t): ^Void;
    begin
      var total_size: size_t := page_count * PAGE_SIZE;
      var pages_ptr: ^Void := nil;
      {$if ENABLE_STATISTICS}
      atomic_add32(@_mapped_pages, int32_t(page_count));
      atomic_add32(@_mapped_total, int32_t(page_count));
      {$endif}
      {$IFDEF WebAssembly}
      pages_ptr := ^Void(WebAssemblyCalls.GrowMemory(page_count) * PAGE_SIZE);
      if IntPtr(pages_ptr) = -1 then pages_ptr := nil;
      {$elseif PLATFORM_WINDOWS}
      pages_ptr := VirtualAlloc(0, total_size, MEM_RESERVE or MEM_COMMIT, PAGE_READWRITE);
      {$else}
      // mmap lacks a way to set 64KiB address granularity, implement it locally
      var incr: intptr_t := intptr_t(total_size) / intptr_t(SPAN_ADDRESS_GRANULARITY);
      if (total_size mod SPAN_ADDRESS_GRANULARITY) <> 0 then begin
        inc(incr);
      end;
      repeat
        var base_addr: ^Void := ^Void(uintptr_t(InternalCalls.Add(var _memory_addr, incr * intptr_t(SPAN_ADDRESS_GRANULARITY))));
        pages_ptr := rtl.mmap(base_addr, total_size, rtl.PROT_READ or rtl.PROT_WRITE, rtl.MAP_PRIVATE or rtl.MAP_ANONYMOUS or rtl.MAP_UNINITIALIZED, -1, 0);
        if pages_ptr <> rtl.MAP_FAILED then begin
          if pages_ptr <> base_addr then begin
            var new_base: ^Void := ^Void(uintptr_t(pages_ptr) and SPAN_MASK);
            InternalCalls.VolatileWrite(var _memory_addr, int64_t(uintptr_t(new_base)) + ((incr + 1) * intptr_t(SPAN_ADDRESS_GRANULARITY)));
            atomic_thread_fence_release();
          end;
          if (uintptr_t(pages_ptr) and not SPAN_MASK) = 0 then begin
            break;
          end;
          rtl.munmap(pages_ptr, total_size);
        end;
      until false;
      {$endif}
      exit pages_ptr;
    end;

    // ! Unmap pages from virtual memory
    class method _memory_unmap(ptr: ^Void; page_count: size_t);
    begin
      {$if ENABLE_STATISTICS}
      atomic_add32(@_mapped_pages, -int32_t(page_count));
      atomic_add32(@_unmapped_total, int32_t(page_count));
      {$endif}
      {$IFDEF webassembly}
      // can't release arbitrary pages in wasm
      {$elseif PLATFORM_WINDOWS}
      VirtualFree(ptr, 0, MEM_RELEASE);
      {$else}
      rtl.munmap(ptr, PAGE_SIZE * page_count);
      {$endif}
    end;


    class method atomic_cas_ptr(dst: ^atomicptr_t; val: ^Void; aref: ^Void): Boolean; inline;
    begin
      exit InternalCalls.CompareExchange(var dst^, IntPtr(val), IntPtr(aref)) = IntPtr(aref);
    end;

    // ! Yield the thread remaining timeslice
    class method thread_yield();
    begin
      {$IFDEF WEBASSEMBLY}
      // do nothing; there's no yield in wasm
      {$elseif PLATFORM_WINDOWS}
      rtl.YieldProcessor();
      {$else}
      rtl.sched_yield();
      {$endif}
    end;

    method rpmalloc(size: size_t): ^Void;
    begin
      {$if ENABLE_VALIDATE_ARGS}
      if size ≥ MAX_ALLOC_SIZE then begin
        errno := EINVAL;
        exit 0;
      end;
      {$endif}
      exit _memory_allocate(size);
    end;

    method rpfree(ptr: ^Void);
    begin
      _memory_deallocate(ptr);
    end;

    method rpcalloc(num: size_t; size: size_t): ^Void;
    begin
      var total: size_t;
      {$if ENABLE_VALIDATE_ARGS}
      {$ifdef PLATFORM_WINDOWS}
      var err: Integer := SizeTMult(num, size, @total);
      if (err <> S_OK) or (total ≥ MAX_ALLOC_SIZE) then begin
        errno := EINVAL;
        exit 0;
      end;
      {$else}
      var err: Integer := __builtin_umull_overflow(num, size, @total);
      if err or (total ≥ MAX_ALLOC_SIZE) then begin
        errno := EINVAL;
        exit 0;
      end;
      {$endif}
      {$else}
      total := num * size;
      {$endif}
      var ptr: ^Void := _memory_allocate(total);
      memset(ptr, 0, total);
      exit ptr;
    end;
    method rprealloc(ptr: ^Void; size: size_t): ^Void;
    begin
      {$if ENABLE_VALIDATE_ARGS}
      if size ≥ MAX_ALLOC_SIZE then begin
        errno := EINVAL;
        exit ptr;
      end;
      {$endif}
      exit _memory_reallocate(ptr, size, 0, 0);
    end;

    method rpaligned_realloc(ptr: ^Void; alignment: size_t; size: size_t; oldsize: size_t; &flags: UInt32): ^Void;
    begin
      {$if ENABLE_VALIDATE_ARGS}
    if (size + alignment) < size then begin
      errno := EINVAL;
      exit 0;
    end;
      {$endif}
      exit _memory_reallocate(ptr, size, oldsize, &flags);
    end;

    method rpaligned_alloc(alignment: size_t; size: size_t): ^Void;
    begin
      if alignment ≤ 16 then begin
        exit rpmalloc(size);
      end;
      {$if ENABLE_VALIDATE_ARGS}
      if (size + alignment) < size then begin
        errno := EINVAL;
        exit 0;
      end;
      {$endif}
      var ptr: ^Void := rpmalloc(size + alignment);
      if (uintptr_t(ptr) and (alignment - 1)) <> 0 then begin
        ptr := ^Void((uintptr_t(ptr) and not uintptr_t(alignment) - 1) + alignment);
      end;
      exit ptr;
    end;


    method rpmemalign(alignment: size_t; size: size_t): ^Void;
    begin
      exit rpaligned_alloc(alignment, size);
    end;

    method rpposix_memalign(memptr: ^^Void; alignment: size_t; size: size_t): Integer;
    begin
      if memptr <> nil then begin
        (memptr)^ := rpaligned_alloc(alignment, size);
      end
      else begin
        exit 22;//EINVAL;
      end;
      exit (if (memptr)^ <> nil then (0) else (12{ENOMEM}));
    end;
    method rpmalloc_usable_size(ptr: ^Void): size_t;
    begin
      exit (if ptr <> nil then (_memory_usable_size(ptr)) else (0));
    end;

    method rpmalloc_thread_collect;
    begin
      _memory_deallocate_deferred(_memory_thread_heap, 0);
    end;

    method rpmalloc_thread_statistics(stats: ^rpmalloc_thread_statistics_t);
    begin
      memset(stats, 0, sizeOf(rpmalloc_thread_statistics_t));
      var heap: ^heap_t := _memory_thread_heap;
      {$if ENABLE_STATISTICS}
      (stats)^.allocated := (heap)^.allocated;
      (stats)^.requested := (heap)^.requested;
      {$endif}
      var p: ^Void := ^Void(InternalCalls.VolatileRead(var (heap)^.defer_deallocate));
      while p <> nil do begin
        var next: ^Void := (^^Void(p))^;
        var span: ^span_t := ^span_t(uintptr_t(p) and SPAN_MASK);
        (stats)^.deferred := (stats)^.deferred + _memory_size_class[(span)^.size_class].size;
        p := next;
      end;
      var isize: size_t := 0;
      while isize < SIZE_CLASS_COUNT do begin
        if (heap)^.active_block[isize].free_count <> 0 then begin
          (stats)^.active := (stats)^.active + (heap)^.active_block[isize].free_count * _memory_size_class[((heap)^.active_span[isize])^.size_class].size;
        end;
        var cache: ^span_t := (heap)^.size_cache[isize];
        while cache <> nil do begin
          (stats)^.sizecache := (cache)^.data.block.free_count * _memory_size_class[(cache)^.size_class].size;
          cache := (cache)^.next_span;
        end;
        inc(isize);
      end;
      isize := 0;
      while isize < SPAN_CLASS_COUNT do begin
        if (heap)^.span_cache[isize] <> nil then begin
          (stats)^.spancache := size_t(((heap)^.span_cache[isize])^.data.list_size) * (isize + 1) * SPAN_CLASS_GRANULARITY * PAGE_SIZE;
        end;
        inc(isize);
      end;
    end;

    method rpmalloc_global_statistics(stats: ^rpmalloc_global_statistics_t);
    begin
      memset(stats, 0, sizeOf(rpmalloc_global_statistics_t));
      {$if ENABLE_STATISTICS}
      (stats)^.mapped := size_t(atomic_load32(@_mapped_pages)) * PAGE_SIZE;
      (stats)^.mapped_total := size_t(atomic_load32(@_mapped_total)) * PAGE_SIZE;
      (stats)^.unmapped_total := size_t(atomic_load32(@_unmapped_total)) * PAGE_SIZE;
      {$ENDIF}
      var iclass: size_t := 0;
      while iclass < SPAN_CLASS_COUNT do begin
        var global_span_ptr: ^Void := ^Void(InternalCalls.VolatileRead(var _memory_span_cache[iclass]));
        while global_span_ptr = ^Void(SPAN_LIST_LOCK_TOKEN) do begin
          thread_yield();
          global_span_ptr := ^Void(InternalCalls.VolatileRead(var _memory_span_cache[iclass]));
        end;
        var global_span_count: uintptr_t := uintptr_t(global_span_ptr) and not SPAN_MASK;
        var list_bytes: size_t := global_span_count * (iclass + 1) * SPAN_CLASS_GRANULARITY * PAGE_SIZE;
        (stats)^.cached := (stats)^.cached + list_bytes;
        inc(iclass);
      end;
      iclass := 0;
      while iclass < LARGE_CLASS_COUNT do begin
        var global_span_ptr: ^Void := ^Void(InternalCalls.VolatileRead(var _memory_large_cache[iclass]));
        while global_span_ptr = ^Void(SPAN_LIST_LOCK_TOKEN) do begin
          thread_yield();
          global_span_ptr := ^Void(InternalCalls.VolatileRead(var _memory_large_cache[iclass]));
        end;
        var global_span_count: uintptr_t := uintptr_t(global_span_ptr) and not SPAN_MASK;
        var list_bytes: size_t := global_span_count * (iclass + 1) * SPAN_MAX_PAGE_COUNT * PAGE_SIZE;
        (stats)^.cached_large := (stats)^.cached_large + list_bytes;
        inc(iclass);
      end;
    end;
  end;


  var MAllocInitialized: Boolean; assembly;
  
  [SymbolName('malloc')]
  method malloc(size: size_t): ^Void; public;
  begin
    // TODO: when threading, load the thread
    if not MAllocInitialized then begin 
      MAllocInitialized := true;
      rpmalloc.rpmalloc_initialize;
    end;
    exit rpmalloc.rpmalloc(size);
  end;

  [SymbolName('free')]
  method free(val: ^Void); public;
  begin
    // TODO: when threading, load the thread
    if not MAllocInitialized then begin 
      MAllocInitialized := true;
      rpmalloc.rpmalloc_initialize;
    end;
    rpmalloc.rpfree(val);
  end;

end.
