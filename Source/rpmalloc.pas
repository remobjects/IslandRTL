namespace RemObjects.Elements.System.rpmalloc;

// Automatically converted with FOxidizer; do not modify manually!

{$CCOMPATIBILITY ON}

uses
  rtl;

{$GLOBALS ON}

{$IF NOT ENABLE_THREAD_CACHE}
// / Build time configurable limits
// ! Size of heap hashmap
// ! Enable per-thread cache
const ENABLE_THREAD_CACHE = 1; public;
{$ENDIF}
{$IF NOT ENABLE_STATISTICS}
// ! Enable validation of args to public entry points
// ! Enable statistics collection
const ENABLE_STATISTICS = 0; public;
{$ENDIF}
{$IF NOT ENABLE_ASSERTS}
// ! Enable asserts
const ENABLE_ASSERTS = 0; public;
{$ENDIF}
{$IF NOT ENABLE_GUARDS}
// ! Support preloading
// ! Enable overwrite/underwrite guards
const ENABLE_GUARDS = 0; public;
{$ENDIF}
{$IF NOT ENABLE_UNLIMITED_CACHE}
// ! Unlimited cache disables any cache limitations
const ENABLE_UNLIMITED_CACHE = 0; public;
{$ENDIF}
{$IF NOT DEFAULT_SPAN_MAP_COUNT}
// ! Default number of spans to map in call to map more virtual memory
const DEFAULT_SPAN_MAP_COUNT = 16; public;
{$ENDIF}
// ! Minimum cache size to remain after a release to global cache
const MIN_SPAN_CACHE_SIZE = 64; public;
// ! Minimum number of spans to transfer between thread and global cache
const MIN_SPAN_CACHE_RELEASE = 16; public;
// ! Maximum cache size divisor (max cache size will be max allocation count divided by this divisor)
const MAX_SPAN_CACHE_DIVISOR = 4; public;
// ! Minimum cache size to remain after a release to global cache, large spans
const MIN_LARGE_SPAN_CACHE_SIZE = 8; public;
// ! Minimum number of spans to transfer between thread and global cache, large spans
const MIN_LARGE_SPAN_CACHE_RELEASE = 4; public;
// ! Maximum cache size divisor, large spans (max cache size will be max allocation count divided by this divisor)
const MAX_LARGE_SPAN_CACHE_DIVISOR = 16; public;
// ! Multiplier for global span cache limit (max cache size will be calculated like thread cache and multiplied with this)
const MAX_GLOBAL_CACHE_MULTIPLIER = 8; public;
// #undef ENABLE_GLOBAL_CACHE
// #undef MIN_SPAN_CACHE_SIZE
// #undef MIN_SPAN_CACHE_RELEASE
// #undef MAX_SPAN_CACHE_DIVISOR
// #undef MIN_LARGE_SPAN_CACHE_SIZE
// #undef MIN_LARGE_SPAN_CACHE_RELEASE
// #undef MAX_LARGE_SPAN_CACHE_DIVISOR
// / Platform and arch specifics
const ARCH_64BIT = 0; public;
const PLATFORM_WINDOWS = 0; public;
const PLATFORM_POSIX = 1; public;

method atomic_load32(src: ^atomic32_t): Int32; public;
begin
  exit (src)^.nonatomic;
end;

method atomic_store32(dst: ^atomic32_t; val: Int32); public;
begin
  (dst)^.nonatomic := val;
end;

method atomic_incr32(val: ^atomic32_t): Int32; public;
begin
  exit __sync_add_and_fetch(@(val)^.nonatomic, 1);
end;

method atomic_add32(val: ^atomic32_t; &add: Int32): Int32; public;
begin
  exit __sync_add_and_fetch(@(val)^.nonatomic, &add);
end;

method atomic_load_ptr(src: ^atomicptr_t): ^Void; public;
begin
  exit ^Void(UIntPtr((src)^.nonatomic));
end;

method atomic_store_ptr(dst: ^atomicptr_t; val: ^Void); public;
begin
  (dst)^.nonatomic := val;
end;

method atomic_cas_ptr(dst: ^atomicptr_t; val: ^Void; ref: ^Void): Int32; public;
begin
  exit __sync_bool_compare_and_swap(@(dst)^.nonatomic, ref, val);
end;

var _memory_config: rpmalloc_config_t; assembly;
var _memory_page_size: IntPtr; assembly;
var _memory_page_size_shift: IntPtr; assembly;
var _memory_page_mask: IntPtr; assembly;
var _memory_map_granularity: IntPtr; assembly;
var _memory_span_size: IntPtr; assembly;
var _memory_span_size_shift: IntPtr; assembly;
var _memory_span_mask: UIntPtr; assembly;
var _memory_size_class: array[0..122] of size_class_t; assembly;
var _memory_medium_size_limit: IntPtr; assembly;
var _memory_heap_id: atomic32_t; assembly;
{$IF ENABLE_THREAD_CACHE}
var _memory_max_allocation: array[0..31] of UInt32; assembly;
{$ENDIF}
var _memory_heaps: array[0..78] of atomicptr_t; assembly;
var _memory_orphan_heaps: atomicptr_t; assembly;
var _memory_orphan_counter: atomic32_t; assembly;
var _memory_active_heaps: atomic32_t; assembly;
{$IF ENABLE_STATISTICS}
var _mapped_pages: atomic32_t; assembly;
{$ENDIF}
{$IF ENABLE_STATISTICS}
var _reserved_spans: atomic32_t; assembly;
{$ENDIF}
{$IF ENABLE_STATISTICS}
var _mapped_total: atomic32_t; assembly;
{$ENDIF}
{$IF ENABLE_STATISTICS}
var _unmapped_total: atomic32_t; assembly;
{$ENDIF}
var _memory_thread_heap: ^heap_t; assembly;

// ! Get the current thread heap
method get_thread_heap: ^heap_t; public;
begin
  exit _memory_thread_heap;
end;

// ! Set the current thread heap
method set_thread_heap(heap: ^heap_t); public;
begin
  _memory_thread_heap := heap;
end;

// ! Lookup a memory heap from heap ID
method _memory_heap_lookup(id: Int32): ^heap_t; private;
begin
  var list_idx: UInt32 := (id mod 79);
  var heap: ^heap_t := atomic_load_ptr(@_memory_heaps[list_idx]);
  while (Boolean(heap) and Boolean(((heap)^.id ≠ id))) do
    heap := (heap)^.next_heap;
  exit heap;
end;

{$IF ENABLE_THREAD_CACHE}
method _memory_counter_increase(counter: ^span_counter_t; global_counter: ^UInt32; span_count: IntPtr); private;
begin
  if ((() -> begin
    var _tmp0 := (counter)^.current_allocations + 1;
    (counter)^.current_allocations := _tmp0;
    exit _tmp0;
  end)() > (counter)^.max_allocations) then begin
    (counter)^.max_allocations := (counter)^.current_allocations;
    var cache_limit_max: UInt32 := (UInt32(_memory_span_size) - 2); readonly;
    {$IF not ENABLE_UNLIMITED_CACHE}
    (counter)^.cache_limit := ((counter)^.max_allocations / (if (span_count = 1) then (MAX_SPAN_CACHE_DIVISOR) else (MAX_LARGE_SPAN_CACHE_DIVISOR)));
    var cache_limit_min: UInt32 := (if (span_count = 1) then ((MIN_SPAN_CACHE_RELEASE + MIN_SPAN_CACHE_SIZE)) else ((MIN_LARGE_SPAN_CACHE_RELEASE + MIN_LARGE_SPAN_CACHE_SIZE))); readonly;
    if ((counter)^.cache_limit < cache_limit_min) then begin
      (counter)^.cache_limit := cache_limit_min;
    end;
    if ((counter)^.cache_limit > cache_limit_max) then begin
      (counter)^.cache_limit := cache_limit_max;
    end;
    {$ELSE}
    (counter)^.cache_limit := cache_limit_max;
    {$ENDIF}
    if ((counter)^.max_allocations > (global_counter)^) then begin
      (global_counter)^ := (counter)^.max_allocations;
    end;
  end;
end;
{$ENDIF}

// ! Map more virtual memory
method _memory_map(size: IntPtr; offset: ^IntPtr): ^Void; private;
begin



  exit _memory_config.memory_map(size, offset);
end;

// ! Unmap virtual memory
method _memory_unmap(address: ^Void; size: IntPtr; offset: IntPtr; release: Int32); private;
begin




  _memory_config.memory_unmap(address, size, offset, release);
end;

// ! Make flags field in a span from flags, remainder/distance and count
// ! Check if span has any of the given flags
// ! Get the distance from flags field
// ! Get the remainder from flags field
// ! Get the count from flags field
// ! Set the remainder in the flags field (MUST be done from the owner heap thread)
// ! Resize the given super span to the given count of spans, store the remainder in the heap reserved spans fields
method _memory_set_span_remainder_as_reserved(heap: ^heap_t; span: ^span_t; use_count: IntPtr); private;
begin
  var current_count: IntPtr := (1 + (((span)^.flags shr 9) and 127));





  (heap)^.span_reserve := ^Void((^AnsiChar(span) + IntPtr((use_count * _memory_span_size))));
  (heap)^.spans_reserved := (current_count - use_count);
  if not Boolean(((span)^.flags and (1 or 2))) then begin
    // We must store the heap id before setting as master, to force unmaps to defer to this heap thread
    atomic_store32(@(span)^.heap_id, (heap)^.id);

    (heap)^.span_reserve_master := span;
    (span)^.flags := UInt16(((1 or (UInt16((current_count - 1)) shl 2)) or (UInt16((use_count - 1)) shl 9)));




  end
  else begin
    if ((span)^.flags and 1) then begin
      // Only owner heap thread can modify a master span

      var remains: UInt16 := (1 + (((span)^.flags shr 2) and 127));

      (heap)^.span_reserve_master := span;
      (span)^.flags := UInt16(((1 or (UInt16((remains - 1)) shl 2)) or (UInt16((use_count - 1)) shl 9)));



    end
    else begin
      // SPAN_FLAG_SUBSPAN
      // Resizing a subspan is a safe operation in any thread
      var distance: UInt16 := (1 + (((span)^.flags shr 2) and 127));
      var master: ^span_t := ^Void((^AnsiChar(span) + IntPtr((-Int32(distance) * Int32(_memory_span_size)))));
      (heap)^.span_reserve_master := master;


      (span)^.flags := UInt16(((2 or (UInt16((distance - 1)) shl 2)) or (UInt16((use_count - 1)) shl 9)));



    end;
  end;

