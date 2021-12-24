#!/bin/bash

export http_proxy=""
export https_proxy=""
# chmod -R 777 /usr/local/lib/node_modules
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 16.13.1
nvm use 16.13.1
nvm alias default 16.13.1
npm install -g express
npm link express

#Run this command manually as root user.
#chmod -R ugo+rw /usr/local/lib/node_modules
