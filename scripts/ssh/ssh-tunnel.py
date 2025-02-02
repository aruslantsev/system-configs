#!/usr/bin/python

import json
import subprocess
import sys
import time

HOST = "host"
DESTINATION_ADDRESS = "destination_address"
DESTINATION_PORT = "destination_port"
LOCAL_ADDRESS = "local_address"
LOCAL_PORT = "local_port"
REMOTE_ADDRESS = "remote_address"
REMOTE_PORT = "remote_port"

LOCALHOST = "localhost"

LOCAL = "local"
REMOTE = "remote"


def print_usage():
    print(f"Usage: {sys.argv[0]} config.json")


def main():
    if len(sys.argv) != 2 or sys.argv[1] in ("-h", "--help"):
        print_usage()
        sys.exit(0)
    with open(sys.argv[1], "r") as fd:
        config = json.load(fd)

    processes = []
    try:
        for host, entries in config.items():
            cmd = []
            for entry in entries.get(LOCAL, []):
                destination_port = entry[DESTINATION_PORT]
                destination_address = entry.get(DESTINATION_ADDRESS, LOCALHOST)
                local_port = entry.get(LOCAL_PORT, destination_port)
                local_address = entry.get(LOCAL_ADDRESS, None)
                cmd.append("-L")
                if local_address:
                    cmd.append(
                        f"{local_address}:{local_port}:{destination_address}:{destination_port}")
                else:
                    cmd.append(f"{local_port}:{destination_address}:{destination_port}")
            for entry in entries.get(REMOTE, []):
                destination_port = entry[DESTINATION_PORT]
                destination_address = entry.get(DESTINATION_ADDRESS, LOCALHOST)
                remote_port = entry.get(REMOTE_PORT, destination_port)
                remote_address = entry.get(REMOTE_ADDRESS, None)
                cmd.append("-R")
                if remote_address:
                    cmd.append(
                        f"{remote_address}:{remote_port}:{destination_address}:{destination_port}")
                else:
                    cmd.append(f"{remote_port}:{destination_address}:{destination_port}")
            if cmd:
                cmd = ["ssh", "-N"] + cmd + [host]
                processes.append(subprocess.Popen(cmd))
                print(f"""Started '{" ".join(cmd)}'""")
    except Exception as e:
        print("Got exception. Killing all processes.")
        kill_processes(processes)
        print(e)
        sys.exit(1)
    if not processes:
        print("No processes were started")
        sys.exit(1)

    while True:
        try:
            for process in processes:
                if process.poll() is not None:
                    print(f"""Process '{" ".join(process.args)}' died unexpextedly. Exiting""")
                    kill_processes(processes)
                    sys.exit(1)
            time.sleep(1)
        except KeyboardInterrupt:
            print()
            kill_processes(processes)
            sys.exit(1)


def kill_processes(processes):
    for process in processes:
        try:
            process.terminate()
            print(f"""Terminated '{" ".join(process.args)}'""")
        except OSError as e:
            print(f"""Failed to terminate '{" ".join(process.args)}'. Trying to kill""")
            print(e)
            try:
                process.kill()
            except Exception as e:
                print(f"""Failed to kill '{" ".join(process.args)}'""")
                print(e)


if __name__ == "__main__":
    main()
