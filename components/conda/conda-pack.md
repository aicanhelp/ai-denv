conda-forge:

 conda install -c conda-forge conda-pack
PyPI:

 pip install conda-pack


打包一个环境：
```
# Pack environment my_env into my_env.tar.gz
conda pack -n my_env

# Pack environment my_env into out_name.tar.gz
conda pack -n my_env -o out_name.tar.gz

# Pack environment located at an explicit path into my_env.tar.gz
conda pack -p /explicit/path/to/my_env
```

重现环境：
```
# Unpack environment into directory `my_env`
mkdir -p my_env
tar -xzf my_env.tar.gz -C my_env

# Use Python without activating or fixing the prefixes. Most Python
# libraries will work fine, but things that require prefix cleanups
# will fail.
./my_env/bin/python

# Activate the environment. This adds `my_env/bin` to your path
source my_env/bin/activate

# Run Python from in the environment
(my_env) $ python

# Cleanup prefixes from in the active environment.
# Note that this command can also be run without activating the environment
# as long as some version of Python is already installed on the machine.
(my_env) $ conda-unpack
```