end;

// ! Map in memory pages for the given number of spans (or use previously reserved pages)
method _memory_map_spans(heap: ^heap_t; span_count: IntPtr): ^span_t; private;
begin
  if (span_count ≤ (heap)^.spans_reserved) then begin
    var span: ^span_t := (heap)^.span_reserve;
    (heap)^.span_reserve := ^Void((^AnsiChar(span) + IntPtr((span_count * _memory_span_size))));
    (() -> begin
      var _tmp0 := (heap)^.spans_reserved - span_count;
      (heap)^.spans_reserved := _tmp0;
      exit _tmp0;
    end)();
    // Declare the span to be a subspan with given distance from master span
    var distance: UInt16 := UInt16((UIntPtr(IntPtr((^AnsiChar(span) - ^AnsiChar((heap)^.span_reserve_master)))) shr _memory_span_size_shift));
    (span)^.flags := UInt16(((2 or (UInt16((distance - 1)) shl 2)) or (UInt16((span_count - 1)) shl 9)));



    (span)^.data.block.align_offset := 0;
    exit span;
  end;
  // We cannot request extra spans if we already have some (but not enough) pending reserved spans
  var request_spans: IntPtr := (if (Boolean((heap)^.spans_reserved) or Boolean((span_count > _memory_config.span_map_count))) then (span_count) else (_memory_config.span_map_count));
  var align_offset: IntPtr := 0;
  var span: ^span_t := _memory_map((request_spans * _memory_span_size), @align_offset);
  (span)^.flags := UInt16(((0 or (UInt16((request_spans - 1)) shl 2)) or (UInt16((request_spans - 1)) shl 9)));



  (span)^.data.block.align_offset := UInt16(align_offset);
  if (request_spans > span_count) then begin
    // We have extra spans, store them as reserved spans in heap
    _memory_set_span_remainder_as_reserved(heap, span, span_count);
  end;
  exit span;
end;

// ! Defer unmapping of the given span to the owner heap
method _memory_unmap_defer(heap_id: Int32; span: ^span_t): Int32; private;
begin
  // Get the heap and link in pointer in list of deferred operations
  var heap: ^heap_t := _memory_heap_lookup(heap_id);
  if not Boolean(heap) then begin
    exit 0;
  end;
  atomic_store32(@(span)^.heap_id, heap_id);
  var last_ptr: ^Void;
  repeat
    last_ptr := atomic_load_ptr(@(heap)^.defer_unmap);
    (span)^.next_span := last_ptr;
  until Boolean(atomic_cas_ptr(@(heap)^.defer_unmap, span, last_ptr));
  exit 1;
end;

// ! Unmap memory pages for the given number of spans (or mark as unused if no partial unmappings)
method _memory_unmap_span(heap: ^heap_t; span: ^span_t); private;
begin
  var span_count: IntPtr := (1 + (((span)^.flags shr 9) and 127));

  // A plain run of spans can be unmapped directly
  if not Boolean(((span)^.flags and (1 or 2))) then begin
    _memory_unmap(span, (span_count * _memory_span_size), (span)^.data.list.align_offset, 1);
    exit;
  end;
  var is_master: UInt32 := ((span)^.flags and 1);
  var master: ^span_t := (if is_master then (span) else (^Void((^AnsiChar(span) + IntPtr((-Int32((1 + (((span)^.flags shr 2) and 127))) * Int32(_memory_span_size)))))));


  // Check if we own the master span, otherwise defer (only owner of master span can modify remainder field)
  var master_heap_id: Int32 := atomic_load32(@(master)^.heap_id);
  if (Boolean(heap) and Boolean((master_heap_id ≠ (heap)^.id))) then begin
    if _memory_unmap_defer(master_heap_id, span) then begin
      exit;
    end;
  end;
  if not Boolean(is_master) then begin
    // Directly unmap subspans

    _memory_unmap(span, (span_count * _memory_span_size), 0, 0);

  end
  else begin
    // Special double flag to denote an unmapped master
    // It must be kept in memory since span header must be used
    (() -> begin
      var _tmp0 := (span)^.flags or (1 or 2);
      (span)^.flags := _tmp0;
      exit _tmp0;
    end)();
  end;
  // We are in owner thread of the master span
  var remains: UInt32 := (1 + (((master)^.flags shr 2) and 127));

  remains := (if (UInt32(span_count) ≥ remains) then (0) else ((remains - UInt32(span_count))));
  if not Boolean(remains) then begin
    // Everything unmapped, unmap the master span with release flag to unmap the entire range of the super span

    span_count := (1 + (((master)^.flags shr 9) and 127));
    _memory_unmap(master, (span_count * _memory_span_size), (master)^.data.list.align_offset, 1);

  end
  else begin
    // Set remaining spans
    (master)^.flags := UInt16((((master)^.flags and 65027) or (UInt16((remains - 1)) shl 2)));

  end;
end;

// ! Process pending deferred cross-thread unmaps
method _memory_unmap_deferred(heap: ^heap_t; wanted_count: IntPtr): ^span_t; private;
begin
  // Grab the current list of deferred unmaps

  var span: ^span_t := atomic_load_ptr(@(heap)^.defer_unmap);
  if (Boolean(not Boolean(span)) or Boolean(not Boolean(atomic_cas_ptr(@(heap)^.defer_unmap, 0, span)))) then begin
    exit 0;
  end;
  var found_span: ^span_t := 0;
  repeat
    // Verify that we own the master span, otherwise re-defer to owner
    var next: ^Void := (span)^.next_span;
    if (Boolean(not Boolean(found_span)) and Boolean(((1 + (((span)^.flags shr 9) and 127)) = wanted_count))) then begin

      found_span := span;
    end
    else begin
      var is_master: UInt32 := ((span)^.flags and 1);
      var master: ^span_t := (if is_master then (span) else (^Void((^AnsiChar(span) + IntPtr((-Int32((1 + (((span)^.flags shr 2) and 127))) * Int32(_memory_span_size)))))));
      var master_heap_id: Int32 := atomic_load32(@(master)^.heap_id);
      if (Boolean((atomic_load32(@(span)^.heap_id) = master_heap_id)) or Boolean(not Boolean(_memory_unmap_defer(master_heap_id, span)))) then begin
        // We own the master span (or heap merged and abandoned)
        _memory_unmap_span(heap, span);
      end;
    end;
    span := next;
  until not span;
  exit found_span;
end;

// ! Unmap a single linked list of spans
method _memory_unmap_span_list(heap: ^heap_t; span: ^span_t); private;
begin
  var list_size: IntPtr := (span)^.data.list.size;
  begin
    // for loop: initializer
    var ispan: IntPtr := 0;
    // for loop: compare
    _looplabel0:;
    if (ispan < list_size) then begin

    end
    else begin
      goto _breaklabel0;
    end;
    // for loop: body
    begin
      var next_span: ^span_t := (span)^.next_span;
      _memory_unmap_span(heap, span);
      span := next_span;
    end;
    _continuelabel0:;
    // for loop: increment/continue
    ispan := ispan + 1;
    goto _looplabel0;
    // for loop: break
    _breaklabel0:;
  end;

end;

{$IF ENABLE_THREAD_CACHE}
method _memory_span_split(heap: ^heap_t; span: ^span_t; use_count: IntPtr): ^span_t; private;
begin
  var distance: UInt16 := 0;
  var current_count: IntPtr := (1 + (((span)^.flags shr 9) and 127));


  if not Boolean(((span)^.flags and (1 or 2))) then begin
    // Must store heap in master span before use, to avoid issues when unmapping subspans
    atomic_store32(@(span)^.heap_id, (heap)^.id);

    (span)^.flags := UInt16(((1 or (UInt16((current_count - 1)) shl 2)) or (UInt16((use_count - 1)) shl 9)));




  end
  else begin
    if ((span)^.flags and 1) then begin
      // Only valid to call on master span if we own it

      var remains: UInt16 := (1 + (((span)^.flags shr 2) and 127));

      (span)^.flags := UInt16(((1 or (UInt16((remains - 1)) shl 2)) or (UInt16((use_count - 1)) shl 9)));



    end
    else begin
      // SPAN_FLAG_SUBSPAN
      distance := (1 + (((span)^.flags shr 2) and 127));
      (span)^.flags := UInt16(((2 or (UInt16((distance - 1)) shl 2)) or (UInt16((use_count - 1)) shl 9)));



    end;
  end;
  // Setup remainder as a subspan
  var subspan: ^span_t := ^Void((^AnsiChar(span) + IntPtr((use_count * _memory_span_size))));
  (subspan)^.flags := UInt16(((2 or (UInt16(((distance + use_count) - 1)) shl 2)) or (UInt16(((current_count - use_count) - 1)) shl 9)));



  (subspan)^.data.list.align_offset := 0;
  exit subspan;
end;
{$ENDIF}

{$IF ENABLE_THREAD_CACHE}
// ! Add span to head of single linked span list
method _memory_span_list_push(head: ^^span_t; span: ^span_t): IntPtr; private;
begin
  (span)^.next_span := (head)^;
  if (head)^ then begin
    (span)^.data.list.size := (((head)^)^.data.list.size + 1);
  end
  else begin
    (span)^.data.list.size := 1;
  end;
  (head)^ := span;
  exit (span)^.data.list.size;
end;
{$ENDIF}

{$IF ENABLE_THREAD_CACHE}
// ! Remove span from head of single linked span list, returns the new list head
method _memory_span_list_pop(head: ^^span_t): ^span_t; private;
begin
  var span: ^span_t := (head)^;
  var next_span: ^span_t := 0;
  if ((span)^.data.list.size > 1) then begin
    next_span := (span)^.next_span;

    (next_span)^.data.list.size := ((span)^.data.list.size - 1);
  end;
  (head)^ := next_span;
  exit span;
end;
{$ENDIF}

