import json
import os
import subprocess

from past.types import unicode

git_server = "http://172.20.92.53/"


def clone(fold_name, repository_name):
    cur_dir = os.path.abspath(os.curdir)
    try:
        if os.path.exists(fold_name + '/.git'):
            os.chdir(fold_name)
            print('Update: ' + fold_name + ':' + repository_name + ': in ' + os.path.abspath(os.curdir))
            subprocess.Popen(['git', 'pull']).communicate()
        else:
            if not os.path.exists(fold_name):
                os.makedirs(fold_name)
            os.chdir(fold_name)
            print('Clone: ' + fold_name + ':' + repository_name + ': in ' + os.path.abspath(os.curdir))
            subprocess.Popen(['git', 'clone', git_server + repository_name, '.']).communicate()
    except Exception as e:
        print(e)
    finally:
        os.chdir(cur_dir)
        print('Current Directory:' + cur_dir)


def run():
    with open('repositories.json', 'r') as f:
        repos = json.load(f)
        do_action(repos, '', '', clone)


def do_action(json_obj, pre_key, fold_name, func):
    if isinstance(json_obj, unicode):
        print(json_obj)
        return

    if len(fold_name) == 0:
        fold_name = pre_key
    else:
        fold_name = fold_name + '/' + str(pre_key)

    for key, value in json_obj.items():
        if isinstance(value, unicode):
            func(fold_name + "/" + key, value)
        else:
            do_action(value, key, fold_name, func)


if __name__ == '__main__':
    run()
