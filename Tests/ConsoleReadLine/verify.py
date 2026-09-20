# Runs the real native reader using redirected stdin; a timeout catches EOF loops.
import os
import subprocess
import sys


def encoded(lines):
    result = []
    for line in lines:
        data = line.encode("utf-16-le")
        units = [int.from_bytes(data[i:i + 2], "little") for i in range(0, len(data), 2)]
        result.append(str(len(units)) + ":" + "".join(str(unit) + " " for unit in units))
    return "\n".join(result) + "\n"


cases = [("empty EOF", b"", ["", "", ""]),
         ("empty lines", b"\n\n\n", ["", "", ""]),
         ("UTF-8 and whitespace", "  café 漢字 🙂 é  \nnext\n".encode(), ["  café 漢字 🙂 é  ", "next", ""]),
         ("unterminated EOF", "last café 🙂".encode(), ["last café 🙂", "", ""])]
for size in [254, 255, 256, 257, 511, 512, 513, 8192]:
    for tail in ["", "é", "漢", "🙂"]:
        text = "a" * size + tail
        cases.append((str(size) + "/" + repr(tail), (text + "\nend\n").encode(), [text, "end", ""]))
for name, data, expected in cases:
    process = subprocess.run([sys.argv[1]], input=data, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                             timeout=5, env={**os.environ, "LANG": "en_US.UTF-8", "LC_ALL": "en_US.UTF-8"})
    assert process.returncode == 0, (name, process.returncode, process.stderr)
    actual = process.stdout.decode().replace("\r\n", "\n")
    assert actual == encoded(expected), (name, actual[:300], encoded(expected)[:300])
print("PASS:", len(cases), "native ReadLine cases: UTF-8, byte boundaries, long lines, whitespace, repeated reads and EOF")
