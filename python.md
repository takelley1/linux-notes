## PYTHON

- **See also**
  - [Google style guide for Python](https://google.github.io/styleguide/pyguide.html)
  - [Replacing Bash scripts with Python](https://github.com/ninjaaron/replacing-bash-scripting-with-python)

### Reference

- Methods
  - [String methods](https://www.w3schools.com/python/python_ref_string.asp)
  - [List methods](https://www.w3schools.com/python/python_ref_list.asp)
  - [Dictionary methods](https://www.w3schools.com/python/python_ref_dictionary.asp)
  - [File methods](https://www.w3schools.com/python/python_ref_file.asp)
  - [Path methods](https://www.tutorialspoint.com/python/os_path_methods.htm)
- [Regex](https://www.w3schools.com/python/python_regex.asp)

### Useful modules

- [Python standard library](https://docs.python.org/3/library/index.html)
  - [argparse - parse command-line options](https://www.pythonforbeginners.com/argparse/argparse-tutorial)
  - [shutil - high-level file operations](https://docs.python.org/3/library/shutil.html)
  - [tempfile - create temporary files](https://docs.python.org/3/library/tempfile.html)
  - [pathlib - object-oriented path operations](https://docs.python.org/3/library/pathlib.html)
  - [glob - unix-style path expansion](https://docs.python.org/3/library/glob.html)

### Tips

`python3 -i script.py` = Run *script.py*, then launch an interactive REPL for debugging afterwards.

[Regex search.](https://www.w3schools.com/python/python_regex.asp)
```python
import re
http_proxy = "https://10.0.0.15:8080"
http_proxy_server = re.search("https?://([0-9]{1,3}.){3}[0-9]{1,3}", http_proxy)
print(http_proxy_server.group())
# https://10.0.0.15
```

[Format string.](https://www.w3schools.com/python/ref_string_format.asp)
```python
my_number = 123000
print("{:,}".format(my_number))
# 123,000
```

[Format time.](https://www.w3schools.com/python/python_datetime.asp)
```python
import datetime
print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
```

[Print substring by index.](https://www.w3schools.com/python/python_strings_slicing.asp)
```python
my_string = "Green eggs and ham."
print(my_string[6:10])
# eggs
print(my_string[6:-4])
# eggs and
print(my_string[6:])
# eggs and ham.
print(my_string[::-1])
# .mah dna sgge neerG
```

Join list items into string.
```python
my_list = ['1', '2', '3']
print(" ".join(my_list))
# 1 2 3
print("\n".join(my_list))
# 1
# 2
# 3
```

Pad string with hyphens until it's 10 characters long.
```python
my_string = "test "
print(my_string.ljust(10, "-"))
# test -----
```

[Use `_` to define an unused variable in a loop.](https://www.geeksforgeeks.org/unused-variable-in-for-loop-in-python/)
```python
for _ in range(10):
  print("*", end="")
```

### File operations

Move files to a different directory using a glob.
```python
glob_string = ("/path/to/files" + "/*.mp4")
mp4_files_destination = os.path.join("/path/to/files", "destination")
for filepath in glob.glob(glob_string):
    shutil.move(filepath, mp4_files_destination)
```

List directory.
```python
os.listdir("/path/to/directory")
```

List directories recursively.
```python
for rootpath, dirs, files in os.walk("/path/to/directory"):
    for dirname in dirs:
        print(os.path.join(rootpath, dirname))
```

Read a file.
```python
with open("/path/to/file") as f:
    content = f.readlines()
```

Get path depth.
```python
for path, dirs, files in os.walk(auto_screenshots_dir):
    print(path.count)
    if path.count(os.sep) >= 10:
        print(os.path.join(path))
```

### Web

- [Write URL content to a file.](https://docs.python.org/3.3/library/urllib.request.html#urllib.request.urlretrieve)

### Pip

- Disregard SSL certificates when installing pytest:
```bash
pip \
  --trusted-host pypi.org \
  --trusted-host pypi.python.org \
  --trusted-host files.pythonhosted.org \
  install pytest
```

### Venv

- `python3 -m venv my_env` = Create a virtual environment called *my_env*
- `source my_env/bin/activate` = Activate the virtual environment called *my_env*.