{$IF ENABLE_THREAD_CACHE}
// ! Split a single linked span list
method _memory_span_list_split(span: ^span_t; limit: IntPtr): ^span_t; private;
begin
  var next: ^span_t := 0;
  if (limit < 2) then begin
    limit := 2;
  end;
  if ((span)^.data.list.size > limit) then begin
    var list_size: count_t := 1;
    var last: ^span_t := span;
    next := (span)^.next_span;
    while (list_size < limit) do begin
      last := next;
      next := (next)^.next_span;
      list_size := list_size + 1;
    end;
    (last)^.next_span := 0;

    (next)^.data.list.size := ((span)^.data.list.size - list_size);
    (span)^.data.list.size := list_size;
    (span)^.prev_span := 0;
  end;
  exit next;
end;
{$ENDIF}

// ! Add a span to a double linked list
method _memory_span_list_doublelink_add(head: ^^span_t; span: ^span_t); private;
begin
  if (head)^ then begin
    ((head)^)^.prev_span := span;
    (span)^.next_span := (head)^;
  end
  else begin
    (span)^.next_span := 0;
  end;
  (head)^ := span;
end;

// ! Remove a span from a double linked list
method _memory_span_list_doublelink_remove(head: ^^span_t; span: ^span_t); private;
begin
  if ((head)^ = span) then begin
    (head)^ := (span)^.next_span;
  end
  else begin
    var next_span: ^span_t := (span)^.next_span;
    var prev_span: ^span_t := (span)^.prev_span;
    if next_span then begin
      (next_span)^.prev_span := prev_span;
    end;
    (prev_span)^.next_span := next_span;
  end;
end;

// ! Insert a single span into thread heap cache, releasing to global cache if overflow
method _memory_heap_cache_insert(heap: ^heap_t; span: ^span_t); private;
begin
  {$IF ENABLE_THREAD_CACHE}
  var span_count: IntPtr := (1 + (((span)^.flags shr 9) and 127));
  var idx: IntPtr := (span_count - 1);
  if (_memory_span_list_push(@(heap)^.span_cache[idx], span) ≤ (heap)^.span_counter[idx].cache_limit) then begin
    exit;
  end;
  (heap)^.span_cache[idx] := _memory_span_list_split(span, (heap)^.span_counter[idx].cache_limit);

  {$IF ENABLE_STATISTICS}
  (() -> begin
    var _tmp0 := (heap)^.thread_to_global + ((IntPtr((span)^.data.list.size) * span_count) * _memory_span_size);
    (heap)^.thread_to_global := _tmp0;
    exit _tmp0;
  end)();
  {$ENDIF}
  _memory_unmap_span_list(heap, span);
  {$ELSE}
  _memory_unmap_span(heap, span);
  {$ENDIF}
end;

// ! Extract the given number of spans from the different cache levels
method _memory_heap_cache_extract(heap: ^heap_t; span_count: IntPtr): ^span_t; private;
begin
  {$IF ENABLE_THREAD_CACHE}
  var idx: IntPtr := (span_count - 1);
  // Step 1: check thread cache
  if (heap)^.span_cache[idx] then begin
    exit _memory_span_list_pop(@(heap)^.span_cache[idx]);
  end;
  {$ENDIF}
  // Step 2: Check reserved spans
  if ((heap)^.spans_reserved ≥ span_count) then begin
    exit _memory_map_spans(heap, span_count);
  end;
  // Step 3: Try processing deferred unmappings
  var span: ^span_t := _memory_unmap_deferred(heap, span_count);
  if span then begin
    exit span;
  end;
  {$IF ENABLE_THREAD_CACHE}
  begin
    // for loop: initializer
    idx := idx + 1;
    // for loop: compare
    _looplabel0:;
    if (idx < 32) then begin

    end
    else begin
      goto _breaklabel0;
    end;
    // for loop: body
    begin
      if (heap)^.span_cache[idx] then begin
        span := _memory_span_list_pop(@(heap)^.span_cache[idx]);
        _breaklabel0:;
      end;
    end;
    _continuelabel0:;
    // for loop: increment/continue
    idx := idx + 1;
    goto _looplabel0;
    // for loop: break
    _breaklabel0:;
  end;
  if span then begin
    // Mark the span as owned by this heap before splitting
    var got_count: IntPtr := (1 + (((span)^.flags shr 9) and 127));

    atomic_store32(@(span)^.heap_id, (heap)^.id);

    // Split the span and store as reserved if no previously reserved spans, or in thread cache otherwise
    var subspan: ^span_t := _memory_span_split(heap, span, span_count);


    if not Boolean((heap)^.spans_reserved) then begin
      (heap)^.spans_reserved := (got_count - span_count);
      (heap)^.span_reserve := subspan;
      (heap)^.span_reserve_master := ^Void((^AnsiChar(subspan) + IntPtr((-Int32((1 + (((subspan)^.flags shr 2) and 127))) * Int32(_memory_span_size)))));
    end
    else begin
      _memory_heap_cache_insert(heap, subspan);
    end;
    exit span;
  end;
  {$ENDIF}
  exit 0;
end;

// ! Allocate a small/medium sized memory block from the given heap
method _memory_allocate_from_heap(heap: ^heap_t; size: IntPtr): ^Void; private;
begin
  // Calculate the size class index and do a dependent lookup of the final class index (in case of merged classes)
  var base_idx: IntPtr := (if (size ≤ 2016) then (((size + (32 - 1)) shr 5)) else ((63 + (((size - 2016) + (512 - 1)) shr 9)))); readonly;

  var class_idx: IntPtr := _memory_size_class[(if base_idx then ((base_idx - 1)) else (0))].class_idx; readonly;
  var active_block: ^span_block_t := ((heap)^.active_block + class_idx);
  var size_class: ^size_class_t := (_memory_size_class + class_idx);
  var class_size: count_t := (size_class)^.size; readonly;
  use_active:;
  if (active_block)^.free_count then begin
    // Happy path, we have a span with at least one free block
    var span: ^span_t := (heap)^.active_span[class_idx];
    var offset: count_t := (class_size * (active_block)^.free_list);
    var &block: ^UInt32 := ^Void((^AnsiChar(span) + IntPtr((32 + offset))));

    (active_block)^.free_count := (active_block)^.free_count - 1;
    if not Boolean((active_block)^.free_count) then begin
      // Span is now completely allocated, set the bookkeeping data in the
      // span itself and reset the active span pointer in the heap
      (span)^.data.block.free_count := 0;
      (span)^.data.block.first_autolink := UInt16((size_class)^.block_count);
      (heap)^.active_span[class_idx] := 0;
    end
    else begin
      // Get the next free block, either from linked list or from auto link
      if ((active_block)^.free_list < (active_block)^.first_autolink) then begin
        (active_block)^.free_list := UInt16((&block)^);
      end
      else begin
        (active_block)^.free_list := (active_block)^.free_list + 1;
        (active_block)^.first_autolink := (active_block)^.first_autolink + 1;
      end;

    end;
    exit &block;
  end;
  // Step 2: No active span, try executing deferred deallocations and try again if there
  //         was at least one of the requested size class
  if _memory_deallocate_deferred(heap, class_idx) then begin
    if (active_block)^.free_count then begin
      goto use_active;
    end;

  end;
  // Step 3: Check if there is a semi-used span of the requested size class available
  if (heap)^.size_cache[class_idx] then begin
    // Promote a pending semi-used span to be active, storing bookkeeping data in
    // the heap structure for faster access
    var span: ^span_t := (heap)^.size_cache[class_idx];
    (active_block)^ := (span)^.data.block;

    (heap)^.size_cache[class_idx] := (span)^.next_span;
    (heap)^.active_span[class_idx] := span;
    // Mark span as owned by this heap
    atomic_store32(@(span)^.heap_id, (heap)^.id);

    goto use_active;

  end;
  // Step 4: Find a span in one of the cache levels
  var span: ^span_t := _memory_heap_cache_extract(heap, 1);
  if not Boolean(span) then begin
    // Step 5: Map in more virtual memory
    span := _memory_map_spans(heap, 1);
  end;
  // Mark span as owned by this heap and set base data

  (span)^.size_class := UInt16(class_idx);
  atomic_store32(@(span)^.heap_id, (heap)^.id);

  // If we only have one block we will grab it, otherwise
  // set span as new span to use for next allocation
  if ((size_class)^.block_count > 1) then begin
    // Reset block order to sequential auto linked order
    (active_block)^.free_count := UInt16(((size_class)^.block_count - 1));
    (active_block)^.free_list := 1;
    (active_block)^.first_autolink := 1;
    (heap)^.active_span[class_idx] := span;
  end
  else begin
    (span)^.data.block.free_count := 0;
    (span)^.data.block.first_autolink := UInt16((size_class)^.block_count);
  end;
  // Track counters

  // Return first block if memory page span
  exit ^Void((^AnsiChar(span) + IntPtr(32)));
end;

// ! Allocate a large sized memory block from the given heap
method _memory_allocate_large_from_heap(heap: ^heap_t; size: IntPtr): ^Void; private;
begin
  // Calculate number of needed max sized spans (including header)
  // Since this function is never called if size > LARGE_SIZE_LIMIT
  // the span_count is guaranteed to be <= LARGE_CLASS_COUNT
  (() -> begin
    var _tmp0 := size + 32;
    size := _tmp0;
    exit _tmp0;
  end)();
  var span_count: IntPtr := (size shr _memory_span_size_shift);
  if (size and (_memory_span_size - 1)) then begin
    span_count := span_count + 1;
  end;
  var idx: IntPtr := (span_count - 1);
  {$IF ENABLE_THREAD_CACHE}
  if not Boolean((heap)^.span_cache[idx]) then begin
    _memory_deallocate_deferred(heap, ((63 + 60) + idx));
  end;
  {$ELSE}
  _memory_deallocate_deferred(heap, ((63 + 60) + idx));
  {$ENDIF}
  // Step 1: Find span in one of the cache levels
  var span: ^span_t := _memory_heap_cache_extract(heap, span_count);
  if not Boolean(span) then begin
    // Step 2: Map in more virtual memory
    span := _memory_map_spans(heap, span_count);
  end;
  // Mark span as owned by this heap and set base data

  (span)^.size_class := UInt16(((63 + 60) + idx));
  atomic_store32(@(span)^.heap_id, (heap)^.id);

  // Increase counter

  exit ^Void((^AnsiChar(span) + IntPtr(32)));
