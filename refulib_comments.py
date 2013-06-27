#This is a script that will recursively iterate Refu clib directory
#and attempt to alter the doxygen comments. Probably will be an
#one time thing

import argparse
import os


def write_to_file(f, s, dry):
    if not dry:
        f.write(s)

def edit_file(full_name, dry):
    print("Opening {}".format(full_name))
    inF = open(full_name, "r")
    outF = "" # just a silly assignment for when we have dry run(could have been done a lot better)
    if not dry:
        outF = open(full_name+"_temp", "w")
    inComment = False
    line_num = 1
    for line in inF:
        if line.startswith("//!"):
            if "@{" in line or "@}" in line or "@name" in line:
                write_to_file(outF, line, dry)
                line_num = line_num+1
                continue
            if not inComment:
                print("Got in a comment in line [{}]".format(line_num))
                inComment = True                
                write_to_file(outF, "/**\n", dry)
                write_to_file(outF, line.replace("//!"," **"), dry)
            else:
                write_to_file(outF, line.replace("//!"," **"), dry)
        else:
            if inComment:
                print("Got out of a comment in line [{}]".format(line_num))
                write_to_file(outF, " **\n **/\n", dry)
                inComment = False
            write_to_file(outF, line, dry)
        line_num = line_num+1

    inF.close()
    if not dry:
        outF.close()
        os.remove(full_name)
        os.rename(full_name+"_temp", full_name)
    print("Closing {}".format(full_name))

parser = argparse.ArgumentParser(description="Refu lib comment modifier")
parser.add_argument('-d', '--directory', default=".",
dest = "dir", help="The path to the directory to dive in")
parser.add_argument('-n', '--dry-run', action="store_true", dest="dry",
                    help="Will not edit any files. It will simply echo \
                    the actions it would take if this argument was not passed")
args = vars(parser.parse_args())


for dirname, dirnames, filenames in os.walk(args["dir"]):
    # Advanced usage:
    # editing the 'dirnames' list will stop os.walk() from recursing into there.
    if '.git' in dirnames:
        # don't go into any .git directories.
        dirnames.remove('.git')

    # print path to all filenames.
    for filename in filenames:
        if filename.endswith(".c") or filename.endswith(".h") or filename.endswith(".ph"):
            full_name = os.path.join(dirname, filename)
            edit_file(full_name, args["dry"])
