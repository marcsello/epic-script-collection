# new
Creates a new file, and adds a shebang to it, definied by the user, or based on the extension of the file.

Designed and tested on Debian 9.4
 
### Download:
To download only this single script, use this link:   
https://raw.githubusercontent.com/marcsello/epic-script-collection/master/new.sh

*It is recommended to place it to /usr/local/bin/new (no extensions) so you can use it as a shell command*
 
### Supported shebangs:
- python3
- bash      
*perl and python2 will be added*

### Usage:
#### Simple:
`new yolo.py`   
Creates a new file named `yolo.py` with python3 shebang added, and opens it in nano

#### User defined shebang:
`new bash superscript`    
Creates a new file named `superscript` with bash shebang 

#### Batch:
`new python asd.py yolo.py test.py`    
Creates 3 new files: `asd.py`, `yolo.py` and `test.py` all initialized with python3 shebang
