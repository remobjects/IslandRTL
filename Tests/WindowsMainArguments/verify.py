"""Run on Windows against an executable built with the runtime under test."""
from pathlib import Path
import subprocess
import sys


def cases():
    return [
        ('none', []),
        ('one', ['alpha']),
        ('empty', ['']),
        ('quoted', ['two words', '', 'C:\\folder with space\\', 'quote"inside',
                    'Grüße Ελληνικά 日本語 😀']),
        ('many', [f'argument-{i}' for i in range(129)]),
        ('long', ['x' * 4097, 'end']),
    ]


def expected_lines(args):
    lines = ['ENTER Main', f'COUNT={len(args)}']
    for index, value in enumerate(args):
        data = value.encode('utf-16-le')
        units = [int.from_bytes(data[i:i + 2], 'little') for i in range(0, len(data), 2)]
        lines.append(f'ARG={index}:{len(units)}' + ''.join(f':{unit}' for unit in units))
    return lines + ['PASS Windows Main arguments and bounds']


if __name__ == '__main__':
    exe = Path(sys.argv[1]).resolve()
    for name, args in cases():
        completed = subprocess.run([str(exe), *args], cwd=exe.parent,
                                   capture_output=True, timeout=15)
        actual = completed.stdout.decode('ascii').splitlines()
        if completed.returncode != 0 or actual != expected_lines(args):
            raise SystemExit(f'FAIL {name}: exit={completed.returncode}\n'
                             f'{completed.stdout!r}\n{completed.stderr!r}')
        print(f'PASS {name}')
