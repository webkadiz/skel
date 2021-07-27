#!/usr/bin/env python

import os
import argparse
import sys


def sync(src, dest):
    files = open("skel")
    cpFlags = "-a"

    if args.interactive:
        cpFlags += " -i"

    for file in files:
        file = file.strip()
        fullSrc = src + file
        fullDest = dest + file
        dirname = os.path.dirname(fullDest)

        os.system(f"mkdir -p '{dirname}'")

        if os.path.isdir(fullDest):
            command = f"cp {cpFlags} '{fullSrc}' '{dirname}'"
        else: 
            command = f"cp {cpFlags} '{fullSrc}' '{dirname}'"

        if not args.interactive:
            print(command)

        os.system(command)


parser = argparse.ArgumentParser()
parser.add_argument("-f", "--from-skel", action="store_true", help="sync from skel to system")
parser.add_argument("-t", "--to-skel", action="store_true", help="sync from system to skel")
parser.add_argument("-i", "--interactive", action="store_true", help="prompt before overwrite")
args = parser.parse_args(sys.argv[1:])

if args.from_skel:
    src = './'
    dest = os.path.expanduser('~/')
    sync(src, dest)
elif args.to_skel:
    src = os.path.expanduser('~/')
    dest = './'
    sync(src, dest)
else:
    parser.print_help()
    exit(1)
