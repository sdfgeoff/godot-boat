# This file is run inside blender, it opens each of the passed in files and
# exports it to the type specified in the render output panel
import sys
sys.dont_write_bytecode = True

import bpy
import os
import logging
import time

ESCN_PATH = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
)
sys.path = [ESCN_PATH] + sys.path  # Ensure exporter from this folder
from io_scene_godot import export


def export_escn(out_file):
	"""Fake the export operator call"""
	res = export(out_file, {})



def main():
    """Searches for blend files and exports them"""
    outfile = bpy.data.filepath.replace('.blend', '')
    export_escn(outfile)
    exit(0)

main()
