# Galaxy-Zoo

### Getting Started
```bash
git clone https://github.com/zooniverse/Galaxy-Zoo.git
cd Galaxy-Zoo
npm install .

./fits/build.rb
./interactive/build.rb

hem server
open http://localhost:9294/
```

### Bootstrapping an Ubuntu machine from scratch

##### Install Node.js
```bash
sudo apt-get install curl git python-software-properties python build-essential -y
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update && sudo apt-get dist-upgrade -y
sudo apt-get install nodejs -y
```

##### Install Ruby
```bash
curl -L https://get.rvm.io | bash
source ~/.bash_profile
rvm install 1.9.3 && source ~/.bash_profile && rvm use 1.9.3 --default
```


##### Setup Galaxy Zoo
```bash
echo 'PATH="./node_modules/.bin:${PATH}"' >> ~/.bash_profile
echo 'export PATH' >> ~/.bash_profile
source ~/.bash_profile
git clone https://github.com/zooniverse/Galaxy-Zoo.git
cd Galaxy-Zoo
npm install .
hem server
open http://localhost:9294
```

Depending on your browser, you may have to confirm a security exception to allow a self-signed SSL certificate for dev.zooniverse.org

### License

Apache 2.

Zooniverse Galaxy Zoo translations not contained within this repo are also licensed under Apache 2.

### Troubleshooting

If you encounter issues, ensure that you are using node version 0.10.x. The [n](https://www.npmjs.com/package/n) package can help with this. Also ensure that you have [SSH access for github](https://help.github.com/articles/generating-ssh-keys/) set up.
