#!/usr/bin/env python3

import logging
import subprocess
import sys
import re
import os
import hashlib

_log = logging.getLogger(__name__)
hash_algorithms = {"sha256",}


def generate_checksum(url, algorithm):
    _log.info("Downloading %s", url)
    proc = subprocess.Popen(["curl", "-L", url], stdout=subprocess.PIPE)
    out, _ = proc.communicate()
    _log.info("Checksumming downloaded data with %s", algorithm)
    digest = hashlib.new(algorithm, out).hexdigest()
    _log.info("Checksum is %s", digest)
    return digest


def increment_rclevel_in_url(url):
    reg = re.compile(r'.*/[0-9.]+rc([0-9]+).(zip|tar.gz|tar.bz2|tar.xz|tar)$')
    m = reg.match(url)
    if not m:
        _log.error("Could not extract RC level from URL")
        raise RuntimeError
    rclevel = int(m.group(1))
    newurl = url[:m.start(1)] + str(rclevel + 1) + url[m.end(1):]
    return newurl


def main():
    logging.basicConfig(level=logging.DEBUG, stream=sys.stderr)
    filename = sys.argv[1] if len(sys.argv) > 1 else "Formula/novaprova.rb"
    tmp_out_filename = filename + ".tmp"
    url = None
    with open(filename) as fin:
        with open(tmp_out_filename, "w") as fout:
            for line in fin:
                new_line = line
                if not line.startswith("#"):
                    fields = line.split()
                    if len(fields) == 2 and fields[0] == "url":
                        url = fields[1].lstrip("\"").rstrip("\"")
                        url = increment_rclevel_in_url(url)
                        new_line = re.sub(r'"[^"]+"', f"\"{url}\"", line)
                    elif len(fields) == 2 and fields[0] in hash_algorithms:
                        if url is None:
                            _log.error("Please put the \"%s\" keyword after \"url\"", fields[0])
                            raise RuntimeError
                        algorithm = fields[0]
                        checksum = generate_checksum(url, algorithm)
                        new_line = re.sub(r'"[0-9a-fA-F]+"', f"\"{checksum}\"", line)
                if line != new_line:
                    _log.info("Replacing line:")
                    _log.info("    %s", line.rstrip())
                    _log.info("with")
                    _log.info("    %s", new_line.rstrip())
                    line = new_line
                fout.write(line)
    os.rename(tmp_out_filename, filename)


if __name__ == "__main__":
    main()
