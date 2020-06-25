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


def main():
    logging.basicConfig(level=logging.DEBUG, stream=sys.stderr)
    filename = sys.argv[1] if len(sys.argv) > 1 else "Formula/novaprova.rb"
    tmp_out_filename = filename + ".tmp"
    url = None
    with open(filename) as fin:
        with open(tmp_out_filename, "w") as fout:
            for line in fin:
                if not line.startswith("#"):
                    fields = line.split()
                    if len(fields) == 2 and fields[0] == "url":
                        url = fields[1].lstrip("\"").rstrip("\"")
                    elif len(fields) == 2 and fields[0] in hash_algorithms:
                        if url is None:
                            _log.error("Please put the \"%s\" keyword after \"url\"", fields[0])
                            raise RuntimeError
                        algorithm = fields[0]
                        checksum = generate_checksum(url, algorithm)
                        new_line = re.sub(r'"[0-9a-fA-F]+"', f"\"{checksum}\"", line)
                        _log.info("Replacing line:")
                        _log.info("    %s", line)
                        _log.info("with")
                        _log.info("    %s", new_line)
                        line = new_line
                fout.write(line)
    os.rename(tmp_out_filename, filename)


if __name__ == "__main__":
    main()
