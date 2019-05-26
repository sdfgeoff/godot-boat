# This file is run inside blender, it opens each of the passed in files and
# exports it to the type specified in the render output panel
import sys
sys.dont_write_bytecode = True

import bpy
import os
import argparse
import logging
import time


def export_png(out_file, res_percent):
    bpy.context.scene.render.resolution_percentage = (res_percent*100)
    bpy.context.scene.render.filepath = out_file
    bpy.ops.render.render(write_still=True)

def main(args):
    """Searches for blend files and exports them"""
    parser = argparse.ArgumentParser("Converts lots of blend files")
    parser.add_argument('--resolution', help="Resolution Multiplier", type=float)
    config = parser.parse_args(args)


    prefix = bpy.data.filepath.split('.')[0]
    outimage = prefix + '.png'
    export_png(outimage, config.resolution)



def run_function_with_args(function):
    '''Finds the args to the python script rather than to blender as a whole
    '''
    try:
        arg_pos = sys.argv.index('--') + 1
        function(sys.argv[arg_pos:])
        sys.exit(0)
    except Exception as e:
        logging.exception(e)
        sys.exit(1)


run_function_with_args(main)
