#!/usr/bin/env python3
"""Build native ARM64EC transition support; optionally merge an EC Island.lib."""
import argparse
from pathlib import Path
import re
import shutil
import subprocess
import tempfile


def run(command, **kwargs):
    return subprocess.run([str(value) for value in command], check=True, **kwargs)


def require_ec(tool, filename):
    headers = run([tool, '--file-headers', filename], capture_output=True, text=True).stdout
    machines = re.findall(r'Machine: (\S+)', headers)
    if not machines or any(machine != 'IMAGE_FILE_MACHINE_ARM64EC' for machine in machines):
        raise ValueError(f'{filename} must contain only ARM64EC COFF objects')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--llvm-bin', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path)
    parser.add_argument('--island-library', type=Path,
                        help='Merge support into an already-built ARM64EC Island.lib; never modifies the input')
    args = parser.parse_args()
    tools = {name: args.llvm_bin / (name + ('.exe' if __import__('os').name == 'nt' else ''))
             for name in ('clang', 'llvm-ar', 'llvm-readobj')}
    source = Path(__file__).resolve().parent / 'chpe.S'
    output = args.output.resolve()
    if args.island_library:
        library = args.island_library.resolve()
        if library == output / 'Island.lib':
            parser.error('Output must differ from the input Island.lib directory')
        require_ec(tools['llvm-readobj'], library)
    output.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='arm64ec-support-') as temporary:
        work = Path(temporary)
        obj = work / 'chpe.obj'
        run([tools['clang'], '--target=arm64ec-pc-windows-msvc', '-c', source, '-o', obj])
        require_ec(tools['llvm-readobj'], obj)
        archive = work / 'arm64ec-support.lib'
        run([tools['llvm-ar'], 'rcD', archive, obj])
        if args.island_library:
            shutil.copyfile(library, work / 'island-input.lib')
            run([tools['llvm-ar'], '-M'], cwd=work, text=True,
                input='CREATE Island.lib\nADDLIB island-input.lib\nADDMOD chpe.obj\nSAVE\nEND\n')
            require_ec(tools['llvm-readobj'], work / 'Island.lib')
            shutil.copyfile(work / 'Island.lib', output / 'Island.lib')
        shutil.copyfile(archive, output / archive.name)
    print(f'ARM64EC transition support: {output}')


if __name__ == '__main__':
    main()
