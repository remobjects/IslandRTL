#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>

typedef int (__stdcall *initialize_island_fn)(void);

typedef struct worker_args {
  initialize_island_fn initialize;
  int result;
} worker_args;

static DWORD WINAPI worker_proc(void *parameter) {
  worker_args *args = (worker_args *)parameter;
  args->result = args->initialize();
  return args->result == 1 ? 0 : 1;
}

int main(void) {
  HMODULE module = LoadLibraryA("IslandGcUnloadPayload.dll");
  if (module == NULL) {
    fprintf(stderr, "LoadLibrary failed: %lu\n", GetLastError());
    return 10;
  }

  initialize_island_fn initialize =
    (initialize_island_fn)GetProcAddress(module, "_InitializeIslandOnWorker@0");
  if (initialize == NULL) {
    fprintf(stderr, "GetProcAddress failed: %lu\n", GetLastError());
    return 11;
  }

  worker_args args = { initialize, 0 };
  HANDLE worker = CreateThread(NULL, 0, worker_proc, &args, 0, NULL);
  if (worker == NULL) {
    fprintf(stderr, "CreateThread failed: %lu\n", GetLastError());
    return 12;
  }

  WaitForSingleObject(worker, INFINITE);
  CloseHandle(worker);
  if (args.result != 1) {
    fprintf(stderr, "Island worker returned %d\n", args.result);
    return 13;
  }

  puts("Unloading Island DLL from the native main thread.");
  if (!FreeLibrary(module)) {
    fprintf(stderr, "FreeLibrary failed: %lu\n", GetLastError());
    return 14;
  }
  puts("Unload completed.");
  return 0;
}
