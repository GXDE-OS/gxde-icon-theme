#!/usr/bin/env python3
import os
import sys
import shutil
for k in sys.argv[1:]:
    for d in os.listdir(k):
        if not os.path.isdir(d):
            continue
        for i in os.listdir(d):
            try:
                shutil.copy(f"{d}/{i}", f'{d}/{i.replace("deepin", "gxde")}')
            except:
                pass
    