end;

// ! Allocate a new heap
method _memory_allocate_heap: ^heap_t; private;
begin
  var raw_heap: ^Void;
  var next_raw_heap: ^Void;
  var orphan_counter: UIntPtr;
  var heap: ^heap_t;
  var next_heap: ^heap_t;
  // Try getting an orphaned heap

  repeat
    raw_heap := atomic_load_ptr(@_memory_orphan_heaps);
    heap := ^Void((UIntPtr(raw_heap) and _memory_page_mask));
    if not Boolean(heap) then begin
      break;
    end;
    next_heap := (heap)^.next_orphan;
    orphan_counter := UIntPtr(atomic_incr32(@_memory_orphan_counter));
    next_raw_heap := ^Void((UIntPtr(next_heap) or (orphan_counter and not _memory_page_mask)));
  until Boolean(atomic_cas_ptr(@_memory_orphan_heaps, next_raw_heap, raw_heap));
  if not Boolean(heap) then begin
    // Map in pages for a new heap
    var align_offset: IntPtr := 0;
    heap := _memory_map(((1 + (sizeOf(heap_t) shr _memory_page_size_shift)) * _memory_page_size), @align_offset);
    memset(heap, 0, sizeOf(heap_t));
    (heap)^.align_offset := align_offset;
    // Get a new heap ID
    repeat
      (heap)^.id := atomic_incr32(@_memory_heap_id);
      if _memory_heap_lookup((heap)^.id) then begin
        (heap)^.id := 0;
      end;
    until Boolean((heap)^.id);
    // Link in heap in heap ID map
    var list_idx: IntPtr := ((heap)^.id mod 79);
    repeat
      next_heap := atomic_load_ptr(@_memory_heaps[list_idx]);
      (heap)^.next_heap := next_heap;
    until Boolean(atomic_cas_ptr(@_memory_heaps[list_idx], heap, next_heap));
  end;
  {$IF ENABLE_THREAD_CACHE}
  (heap)^.span_counter[0].cache_limit := (MIN_SPAN_CACHE_RELEASE + MIN_SPAN_CACHE_SIZE);
  begin
    // for loop: initializer
    var idx: IntPtr := 1;
    // for loop: compare
    _looplabel0:;
    if (idx < 32) then begin

    end
    else begin
      goto _breaklabel0;
    end;
    // for loop: body
    (heap)^.span_counter[idx].cache_limit := (MIN_LARGE_SPAN_CACHE_RELEASE + MIN_LARGE_SPAN_CACHE_SIZE);
    _continuelabel0:;
    // for loop: increment/continue
    idx := idx + 1;
    goto _looplabel0;
    // for loop: break
    _breaklabel0:;
  end;
  {$ENDIF}
  // Clean up any deferred operations
  _memory_unmap_deferred(heap, 0);
  _memory_deallocate_deferred(heap, 0);
  exit heap;
end;

// ! Deallocate the given small/medium memory block from the given heap
method _memory_deallocate_to_heap(heap: ^heap_t; span: ^span_t; p: ^Void); private;
begin
  // Check if span is the currently active span in order to operate
  // on the correct bookkeeping data

  var class_idx: count_t := (span)^.size_class; readonly;
  var size_class: ^size_class_t := (_memory_size_class + class_idx);
  var is_active: Int32 := ((heap)^.active_span[class_idx] = span);
  var block_data: ^span_block_t := (if is_active then (((heap)^.active_block + class_idx)) else (@(span)^.data.block));
  // Check if the span will become completely free
  if ((block_data)^.free_count = (count_t((size_class)^.block_count) - 1)) then begin
    {$IF ENABLE_THREAD_CACHE}

    if (heap)^.span_counter[0].current_allocations then begin
      (heap)^.span_counter[0].current_allocations := (heap)^.span_counter[0].current_allocations - 1;
    end;
    {$ENDIF}
    // If it was active, reset counter. Otherwise, if not active, remove from
    // partial free list if we had a previous free block (guard for classes with only 1 block)
    if is_active then begin
      (block_data)^.free_count := 0;
    end
    else begin
      if ((block_data)^.free_count > 0) then begin
        _memory_span_list_doublelink_remove(@(heap)^.size_cache[class_idx], span);
      end;
    end;
    // Add to heap span cache
    _memory_heap_cache_insert(heap, span);
    exit;
  end;
  // Check if first free block for this span (previously fully allocated)
  if ((block_data)^.free_count = 0) then begin
    // add to free list and disable autolink
    _memory_span_list_doublelink_add(@(heap)^.size_cache[class_idx], span);
    (block_data)^.first_autolink := UInt16((size_class)^.block_count);
  end;
  (block_data)^.free_count := (block_data)^.free_count + 1;
  // Span is not yet completely free, so add block to the linked list of free blocks
  var blocks_start: ^Void := ^Void((^AnsiChar(span) + IntPtr(32)));
  var block_offset: count_t := count_t(IntPtr((^AnsiChar(p) - ^AnsiChar(blocks_start))));
  var block_idx: count_t := (block_offset / count_t((size_class)^.size));
  var &block: ^UInt32 := ^Void((^AnsiChar(blocks_start) + IntPtr((block_idx * (size_class)^.size))));
  (&block)^ := (block_data)^.free_list;
  (block_data)^.free_list := UInt16(block_idx);
end;

// ! Deallocate the given large memory block from the given heap
method _memory_deallocate_large_to_heap(heap: ^heap_t; span: ^span_t); private;
begin
  // Decrease counter
  var idx: IntPtr := (IntPtr((span)^.size_class) - (63 + 60));
  var span_count: IntPtr := (idx + 1);



  {$IF ENABLE_THREAD_CACHE}

  if (heap)^.span_counter[idx].current_allocations then begin
    (heap)^.span_counter[idx].current_allocations := (heap)^.span_counter[idx].current_allocations - 1;
  end;
  {$ENDIF}
  if (Boolean(not Boolean((heap)^.spans_reserved)) and Boolean((span_count > 1))) then begin
    // Split the span and store remainder as reserved spans
    // Must split to a dummy 1-span master since we cannot have master spans as reserved
    _memory_set_span_remainder_as_reserved(heap, span, 1);
    span_count := 1;
  end;
  // Insert into cache list
  _memory_heap_cache_insert(heap, span);
end;

// ! Process pending deferred cross-thread deallocations
method _memory_deallocate_deferred(heap: ^heap_t; size_class: IntPtr): Int32; private;
begin
  // Grab the current list of deferred deallocations

  var p: ^Void := atomic_load_ptr(@(heap)^.defer_deallocate);
  if (Boolean(not Boolean(p)) or Boolean(not Boolean(atomic_cas_ptr(@(heap)^.defer_deallocate, 0, p)))) then begin
    exit 0;
  end;
  // Keep track if we deallocate in the given size class
  var got_class: Int32 := 0;
  repeat
    var next: ^Void := (^^Void(p))^;
    // Get span and check which type of block
    var span: ^span_t := ^Void((UIntPtr(p) and _memory_span_mask));
    if ((span)^.size_class < (63 + 60)) then begin
      // Small/medium block
      (() -> begin
        var _tmp0 := got_class or ((span)^.size_class = size_class);
        got_class := _tmp0;
        exit _tmp0;
      end)();
      _memory_deallocate_to_heap(heap, span, p);
    end
    else begin
      // Large block
      (() -> begin
        var _tmp1 := got_class or (Boolean(((span)^.size_class ≥ size_class)) and Boolean(((span)^.size_class ≤ (size_class + 2))));
        got_class := _tmp1;
        exit _tmp1;
      end)();
      _memory_deallocate_large_to_heap(heap, span);
    end;
    // Loop until all pending operations in list are processed
    p := next;
  until not p;
  exit got_class;
end;

// ! Defer deallocation of the given block to the given heap
method _memory_deallocate_defer(heap_id: Int32; p: ^Void); private;
begin
  // Get the heap and link in pointer in list of deferred operations
  var heap: ^heap_t := _memory_heap_lookup(heap_id);
  if not Boolean(heap) then begin
    exit;
  end;
  var last_ptr: ^Void;
  repeat
    last_ptr := atomic_load_ptr(@(heap)^.defer_deallocate);
    (^^Void(p))^ := last_ptr;
  until Boolean(atomic_cas_ptr(@(heap)^.defer_deallocate, p, last_ptr));
end;

// ! Allocate a block of the given size
method _memory_allocate(size: IntPtr): ^Void; private;
begin
  if (size ≤ _memory_medium_size_limit) then begin
    exit _memory_allocate_from_heap(get_thread_heap(), size);
  end
  else begin
    if (size ≤ ((32 * _memory_span_size) - 32)) then begin
      exit _memory_allocate_large_from_heap(get_thread_heap(), size);
    end;
  end;
  // Oversized, allocate pages directly
  (() -> begin
    var _tmp0 := size + 32;
    size := _tmp0;
    exit _tmp0;
  end)();
  var num_pages: IntPtr := (size shr _memory_page_size_shift);
  if (size and (_memory_page_size - 1)) then begin
    num_pages := num_pages + 1;
  end;
  var align_offset: IntPtr := 0;
  var span: ^span_t := _memory_map((num_pages * _memory_page_size), @align_offset);
  atomic_store32(@(span)^.heap_id, 0);
  // Store page count in next_span
  (span)^.next_span := ^span_t(UIntPtr(num_pages));
  (span)^.data.list.align_offset := UInt16(align_offset);
  exit ^Void((^AnsiChar(span) + IntPtr(32)));
end;

