# remove .fbx from all files in given folder 
import os,sys 

files = os.listdir(".")

for f in files:
    if(f.find(".fbx") != -1): # found if not -1
        newname = f.split('.')
        newname = newname[0] + '.' + newname[2]
        os.rename(f, newname)
        