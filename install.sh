# run this from the root of this repository: limescripts/
#
# usage:
#   ./link.sh YourTheme
#
# LimeChat will automatically load a JavaScript file with a filename that
# matches your theme. Run this to create a link to limescripts.js so
# LimeChat will load it in.
cd ..
ln -s limescripts/limescripts.js $1.js
cd limescripts