// ! Deallocate the given block
method _memory_deallocate(p: ^Void); private;
begin
  if not Boolean(p) then begin
    exit;
  end;
  // Grab the span (always at start of span, using 64KiB alignment)
  var span: ^span_t := ^Void((UIntPtr(p) and _memory_span_mask));
  var heap_id: Int32 := atomic_load32(@(span)^.heap_id);
  var heap: ^heap_t := get_thread_heap();
  // Check if block belongs to this heap or if deallocation should be deferred
  if (heap_id = (heap)^.id) then begin
    if ((span)^.size_class < (63 + 60)) then begin
      _memory_deallocate_to_heap(heap, span, p);
    end
    else begin
      _memory_deallocate_large_to_heap(heap, span);
    end;
  end
  else begin
    if (heap_id > 0) then begin
      _memory_deallocate_defer(heap_id, p);
    end
    else begin
      // Oversized allocation, page count is stored in next_span
      var num_pages: IntPtr := IntPtr((span)^.next_span);
      _memory_unmap(span, (num_pages * _memory_page_size), (span)^.data.list.align_offset, 1);
    end;
  end;
end;

// ! Reallocate the given block to the given size
method _memory_reallocate(p: ^Void; size: IntPtr; oldsize: IntPtr; &flags: UInt32): ^Void; private;
begin
  if p then begin
    // Grab the span using guaranteed span alignment
    var span: ^span_t := ^Void((UIntPtr(p) and _memory_span_mask));
    var heap_id: Int32 := atomic_load32(@(span)^.heap_id);
    if heap_id then begin
      if ((span)^.size_class < (63 + 60)) then begin
        // Small/medium sized block
        var size_class: ^size_class_t := (_memory_size_class + (span)^.size_class);
        if (IntPtr((size_class)^.size) ≥ size) then begin
          exit p;
        end;
        // Still fits in block, never mind trying to save memory
        if not Boolean(oldsize) then begin
          oldsize := (size_class)^.size;
        end;
      end
      else begin
        // Large block
        var total_size: IntPtr := (size + 32);
        var num_spans: IntPtr := (total_size shr _memory_span_size_shift);
        if (total_size and (_memory_span_mask - 1)) then begin
          num_spans := num_spans + 1;
        end;
        var current_spans: IntPtr := (((span)^.size_class - (63 + 60)) + 1);
        if (Boolean((current_spans ≥ num_spans)) and Boolean((num_spans ≥ (current_spans / 2)))) then begin
          exit p;
        end;
        // Still fits and less than half of memory would be freed
        if not Boolean(oldsize) then begin
          oldsize := ((current_spans * _memory_span_size) - 32);
        end;
      end;
    end
    else begin
      // Oversized block
      var total_size: IntPtr := (size + 32);
      var num_pages: IntPtr := (total_size shr _memory_page_size_shift);
      if (total_size and (_memory_page_size - 1)) then begin
        num_pages := num_pages + 1;
      end;
      // Page count is stored in next_span
      var current_pages: IntPtr := IntPtr((span)^.next_span);
      if (Boolean((current_pages ≥ num_pages)) and Boolean((num_pages ≥ (current_pages / 2)))) then begin
        exit p;
      end;
      // Still fits and less than half of memory would be freed
      if not Boolean(oldsize) then begin
        oldsize := ((current_pages * _memory_page_size) - 32);
      end;
    end;
  end;
  // Size is greater than block size, need to allocate a new block and deallocate the old
  // Avoid hysteresis by overallocating if increase is small (below 37%)
  var lower_bound: IntPtr := ((oldsize + (oldsize shr 2)) + (oldsize shr 3));
  var &block: ^Void := _memory_allocate((if (size > lower_bound) then (size) else ((if (size > oldsize) then (lower_bound) else (size)))));
  if p then begin
    if not Boolean((&flags and 1)) then begin
      memcpy(&block, p, (if (oldsize < size) then (oldsize) else (size)));
    end;
    _memory_deallocate(p);
  end;
  exit &block;
end;

// ! Get the usable size of the given block
method _memory_usable_size(p: ^Void): IntPtr; private;
begin
  // Grab the span using guaranteed span alignment
  var span: ^span_t := ^Void((UIntPtr(p) and _memory_span_mask));
  var heap_id: Int32 := atomic_load32(@(span)^.heap_id);
  if heap_id then begin
    // Small/medium block
    if ((span)^.size_class < (63 + 60)) then begin
      exit _memory_size_class[(span)^.size_class].size;
    end;
    // Large block
    var current_spans: IntPtr := (((span)^.size_class - (63 + 60)) + 1);
    exit ((current_spans * _memory_span_size) - 32);
  end;
  // Oversized block, page count is stored in next_span
  var current_pages: IntPtr := IntPtr((span)^.next_span);
  exit ((current_pages * _memory_page_size) - 32);
end;

// ! Adjust and optimize the size class properties for the given class
method _memory_adjust_size_class(iclass: IntPtr); private;
begin
  var block_size: IntPtr := _memory_size_class[iclass].size;
  var block_count: IntPtr := ((_memory_span_size - 32) / block_size);
  _memory_size_class[iclass].block_count := UInt16(block_count);
  _memory_size_class[iclass].class_idx := UInt16(iclass);
  // Check if previous size classes can be merged
  var prevclass: IntPtr := iclass;
  while (prevclass > 0) do begin
    prevclass := prevclass - 1;
    // A class can be merged if number of pages and number of blocks are equal
    if (_memory_size_class[prevclass].block_count = _memory_size_class[iclass].block_count) then begin
      memcpy((_memory_size_class + prevclass), (_memory_size_class + iclass), sizeOf(_memory_size_class[iclass]));
    end
    else begin
      break;
    end;
  end;
end;

// ! Initialize the allocator and setup global data
method rpmalloc_initialize: Int32; public;
begin
  memset(@_memory_config, 0, sizeOf(rpmalloc_config_t));
  exit rpmalloc_initialize_config(0);
end;

method rpmalloc_initialize_config(config: ^rpmalloc_config_t): Int32; public;
begin
  if config then begin
    memcpy(@_memory_config, config, sizeOf(rpmalloc_config_t));
  end;
  var default_mapper: Int32 := 0;
  if (Boolean(not Boolean(_memory_config.memory_map)) or Boolean(not Boolean(_memory_config.memory_unmap))) then begin
    default_mapper := 1;
    _memory_config.memory_map := _memory_map_os;
    _memory_config.memory_unmap := _memory_unmap_os;
  end;
  _memory_page_size := _memory_config.page_size;
  if not Boolean(_memory_page_size) then begin
    {$IF PLATFORM_WINDOWS}
    var system_info: SYSTEM_INFO;
    memset(@system_info, 0, sizeOf(system_info));
    GetSystemInfo(@system_info);
    _memory_page_size := system_info.dwPageSize;
    _memory_map_granularity := system_info.dwAllocationGranularity;
    {$ELSE}
    _memory_page_size := IntPtr(sysconf(_SC_PAGESIZE));
    _memory_map_granularity := _memory_page_size;
    {$ENDIF}
  end;
  if (_memory_page_size < 512) then begin
    _memory_page_size := 512;
  end;
  if (_memory_page_size > (64 * 1024)) then begin
    _memory_page_size := (64 * 1024);
  end;
  _memory_page_size_shift := 0;
  var page_size_bit: IntPtr := _memory_page_size;
  while (page_size_bit ≠ 1) do begin
    _memory_page_size_shift := _memory_page_size_shift + 1;
    (() -> begin
      var _tmp0 := page_size_bit shr 1;
      page_size_bit := _tmp0;
      exit _tmp0;
    end)();
  end;
  _memory_page_size := (IntPtr(1) shl _memory_page_size_shift);
  _memory_page_mask := not UIntPtr((_memory_page_size - 1));
  var span_size: IntPtr := _memory_config.span_size;
  if not Boolean(span_size) then begin
    span_size := (64 * 1024);
  end;
  if (span_size > (256 * 1024)) then begin
    span_size := (256 * 1024);
  end;
  _memory_span_size := 4096;
  _memory_span_size_shift := 12;
  while (Boolean((_memory_span_size < span_size)) or Boolean((_memory_span_size < _memory_page_size))) do begin
    (() -> begin
      var _tmp1 := _memory_span_size shl 1;
      _memory_span_size := _tmp1;
      exit _tmp1;
    end)();
    _memory_span_size_shift := _memory_span_size_shift + 1;
  end;
  _memory_span_mask := not UIntPtr((_memory_span_size - 1));
  _memory_config.page_size := _memory_page_size;
  _memory_config.span_size := _memory_span_size;
  if not Boolean(_memory_config.span_map_count) then begin
    _memory_config.span_map_count := DEFAULT_SPAN_MAP_COUNT;
  end;
  if ((_memory_config.span_size * _memory_config.span_map_count) < _memory_config.page_size) then begin
    _memory_config.span_map_count := (_memory_config.page_size / _memory_config.span_size);
  end;
  if (_memory_config.span_map_count > 128) then begin
    _memory_config.span_map_count := 128;
  end;
  atomic_store32(@_memory_heap_id, 0);
  atomic_store32(@_memory_orphan_counter, 0);
  atomic_store32(@_memory_active_heaps, 0);
  // Setup all small and medium size classes
  var iclass: IntPtr;
  begin
    // for loop: initializer
    iclass := 0;
    // for loop: compare
    _looplabel2:;
    if (iclass < 63) then begin

    end
    else begin
      goto _breaklabel2;
    end;
    // for loop: body
    begin
      var size: IntPtr := ((iclass + 1) * 32);
      _memory_size_class[iclass].size := UInt16(size);
      _memory_adjust_size_class(iclass);
    end;
    _continuelabel2:;
    // for loop: increment/continue
    iclass := iclass + 1;
    goto _looplabel2;
    // for loop: break
    _breaklabel2:;
  end;
  _memory_medium_size_limit := (_memory_span_size - 32);
  if (_memory_medium_size_limit > ((2016 + (512 * 60)) - 32)) then begin
    _memory_medium_size_limit := ((2016 + (512 * 60)) - 32);
  end;
  begin
    // for loop: initializer
    iclass := 0;
    // for loop: compare
    _looplabel3:;
    if (iclass < 60) then begin

    end
    else begin
      goto _breaklabel3;
    end;
    // for loop: body
    begin
      var size: IntPtr := (2016 + ((iclass + 1) * 512));
      if (size > _memory_medium_size_limit) then begin
        size := _memory_medium_size_limit;
      end;
      _memory_size_class[(63 + iclass)].size := UInt16(size);
      _memory_adjust_size_class((63 + iclass));
    end;
    _continuelabel3:;
    // for loop: increment/continue
    iclass := iclass + 1;
    goto _looplabel3;
    // for loop: break
    _breaklabel3:;
  end;
  // Initialize this thread
  rpmalloc_thread_initialize();
  exit 0;
