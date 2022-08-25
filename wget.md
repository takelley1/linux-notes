## [Wget](https://www.gnu.org/software/wget/manual/wget.html)

```bash
wget                            \
  -A "*.pdf"                    \ # Only keep PDF files.
  -e robots=off                 \ # Ignore robots.txt files.
  --no-check-certificate        \ # Ignore HTTPS cert errors.
  --limit-rate=100k             \ # Limit download speed to 100 KB/s.
  --recursive                   \ # Descend into all subdirectories.
  --level=25                    \ # Descend into a maximum of 25 subdirectories.
  --no-clobber                  \ # Don't overwrite existing files.
  --page-requisites             \ # Download all files required to display each page properly.
  --html-extension              \ # Explicitly add .html extensions to relevant files.
  --convert-links               \ # Convert http:// to file:// links for offline browsing.
  --restrict-file-names=windows \ # Escape control characters in filenames.
  --no-parent                   \ # Don't include directories above the path provided.
  www.website.org/
  www.website2.org/

  --span-hosts                    # Let wget traverse multiple domains.
  -nv                             # Non-verbose.
  --wait=1                        # Wait 1 second after each request.

wget -A "*.pdf" -e robots=off --no-check-certificate --level=25 --limit-rate=100k --recursive --no-clobber --page-requisites --html-extension --convert-links --restrict-file-names=windows --no-parent www.website.org www.website2.org
```
