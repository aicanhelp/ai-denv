### 1、分合文件
分十份：
split -n 10 bigfile.txt smallfile_prefix_
cat smallfile_prefix_* > bigfile.txt