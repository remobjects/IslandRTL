#!/usr/bin/env python3
"""Structural ARM64EC transition checks; these do not run Windows code."""
import argparse
from pathlib import Path
import subprocess
import sys
import tempfile


def run(command, succeeds=True):
    result = subprocess.run([str(item) for item in command], capture_output=True, text=True)
    if (result.returncode == 0) != succeeds:
        raise AssertionError(f'{command}\n{result.stdout}\n{result.stderr}')
    return result.stdout + result.stderr


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--llvm-bin', required=True, type=Path)
    parser.add_argument('--lld', required=True, type=Path)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[2]
    support = root / 'Source/Windows/ARM64EC'
    suffix = '.exe' if sys.platform == 'win32' else ''
    clang = args.llvm_bin / ('clang' + suffix)
    ar = args.llvm_bin / ('llvm-ar' + suffix)
    readobj = args.llvm_bin / ('llvm-readobj' + suffix)
    linker = [args.lld]
    if args.lld.stem == 'lld':
        linker += ['-flavor', 'link']
    with tempfile.TemporaryDirectory(prefix='arm64ec-transition-test-') as temp:
        work = Path(temp)
        output = work / 'support'
        build = [sys.executable, support / 'build.py', '--llvm-bin', args.llvm_bin]
        run(build + ['--output', output])
        archive = output / 'arm64ec-support.lib'
        info = run([readobj, '--file-headers', '--unwind', archive])
        assert 'IMAGE_FILE_MACHINE_ARM64EC' in info
        assert 'Function: __icall_helper_arm64ec' in info and 'FrameSize: 16' in info
        run([clang, '--target=arm64ec-pc-windows-msvc', '-c',
             Path(__file__).with_name('Transition.S'), '-o', work / 'test.obj'])
        exe = work / 'test.exe'
        run(linker + ['/machine:arm64ec', '/entry:transition_test', '/subsystem:console',
                      '/nodefaultlib', f'/out:{exe}', work / 'test.obj', archive])
        info = run([readobj, '--coff-load-config', exe])
        assert 'CHPEMetadata [' in info and 'Version: 0x1' in info
        assert 'CHPEMetadataPointer: 0x0' not in info
        for field in ('__os_arm64x_dispatch_call_no_redirect', '__os_arm64x_dispatch_ret',
                      '__os_arm64x_dispatch_call', '__os_arm64x_dispatch_icall',
                      '__os_arm64x_dispatch_icall_cfg', 'ExtraRFETable'):
            assert f'{field}: 0x' in info and f'{field}: 0x0\n' not in info
        assert ' ARM64EC' in info and ' X64' in info
        input_lib = work / 'input.lib'
        run([ar, 'rcD', input_lib, work / 'test.obj'])
        merged = work / 'merged'
        run(build + ['--output', merged, '--island-library', input_lib])
        run(linker + ['/machine:arm64ec', '/entry:transition_test', '/subsystem:console',
                      '/nodefaultlib', f'/out:{work / "merged.exe"}', merged / 'Island.lib'])
        info = run([readobj, '--coff-load-config', work / 'merged.exe'])
        assert 'CHPEMetadata [' in info
        run(build + ['--output', merged, '--island-library', merged / 'Island.lib'], succeeds=False)
        negative = work / 'negative.S'
        negative.write_text('// Negative regression guard: ordinary ARM64 cannot be merged as EC.\n.text\nret\n')
        run([clang, '--target=aarch64-pc-windows-msvc', '-c', negative, '-o', work / 'arm64.obj'])
        run([ar, 'rcD', work / 'arm64.lib', work / 'arm64.obj'])
        message = run(build + ['--output', work / 'invalid', '--island-library', work / 'arm64.lib'], succeeds=False)
        assert 'must contain only ARM64EC COFF objects' in message
        assert not (work / 'invalid').exists()
        message = run([clang, '--target=aarch64-pc-windows-msvc', '-c', support / 'chpe.S',
                       '-o', work / 'wrong.obj'], succeeds=False)
        assert 'requires the ARM64EC target' in message
    print('PASS: EC support archive, adjustor unwind, CHPE link/merge, and negative target guards')


if __name__ == '__main__':
    main()
