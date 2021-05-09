A simple command-line app that configures a wallpaper slideshow in GNOME environment.

Usage: gnome_wallpaper_slideshow [path_to_images_folder] [name_for_slideshow] [duration_for_each_wallpaper] [duration_for_transition_between_wallpapers]

Example:  gnome_wallpaper_slideshow ~/Pictures/Wallpapers my_slideshow 2700 5

How it works:
1. Checks given folder for image files (including: png, jpg, xcf and svg).
2. Creates a new or rewrite existing .xml file with a list of images and transitions in directory with said images.
3. Creates a new or adds to existing .xml file with a list of wallpaper slideshows (each of can be selected in GNOME Settings → Background).