end;

// ! Finalize the allocator
method rpmalloc_finalize; public;
begin

  rpmalloc_thread_finalize();
  // If you hit this assert, you still have active threads or forgot to finalize some thread(s)

  // Free all thread caches
  begin
    // for loop: initializer
    var list_idx: IntPtr := 0;
    // for loop: compare
    _looplabel0:;
    if (list_idx < 79) then begin

    end
    else begin
      goto _breaklabel0;
    end;
    // for loop: body
    begin
      var heap: ^heap_t := atomic_load_ptr(@_memory_heaps[list_idx]);
      while heap do begin
        _memory_deallocate_deferred(heap, 0);
        {$IF ENABLE_THREAD_CACHE}
        // Free span caches (other thread might have deferred after the thread using this heap finalized)
        begin
          // for loop: initializer
          var iclass: IntPtr := 0;
          // for loop: compare
          _looplabel1:;
          if (iclass < 32) then begin

          end
          else begin
            goto _breaklabel1;
          end;
          // for loop: body
          begin
            if (heap)^.span_cache[iclass] then begin
              _memory_unmap_span_list(0, (heap)^.span_cache[iclass]);
            end;
          end;
          _continuelabel1:;
          // for loop: increment/continue
          iclass := iclass + 1;
          goto _looplabel1;
          // for loop: break
          _breaklabel1:;
        end;
        {$ENDIF}
        heap := (heap)^.next_heap;
      end;
    end;
    _continuelabel0:;
    // for loop: increment/continue
    list_idx := list_idx + 1;
    goto _looplabel0;
    // for loop: break
    _breaklabel0:;
  end;
  begin
    // for loop: initializer
    var list_idx: IntPtr := 0;
    // for loop: compare
    _looplabel2:;
    if (list_idx < 79) then begin

    end
    else begin
      goto _breaklabel2;
    end;
    // for loop: body
    begin
      var heap: ^heap_t := atomic_load_ptr(@_memory_heaps[list_idx]);
      atomic_store_ptr(@_memory_heaps[list_idx], 0);
      while heap do begin
        if (heap)^.spans_reserved then begin
          var span: ^span_t := (heap)^.span_reserve;
          var master: ^span_t := (heap)^.span_reserve_master;
          var remains: UInt32 := (1 + (((master)^.flags shr 2) and 127));


          _memory_unmap(span, ((heap)^.spans_reserved * _memory_span_size), 0, 0);

          remains := (if (UInt32((heap)^.spans_reserved) ≥ remains) then (0) else ((remains - UInt32((heap)^.spans_reserved))));
          if not Boolean(remains) then begin
            var master_span_count: UInt32 := (1 + (((master)^.flags shr 9) and 127));

            _memory_unmap(master, (master_span_count * _memory_span_size), (master)^.data.list.align_offset, 1);
          end
          else begin
            (master)^.flags := UInt16((((master)^.flags and 65027) or (UInt16((remains - 1)) shl 2)));

          end;
        end;
        _memory_unmap_deferred(heap, 0);
        var next_heap: ^heap_t := (heap)^.next_heap;
        _memory_unmap(heap, ((1 + (sizeOf(heap_t) shr _memory_page_size_shift)) * _memory_page_size), (heap)^.align_offset, 1);
        heap := next_heap;
      end;
    end;
    _continuelabel2:;
    // for loop: increment/continue
    list_idx := list_idx + 1;
    goto _looplabel2;
    // for loop: break
    _breaklabel2:;
  end;
  atomic_store_ptr(@_memory_orphan_heaps, 0);

  {$IF ENABLE_STATISTICS}


  {$ENDIF}
end;

// ! Initialize thread, assign heap
method rpmalloc_thread_initialize; public;
begin
  if not Boolean(get_thread_heap()) then begin
    atomic_incr32(@_memory_active_heaps);
    var heap: ^heap_t := _memory_allocate_heap();
    {$IF ENABLE_STATISTICS}
    (heap)^.thread_to_global := 0;
    (heap)^.global_to_thread := 0;
    {$ENDIF}
    set_thread_heap(heap);
  end;
end;

// ! Finalize thread, orphan heap
method rpmalloc_thread_finalize; public;
begin
  var heap: ^heap_t := get_thread_heap();
  if not Boolean(heap) then begin
    exit;
  end;
  _memory_deallocate_deferred(heap, 0);
  _memory_unmap_deferred(heap, 0);
  {$IF ENABLE_THREAD_CACHE}
  // Release thread cache spans back to global cache
  begin
    // for loop: initializer
    var iclass: IntPtr := 0;
    // for loop: compare
    _looplabel0:;
    if (iclass < 32) then begin

    end
    else begin
      goto _breaklabel0;
    end;
    // for loop: body
    begin
      var span: ^span_t := (heap)^.span_cache[iclass];
      if span then begin
        _memory_unmap_span_list(heap, span);
      end;
      (heap)^.span_cache[iclass] := 0;
    end;
    _continuelabel0:;
    // for loop: increment/continue
    iclass := iclass + 1;
    goto _looplabel0;
    // for loop: break
    _breaklabel0:;
  end;
  {$ENDIF}
  // Orphan the heap
  var raw_heap: ^Void;
  var orphan_counter: UIntPtr;
  var last_heap: ^heap_t;
  repeat
    last_heap := atomic_load_ptr(@_memory_orphan_heaps);
    (heap)^.next_orphan := ^Void((UIntPtr(last_heap) and _memory_page_mask));
    orphan_counter := UIntPtr(atomic_incr32(@_memory_orphan_counter));
    raw_heap := ^Void((UIntPtr(heap) or (orphan_counter and not _memory_page_mask)));
  until Boolean(atomic_cas_ptr(@_memory_orphan_heaps, raw_heap, last_heap));
  set_thread_heap(0);
  atomic_add32(@_memory_active_heaps, -1);
end;

method rpmalloc_is_thread_initialized: Int32; public;
begin
  exit (if (get_thread_heap() ≠ 0) then (1) else (0));
end;

method rpmalloc_config: ^rpmalloc_config_t; public;
begin
  exit @_memory_config;
end;

// ! Map new pages to virtual memory
method _memory_map_os(size: IntPtr; offset: ^IntPtr): ^Void; private;
begin
  // Either size is a heap (a single page) or a (multiple) span - we only need to align spans
  var padding: IntPtr := (if (Boolean((size ≥ _memory_span_size)) and Boolean((_memory_span_size > _memory_map_granularity))) then (_memory_span_size) else (0));
  {$IF PLATFORM_WINDOWS}
  var ptr: ^Void := VirtualAlloc(0, (size + padding), (MEM_RESERVE or MEM_COMMIT), PAGE_READWRITE);
  if not Boolean(ptr) then begin

    exit 0;
  end;
  {$ELSE}
  var ptr: ^Void := mmap(0, (size + padding), (PROT_READ or PROT_WRITE), ((MAP_PRIVATE or MAP_ANONYMOUS) or 0), -1, 0);
  if (Boolean((ptr = MAP_FAILED)) or Boolean(not Boolean(ptr))) then begin

    exit 0;
  end;
  {$ENDIF}
  if padding then begin
    var final_padding: IntPtr := (padding - (UIntPtr(ptr) and not _memory_span_mask));
    {$IF PLATFORM_POSIX}
    var remains: IntPtr := (padding - final_padding);
    if remains then begin
      munmap(^Void((^AnsiChar(ptr) + IntPtr((final_padding + size)))), remains);
    end;
    {$ENDIF}
    ptr := ^Void((^AnsiChar(ptr) + IntPtr(final_padding)));



    (offset)^ := (final_padding shr 3);

  end;
  exit ptr;
end;

// ! Unmap pages from virtual memory
method _memory_unmap_os(address: ^Void; size: IntPtr; offset: IntPtr; release: Int32); private;
begin

  if (Boolean(release) and Boolean(offset)) then begin
    (() -> begin
      var _tmp0 := offset shl 3;
      offset := _tmp0;
      exit _tmp0;
    end)();
    {$IF PLATFORM_POSIX}
    (() -> begin
      var _tmp1 := size + offset;
      size := _tmp1;
      exit _tmp1;
    end)();
    {$ENDIF}
    address := ^Void((^AnsiChar(address) + IntPtr(-Int32(offset))));
  end;
  {$IF PLATFORM_WINDOWS}
  if not Boolean(VirtualFree(address, (if release then (0) else (size)), (if release then (MEM_RELEASE) else (MEM_DECOMMIT)))) then begin
    var err: DWORD := GetLastError();

  end;
  {$ELSE}
  if munmap(address, size) then begin

  end;
  {$ENDIF}
end;

