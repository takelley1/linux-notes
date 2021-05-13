
## PYTHON

- **See also**
  - [Google style guide for Python](https://google.github.io/styleguide/pyguide.html)

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
  - [shutil - high-level file operations](https://docs.python.org/3/library/shutil.html)
  - [tempfile - create temporary files](https://docs.python.org/3/library/tempfile.html)

### File operations

Loop through directories
```python
for rootpath, dirs, files in os.walk("/path/to/directory"):
    for dirname in dirs:
        print(os.path.join(rootpath, dirname))
```

Read a file:
```python
# Read
with open(filename) as f:
    content = f.readlines()
```

Get path depth
```python
for path, dirs, files in os.walk(auto_screenshots_dir):
    print(path.count)
    if path.count(os.sep) >= 10:
        print(os.path.join(path))
```

### Web

- [Write URL content to a file](https://docs.python.org/3.3/library/urllib.request.html#urllib.request.urlretrieve)

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

- `cd ~/project/path/venv/ && source activate` = Activate virtual environment.
