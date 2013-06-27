#This is a script that will recursively iterate the directories under it
#and change the shebang to the given one. If there is no shebang one is 
#added

import argparse
import os



def add_shebang(full_name, path):
    inF = open(full_name, "r")
    outF = open(full_name+"_temp", "w")
    
    count = 1
    for line in inF:
        if count == 1:
            #add the shebang
            outF.write("#!{}\n".format(path))
            #if the file already had a shebang then don't copy it
            if line.startswith("#!"):
                count = count + 1
                continue
        outF.write(line)
        count = count + 1

    inF.close()
    outF.close()
    os.remove(full_name)
    os.rename(full_name+"_temp", full_name)

parser = argparse.ArgumentParser(description="Python shebang changer")
parser.add_argument('-d', '--directory', default=".",
dest = "dir", help="The path to the directory to dive in")
parser.add_argument('shebang_path', default="/usr/bin/python2.7",
 help="The shebang to write in the start of the file omitting #!")
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
        if filename.endswith(".py"):
            full_name = os.path.join(dirname, filename)
            if args["dry"] == True:
                print ("Will edit: \n{} ".format(full_name))
                continue
            #else not a dry run so we can edit
            add_shebang(full_name, args["shebang_path"])




            