{$IF ENABLE_GUARDS}
method _memory_guard_validate(p: ^Void); private;
begin
  if not Boolean(p) then begin
    exit;
  end;
  var block_start: ^Void;
  var block_size: IntPtr := _memory_usable_size(p);
  var span: ^span_t := ^Void((UIntPtr(p) and _memory_span_mask));
  var heap_id: Int32 := atomic_load32(@(span)^.heap_id);
  if heap_id then begin
    if ((span)^.size_class < (63 + 60)) then begin
      var span_blocks_start: ^Void := ^Void((^AnsiChar(span) + IntPtr(32)));
      var size_class: ^size_class_t := (_memory_size_class + (span)^.size_class);
      var block_offset: count_t := count_t(IntPtr((^AnsiChar(p) - ^AnsiChar(span_blocks_start))));
      var block_idx: count_t := (block_offset / count_t((size_class)^.size));
      block_start := ^Void((^AnsiChar(span_blocks_start) + IntPtr((block_idx * (size_class)^.size))));
    end
    else begin
      block_start := ^Void((^AnsiChar(span) + IntPtr(32)));
    end;
  end
  else begin
    block_start := ^Void((^AnsiChar(span) + IntPtr(32)));
  end;
  var deadzone: ^UInt32 := block_start;
  // If these asserts fire, you have written to memory before the block start
  begin
    // for loop: initializer
    var i: Int32 := 0;
    // for loop: compare
    _looplabel0:;
    if (i < 8) then begin

    end
    else begin
      goto _breaklabel0;
    end;
    // for loop: body
    begin
      if (deadzone[i] ≠ 3735927469) then begin
        if _memory_config.memory_overwrite then begin
          _memory_config.memory_overwrite(p);
        end
        else begin

        end;
        exit;
      end;
      deadzone[i] := 0;
    end;
    _continuelabel0:;
    // for loop: increment/continue
    i := i + 1;
    goto _looplabel0;
    // for loop: break
    _breaklabel0:;
  end;
  deadzone := ^UInt32(^Void((^AnsiChar(block_start) + IntPtr((block_size - 32)))));
  // If these asserts fire, you have written to memory after the block end
  begin
    // for loop: initializer
    var i: Int32 := 0;
    // for loop: compare
    _looplabel1:;
    if (i < 8) then begin

    end
    else begin
      goto _breaklabel1;
    end;
    // for loop: body
    begin
      if (deadzone[i] ≠ 3735927469) then begin
        if _memory_config.memory_overwrite then begin
          _memory_config.memory_overwrite(p);
        end
        else begin

        end;
        exit;
      end;
      deadzone[i] := 0;
    end;
    _continuelabel1:;
    // for loop: increment/continue
    i := i + 1;
    goto _looplabel1;
    // for loop: break
    _breaklabel1:;
  end;
end;
{$ENDIF}

{$IF ENABLE_GUARDS}
method _memory_guard_block(&block: ^Void); private;
begin
  if &block then begin
    var block_size: IntPtr := _memory_usable_size(&block);
    var deadzone: ^UInt32 := &block;
    (() -> begin
      var _tmp0 := deadzone[7];
      (() -> begin
        var _tmp0 := deadzone[6];
        (() -> begin
          var _tmp0 := deadzone[5];
          (() -> begin
            var _tmp0 := deadzone[4];
            (() -> begin
              var _tmp0 := deadzone[3];
              (() -> begin
                var _tmp0 := deadzone[2];
                (() -> begin
                  var _tmp0 := deadzone[1];
                  deadzone[0] := _tmp0;
                  exit _tmp0;
                end)() := _tmp1;
                exit _tmp1;
              end)() := _tmp2;
              exit _tmp2;
            end)() := _tmp3;
            exit _tmp3;
          end)() := _tmp4;
          exit _tmp4;
        end)() := _tmp5;
        exit _tmp5;
      end)() := _tmp6;
      exit _tmp6;
    end)() := 3735927469;
    deadzone := ^UInt32(^Void((^AnsiChar(&block) + IntPtr((block_size - 32)))));
    (() -> begin
      var _tmp7 := deadzone[7];
      (() -> begin
        var _tmp7 := deadzone[6];
        (() -> begin
          var _tmp7 := deadzone[5];
          (() -> begin
            var _tmp7 := deadzone[4];
            (() -> begin
              var _tmp7 := deadzone[3];
              (() -> begin
                var _tmp7 := deadzone[2];
                (() -> begin
                  var _tmp7 := deadzone[1];
                  deadzone[0] := _tmp7;
                  exit _tmp7;
                end)() := _tmp8;
                exit _tmp8;
              end)() := _tmp9;
              exit _tmp9;
            end)() := _tmp10;
            exit _tmp10;
          end)() := _tmp11;
          exit _tmp11;
        end)() := _tmp12;
        exit _tmp12;
      end)() := _tmp13;
      exit _tmp13;
    end)() := 3735927469;
  end;
end;
{$ENDIF}

//  Extern interface
method rpmalloc(size: IntPtr): ^Void; public;
begin

  var &block: ^Void := _memory_allocate(size);

  exit &block;
end;

method rpfree(ptr: ^Void); public;
begin

  _memory_deallocate(ptr);
end;

method rpcalloc(num: IntPtr; size: IntPtr): ^Void; public;
begin
  var total: IntPtr;
  total := (num * size);

  var &block: ^Void := _memory_allocate(total);

  memset(&block, 0, total);
  exit &block;
end;

method rprealloc(ptr: ^Void; size: IntPtr): ^Void; public;
begin


  var &block: ^Void := _memory_reallocate(ptr, size, 0, 0);

  exit &block;
end;

method rpaligned_realloc(ptr: ^Void; alignment: IntPtr; size: IntPtr; oldsize: IntPtr; &flags: UInt32): ^Void; public;
begin
  var &block: ^Void;
  if (alignment > 32) then begin
    &block := rpaligned_alloc(alignment, size);
    if ptr then begin
      if not Boolean((&flags and 1)) then begin
        if not Boolean(oldsize) then begin
          oldsize := _memory_usable_size(ptr);
        end;
        memcpy(&block, ptr, (if (oldsize < size) then (oldsize) else (size)));
      end;
      rpfree(ptr);
    end;
  end
  else begin


    &block := _memory_reallocate(ptr, size, oldsize, &flags);

  end;
  exit &block;
end;

method rpaligned_alloc(alignment: IntPtr; size: IntPtr): ^Void; public;
begin
  if (alignment ≤ 32) then begin
    exit rpmalloc(size);
  end;
  var ptr: ^Void := rpmalloc((size + alignment));
  if (UIntPtr(ptr) and (alignment - 1)) then begin
    ptr := ^Void(((UIntPtr(ptr) and not (UIntPtr(alignment) - 1)) + alignment));
  end;
  exit ptr;
end;

method rpmemalign(alignment: IntPtr; size: IntPtr): ^Void; public;
begin
  exit rpaligned_alloc(alignment, size);
end;

method rpposix_memalign(memptr: ^^Void; alignment: IntPtr; size: IntPtr): Int32; public;
begin
  if memptr then begin
    (memptr)^ := rpaligned_alloc(alignment, size);
  end
  else begin
    exit 22;
  end;
  exit (if (memptr)^ then (0) else (12));
end;

method rpmalloc_usable_size(ptr: ^Void): IntPtr; public;
begin
  var size: IntPtr := 0;
  if ptr then begin
    size := _memory_usable_size(ptr);
    {$IF ENABLE_GUARDS}
    (() -> begin
      var _tmp0 := size - 64;
      size := _tmp0;
      exit _tmp0;
    end)();
    {$ENDIF}
  end;
  exit size;
end;

method rpmalloc_thread_collect; public;
begin
  var heap: ^heap_t := get_thread_heap();
  _memory_unmap_deferred(heap, 0);
  _memory_deallocate_deferred(0, 0);
end;

method rpmalloc_thread_statistics(stats: ^rpmalloc_thread_statistics_t); public;
begin
  memset(stats, 0, sizeOf(rpmalloc_thread_statistics_t));
  var heap: ^heap_t := get_thread_heap();
  var p: ^Void := atomic_load_ptr(@(heap)^.defer_deallocate);
  while p do begin
    var next: ^Void := (^^Void(p))^;
    var span: ^span_t := ^Void((UIntPtr(p) and _memory_span_mask));
    (() -> begin
      var _tmp0 := (stats)^.deferred + _memory_size_class[(span)^.size_class].size;
      (stats)^.deferred := _tmp0;
      exit _tmp0;
    end)();
    p := next;
  end;
  begin
    // for loop: initializer
    var isize: IntPtr := 0;
    // for loop: compare
    _looplabel1:;
    if (isize < (63 + 60)) then begin

    end
    else begin
      goto _breaklabel1;
    end;
    // for loop: body
    begin
      if (heap)^.active_block[isize].free_count then begin
        (() -> begin
          var _tmp2 := (stats)^.active + ((heap)^.active_block[isize].free_count * _memory_size_class[((heap)^.active_span[isize])^.size_class].size);
          (stats)^.active := _tmp2;
          exit _tmp2;
        end)();
      end;
      var cache: ^span_t := (heap)^.size_cache[isize];
      while cache do begin
        (stats)^.sizecache := ((cache)^.data.block.free_count * _memory_size_class[(cache)^.size_class].size);
        cache := (cache)^.next_span;
      end;
    end;
    _continuelabel1:;
    // for loop: increment/continue
    isize := isize + 1;
    goto _looplabel1;
    // for loop: break
    _breaklabel1:;
  end;
  {$IF ENABLE_THREAD_CACHE}
  begin
    // for loop: initializer
    var iclass: IntPtr := 0;
    // for loop: compare
    _looplabel3:;
    if (iclass < 32) then begin

    end
    else begin
      goto _breaklabel3;
    end;
    // for loop: body
    begin
      if (heap)^.span_cache[iclass] then begin
        (stats)^.spancache := ((IntPtr(((heap)^.span_cache[iclass])^.data.list.size) * (iclass + 1)) * _memory_span_size);
      end;
    end;
    _continuelabel3:;
    // for loop: increment/continue
    iclass := iclass + 1;
    goto _looplabel3;
    // for loop: break
    _breaklabel3:;
  end;
  {$ENDIF}
end;

method rpmalloc_global_statistics(stats: ^rpmalloc_global_statistics_t); public;
begin
  memset(stats, 0, sizeOf(rpmalloc_global_statistics_t));
  {$IF ENABLE_STATISTICS}
  (stats)^.mapped := (IntPtr(atomic_load32(@_mapped_pages)) * _memory_page_size);
  (stats)^.mapped_total := (IntPtr(atomic_load32(@_mapped_total)) * _memory_page_size);
  (stats)^.unmapped_total := (IntPtr(atomic_load32(@_unmapped_total)) * _memory_page_size);
  {$ENDIF}
end;

