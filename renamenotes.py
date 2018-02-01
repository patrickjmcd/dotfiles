#!/usr/bin/python3

from os import listdir, rename
from sys import argv
from os.path import isfile, join, isdir


def add_dash_to_dates(folder_path):
    """Add a dash between parts of the date for all items in a folder."""
    only_files = [f for f in listdir(folder_path) if isfile(join(folder_path, f))]
    for f in only_files:
        try:
            int(f[0:8])
            current_filepath = join(folder_path, f)
            rest_of_filename = f[8:]
            new_date = f[0:4] + "-" + f[4:6] + "-" + f[6:8]
            new_filepath = join(folder_path, new_date + rest_of_filename)
            rename(current_filepath, new_filepath)
            print("Renamed {} to {}".format(current_filepath, new_filepath))
        except ValueError:
            pass
    print("All files have been renamed!")


if __name__ == '__main__':
    if isdir(argv[1]):
        add_dash_to_dates(argv[1])
    else:
        print("The specified folder is not a directory... Try again...")
