## [Compression](https://clearlinux.org/news-blogs/linux-os-data-compression-options-comparing-behavior)

- **See also:**
  - [Squash compression benchmark](https://quixdb.github.io/squash-benchmark/#results)
  - [ZFS zstd compression comparison](https://docs.google.com/spreadsheets/d/1TvCAIDzFsjuLuea7124q-1UtMd0C9amTgnXm2yPtiUQ/edit#gid=1215810192)

### Tar

- `tar xzvf myarchive.tar.gz` = Extract myarchive.tar.gz to current path (*xtract ze v'ing files*).
  - `x` = Extract.
  - `z` = Decompress with gzip (only works with extracting *tar.gz* or *.tgz* tarballs).
  - `v` = Be verbose.
  - `f` = Work in file mode (rather than tape mode).
<br><br>
- `tar czvf myarchive.tar.gz dir1/ dir2/` = Create *myarchive.tar.gz* from *dir1* and *dir2*
                                            (*create ze v'ing files*).

### [7zip](https://sevenzip.osdn.jp/chm/cmdline/index.htm)

- `7za x myarchive.7z` = Extract *myarchive.7z* to current path (DO NOT USE THE 'e' SWITCH, USE 'x' INSTEAD TO PRESERVE FILEPATHS).
<br><br>
- `7za a -mx=10 myarchive.7z dir1/ dir2/` = Create *myarchive.7z* from *dir1* and *dir2*.
  - `-mx=9` = Use max compression level.
  - `-myx=9` = Use max analysis level.

- [Settings for maximum compression:](https://superuser.com/a/1449735)
  ```bash
  7z a -t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0 myarchive.7z dir/
  ```

### Misc

[BtrFS compression benchmarks](https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git/commit/?h=next&id=5c1aab1dd5445ed8bdcdbb575abc1b0d7ee5b2e7)
| Method  | Ratio | Compress MB/s | Decompress |
|---------|-------|---------------|------------|
| None    |  0.99 |           504 |        686 |
| lzo     |  1.66 |           398 |        442 |
| zlib    |  2.58 |            65 |        241 |
| zstd 1  |  2.57 |           260 |        383 |
| zstd 3  |  2.71 |           174 |        408 |
| zstd 6  |  2.87 |            70 |        398 |
| zstd 9  |  2.92 |            43 |        406 |
| zstd 12 |  2.93 |            21 |        408 |
| zstd 15 |  3.01 |            11 |        354 |

| compression algorithms | gzip | bzip2 | xz | lzip | lzma | zstd |
|------------------------|------|-------|----|------|------|------|
| Released               |      |       |    |      |      |      |
| Compression speed      |      |       |    |      |      |      |
| Decompression speed    |      |       |    |      |      |      |
| Compression ratio      |      |       |    |      |      |      |

| Archive formats | tar | zip | 7z | tar.gz |
|-----------------|-----|-----|----|--------|
|                 |     |     |    |        |
