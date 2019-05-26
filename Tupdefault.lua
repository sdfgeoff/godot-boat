tup.foreach_rule("*.escn.blend", "$(BLENDER) -b %f --python $(TOP)/Tools/export_escn.py", "%B")
tup.foreach_rule("*.png.blend", "$(BLENDER) -b %f --python $(TOP)/Tools/export_png.py -- --resolution=$(RESOLUTION)", "%B")
tup.foreach_rule("*.xcf", "$(TOP)/Tools/export_xcf.sh -f %f", "%g.png")