type
  // rpmalloc.c  -  Memory allocator  -  Public Domain  -  2016 Mattias Jansson / Rampant Pixels
  //  *
  //  * This library provides a cross-platform lock free thread caching malloc implementation in C11.
  //  * The latest source code is always available at
  //  *
  //  * https://github.com/rampantpixels/rpmalloc
  //  *
  //  * This library is put in the public domain; you can redistribute it and/or modify it without any restrictions.
  //  *
  //  
  //  rpmalloc.h  -  Memory allocator  -  Public Domain  -  2016 Mattias Jansson / Rampant Pixels
  //  *
  //  * This library provides a cross-platform lock free thread caching malloc implementation in C11.
  //  * The latest source code is always available at
  //  *
  //  * https://github.com/rampantpixels/rpmalloc
  //  *
  //  * This library is put in the public domain; you can redistribute it and/or modify it without any restrictions.
  //  *
  //  
  // ! Flag to rpaligned_realloc to not preserve content in reallocation
  rpmalloc_global_statistics_t = public record
  private

    // ! Current amount of virtual memory mapped (only if ENABLE_STATISTICS=1)
    var &mapped: IntPtr; public;
    // ! Current amount of memory in global caches for small and medium sizes (<64KiB)
    var cached: IntPtr; public;
    // ! Total amount of memory mapped (only if ENABLE_STATISTICS=1)
    var mapped_total: IntPtr; public;
    // ! Total amount of memory unmapped (only if ENABLE_STATISTICS=1)
    var unmapped_total: IntPtr; public;

  end;

  rpmalloc_thread_statistics_t = public record
  private

    // ! Current number of bytes available for allocation from active spans
    var active: IntPtr; public;
    // ! Current number of bytes available in thread size class caches
    var sizecache: IntPtr; public;
    // ! Current number of bytes available in thread span caches
    var spancache: IntPtr; public;
    // ! Current number of bytes in pending deferred deallocations
    var deferred: IntPtr; public;
    // ! Total number of bytes transitioned from thread cache to global cache
    var thread_to_global: IntPtr; public;
    // ! Total number of bytes transitioned from global cache to thread cache
    var global_to_thread: IntPtr; public;

  end;

  rpmalloc_config_t = public record
  private

    // ! Map memory pages for the given number of bytes. The returned address MUST be
    //   aligned to the rpmalloc span size, which will always be a power of two.
    //   Optionally the function can store an alignment offset in the offset variable
    //   in case it performs alignment and the returned pointer is offset from the
    //   actual start of the memory region due to this alignment. The alignment offset
    //   will be passed to the memory unmap function. The alignment offset MUST NOT be
    //   larger than 65535 (storable in an uint16_t), if it is you must use natural
    //   alignment to shift it into 16 bits.
    var memory_map: __fnptrtype0; public;
    // ! Unmap the memory pages starting at address and spanning the given number of bytes.
    //   If release is set to 1, the unmap is for an entire span range as returned by
    //   a previous call to memory_map and that the entire range should be released.
    //   If release is set to 0, the unmap is a partial decommit of a subset of the mapped
    //   memory range.
    var memory_unmap: __fnptrtype1; public;
    // ! Size of memory pages. The page size MUST be a power of two in [512,16384] range
    //   (2^9 to 2^14) unless 0 - set to 0 to use system page size. All memory mapping
    //   requests to memory_map will be made with size set to a multiple of the page size.
    var page_size: IntPtr; public;
    // ! Size of a span of memory pages. MUST be a multiple of page size, and in [4096,262144]
    //   range (unless 0 - set to 0 to use the default span size).
    var span_size: IntPtr; public;
    // ! Number of spans to map at each request to map new virtual memory blocks. This can
    //   be used to minimize the system call overhead at the cost of virtual memory address
    //   space. The extra mapped pages will not be written until actually used, so physical
    //   committed memory should not be affected in the default implementation.
    var span_map_count: IntPtr; public;
    // ! Debug callback if memory guards are enabled. Called if a memory overwrite is detected
    var memory_overwrite: __fnptrtype2; public;

  end;

  __fnptrtype0 = public method(size: IntPtr; offset: ^IntPtr): ^Void;

  __fnptrtype1 = public method(address: ^Void; size: IntPtr; offset: IntPtr; release: Int32);

  __fnptrtype2 = public method(address: ^Void);

  // #undef NDEBUG
  // #undef assert
  // / Atomic access abstraction
  __struct_atomic32_t = public record
  private

    var nonatomic: Int32; volatile; public;

  end;

  atomic32_t = public __struct_atomic32_t;

  __struct_atomic64_t = public record
  private

    var nonatomic: Int64; volatile; public;

  end;

  atomic64_t = public __struct_atomic64_t;

  __struct_atomicptr_t = public record
  private

    var nonatomic: ^Void; volatile; public;

  end;

  atomicptr_t = public __struct_atomicptr_t;

  {$IF ARCH_64BIT}
  // / Preconfigured limits and sizes
  // ! Granularity of a small allocation block
  // ! Small granularity shift count
  // ! Number of small block size classes
  // ! Maximum size of a small block
  // ! Granularity of a medium allocation block
  // ! Medium granularity shift count
  // ! Number of medium block size classes
  // ! Total number of small + medium size classes
  // ! Number of large block size classes
  // ! Maximum size of a medium block
  // ! Maximum size of a large block
  // ! Size of a span header
  offset_t = public Int64;
  {$ENDIF}

  {$IF NOT ARCH_64BIT}
  offset_t = public Int32;
  {$ENDIF}

  count_t = public UInt32;

  // / Data types
  // ! A memory heap, per thread
  heap_t = public __struct_heap_t;

  // ! Span of memory pages
  span_t = public __struct_span_t;

  // ! Size class definition
  size_class_t = public __struct_size_class_t;

  // ! Span block bookkeeping
  span_block_t = public __struct_span_block_t;

  // ! Span list bookkeeping
  span_list_t = public __struct_span_list_t;

  // ! Span data union, usage depending on span state
  span_data_t = public __struct_span_data_t;

  // ! Cache data
  span_counter_t = public __struct_span_counter_t;

  // ! Global cache
  global_cache_t = public __struct_global_cache_t;

  // ! Flag indicating span is the first (master) span of a split superspan
  // ! Flag indicating span is a secondary (sub) span of a split superspan
  // Alignment offset must match in both structures to keep the data when
  // transitioning between being used for blocks and being part of a list
  __struct_span_block_t = public record
  private

    // ! Free list
    var free_list: UInt16; public;
    // ! First autolinked block
    var first_autolink: UInt16; public;
    // ! Free count
    var free_count: UInt16; public;
    // ! Alignment offset
    var align_offset: UInt16; public;

  end;

  __struct_span_list_t = public record
  private

    // ! List size
    var size: UInt32; public;
    // ! Unused in lists
    var unused: UInt16; public;
    // ! Alignment offset
    var align_offset: UInt16; public;

  end;

  [&Union]
  __struct_span_data_t = public record
  private

    // ! Span data when used as blocks
    var &block: span_block_t; public;
    // ! Span data when used in lists
    var list: span_list_t; public;

  end;

  // A span can either represent a single span of memory pages with size declared by span_map_count configuration variable,
  // or a set of spans in a continuous region, a super span. Any reference to the term "span" usually refers to both a single
  // span or a super span. A super span can further be diviced into multiple spans (or this, super spans), where the first
  // (super)span is the master and subsequent (super)spans are subspans. The master span keeps track of how many subspans
  // that are still alive and mapped in virtual memory, and once all subspans and master have been unmapped the entire
  // superspan region is released and unmapped (on Windows for example, the entire superspan range has to be released
  // in the same call to release the virtual memory range, but individual subranges can be decommitted individually
  // to reduce physical memory use).
  __struct_span_t = public record
  private

    // !	Heap ID
    var heap_id: atomic32_t; public;
    // ! Size class
    var size_class: UInt16; public;
    // TODO: If we could store remainder part of flags as an atomic counter, the entire check
    //        if master is owned by calling heap could be simplified to an atomic dec from any thread
    //        since remainder of a split super span only ever decreases, never increases
    // ! Flags and counters
    var &flags: UInt16; public;
    // ! Span data
    var data: span_data_t; public;
    // ! Next span
    var next_span: ^span_t; public;
    // ! Previous span
    var prev_span: ^span_t; public;

  end;

  // Adaptive cache counter of a single superspan span count
  __struct_span_counter_t = public record
  private

    // ! Allocation high water mark
    var max_allocations: UInt32; public;
    // ! Current number of allocations
    var current_allocations: UInt32; public;
    // ! Cache limit
    var cache_limit: UInt32; public;

  end;

  __struct_heap_t = public record
  private

    // ! Heap ID
    var id: Int32; public;
    // ! Free count for each size class active span
    var active_block: array[0..122] of span_block_t; public;
    // ! Active span for each size class
    var active_span: array[0..122] of ^span_t; public;
    // ! List of semi-used spans with free blocks for each size class (double linked list)
    var size_cache: array[0..122] of ^span_t; public;
    {$IF ENABLE_THREAD_CACHE}
    var span_cache: array[0..31] of ^span_t; public;
    {$ENDIF}
    {$IF ENABLE_THREAD_CACHE}
    // ! Allocation counters
    var span_counter: array[0..31] of span_counter_t; public;
    {$ENDIF}
    // ! Mapped but unused spans
    var span_reserve: ^span_t; public;
    // ! Master span for mapped but unused spans
    var span_reserve_master: ^span_t; public;
    // ! Number of mapped but unused spans
    var spans_reserved: IntPtr; public;
    // ! Deferred deallocation
    var defer_deallocate: atomicptr_t; public;
    // ! Deferred unmaps
    var defer_unmap: atomicptr_t; public;
    // ! Next heap in id list
    var next_heap: ^heap_t; public;
    // ! Next heap in orphan list
    var next_orphan: ^heap_t; public;
    // ! Memory pages alignment offset
    var align_offset: IntPtr; public;
    {$IF ENABLE_STATISTICS}
    var thread_to_global: IntPtr; public;
    {$ENDIF}
    {$IF ENABLE_STATISTICS}
    // ! Number of bytes transitioned global -> thread
    var global_to_thread: IntPtr; public;
    {$ENDIF}

  end;

  __struct_size_class_t = public record
  private

    // ! Size of blocks in this class
    var size: UInt32; public;
    // ! Number of blocks in each chunk
    var block_count: UInt16; public;
    // ! Class index this class is merged with
    var class_idx: UInt16; public;

  end;

  __struct_global_cache_t = public record
  private

    // ! Cache list pointer
    var cache: atomicptr_t; public;
    // ! Cache size
    var size: atomic32_t; public;
    // ! ABA counter
    var counter: atomic32_t; public;

  end;

end.
