---
title: 发布自己的软件包到pypi
date: 2019-04-24 01:48:32
tags:
- Python
categories:
- Python
---

### Make your code pulish-ready

首先准备好即将发布的软件包，并且保证没有任何无关的代码或者那些无关的代码在`if __name__ == '__main__':`下，并且确保你的软件包下面有`__init__.py`文件

### Create a PyPi account

在PyPi官网注册用户即可

### Create the files PyPi needs

PyPi 需要三个文件：

- setup.py
- setup.cfg
- LICENSE.txt
- README.md(可选但是强烈推荐)

#### setup.py

```Python

from distutils.core import setup
setup(
  name = 'YOURPACKAGENAME',         # How you named your package folder
  packages = ['YOURPACKAGENAME'],   # Chose the same as "name"
  version = '0.1',      # Start with a small number and increase it with every change you make
  license='MIT',        # Chose a license from here: https://help.github.com/articles/licensing-a-repository
  description = 'TYPE YOUR DESCRIPTION HERE',   # Give a short description about your library
  author = 'YOUR NAME',                   # Type in your name
  author_email = 'your.email@domain.com',      # Type in your E-Mail
  url = 'https://github.com/user/reponame',   # Provide either the link to your github or to your website
  download_url = 'https://codeload.github.com/oouxx/reponame/tar.gz(zip)/version num',    # you should git tag your code and git push it.
  keywords = ['SOME', 'MEANINGFULL', 'KEYWORDS'],   # Keywords that define your package best
  install_requires=[
          '',
          ''
      ],
  classifiers=[
    'Development Status :: 3 - Alpha',      # Chose either "3 - Alpha", "4 - Beta" or "5 - Production/Stable" as the current state of your package
    'Intended Audience :: Developers',      # Define that your audience are developers
    'Topic :: Software Development :: Build Tools',
    'License :: OSI Approved :: MIT License',   # Again, pick a license
    'Programming Language :: Python :: 3',      #Specify which pyhton versions that you want to support
    'Programming Language :: Python :: 3.4',
    'Programming Language :: Python :: 3.5',
    'Programming Language :: Python :: 3.6',
  ],
)
```

#### setup.cfg

```ini
# Inside of setup.cfg
[metadata]
description-file = README.md
```

#### LICENSE.txt

```txt
MIT License
Copyright (c) 2019 YOUR NAME
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### Create `.pypirc` file in your home dir

```ini
[distutils]
index-servers=pypi

[pypi]
repository= https://upload.pypi.org/legacy/
username=your pypi username
password=yout pypi password
```

### Upload your package to PyPi

```bash
cd your_package_path
python setup.py sdist
pip install twine # tool to upload your code
twine upload dist/*
```

### Change your package

一旦你改变你的代码你可以用下面命令更新你的软件包,不过在那之前记得至少修改setup.py里面的版本号和下载链接

```bash
python setup.py sdist
twine upload dist/*
```
