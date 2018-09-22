"""
a script to publish the project to github page
steps:
1. generate html file based on org
2. copy html file to /doc
3. git push every thing in /doc
"""

import sys
import argparse
import ConfigParser
import json
import subprocess
import shutil


def main():
    """
    example:
    python3 publish.py -c publish.ini
    """
    argv = sys.argv
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--config', help='the config file')
    args = parser.parse_args()

    print args

    if 'config' not in args:
        # error 
        return


    config = ConfigParser.ConfigParser()
    config.read(args.config)


    dest_dir = config.get("DEFAULT", 'dest')
    print(dest_dir)
    print(config.get("DEFAULT", 'path'))
    path_list = json.loads(config.get("DEFAULT", 'path'))
    for path in path_list:
        # 1. generate html 
        if path.endswith('.org'):
            command = "emacs {} --batch  --eval=\"(add-to-list 'load-path \\\"~/.emacs.d/elpa/htmlize-20171017.141\\\")\"  -f org-html-export-to-html --kill".format(path)
            print(command)
            process = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
            output = process.communicate()[0].strip()

        # 2. copy to dest 
        new_path = path.replace(".org", ".html")
        print new_path
        shutil.copy(new_path, dest_dir)

    # 3. git add & publish 
    command = """cd {};
    git add ./*.html;
    git commit -m \"update html\";
    git push -f""".format(dest_dir)
    process = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
    output = process.communicate()[0].strip()

if __name__ == "__main__":
    main()


