#!/usr/bin/env python3
from time import sleep
import subprocess as sp
import os
from datetime import datetime

running = True

script_file = "script-dirs.txt"
tmp_script = "tmp-script.txt"
new_tmp_script = "tmp-script-new.txt"
dir_file = "dirs.txt"
directories = []
temp_dir_file = "temp.txt"
new_temp_dir_file = "temp-new.txt"


def read_dir(_file):
    f = open(_file, "r")
    dirs = [x.strip('\n\r') for x in f] 
    f.close()
    return dirs
    

def append_temp(dirs, filename, addr):
    for path in dirs:
        if dirs.index(path) == 0:
            f = open(filename, "w")
        else:
            f = open(filename, "a")
        if addr == "files":
            cmd = "tree -Dh --du ~/public_html/" + path
        else:
            cmd = "tree -Dh --du ~/codes/assets/" + path
        f.writelines(sp.getoutput(cmd))
        f.close()


def update():
        os.system("~/codes/update-file.sh")
        print("successfully. " + datetime.now().strftime("%d/%m/%Y %H:%M:%S") + "\n")


def check_for_update(dirs, old_temp, new_temp, addr, mode=1):
    append_temp(dirs, new_temp, addr)
    #f1 = os.stat(old_temp).st_size
    #f2 = os.stat(new_temp).st_size
    f1 = sp.getoutput("cat " + old_temp)
    f2 = sp.getoutput("cat " + new_temp)
    if f2 != f1 or mode != 1:
        print("Detected modifying...")
        update()
        append_temp(dirs, old_temp, addr)


def run():
    check_for_update(read_dir(dir_file), temp_dir_file, new_temp_dir_file, "files")
    check_for_update(read_dir(script_file), tmp_script, new_tmp_script, "codes")


print("Running:", running)
while running:
    run()
    try:
        sleep(5)
    except KeyboardInterrupt as e:
        try:
            ans = input("\nDo you want to stop?(Y/n): ")
            if "Y" in ans or "y" in ans:
                running = False
                print("\nStopped running")
            if "r" in ans:
                print("========== Reloading ==========")
                update()
        except KeyboardInterrupt as e:
            print("\n")
