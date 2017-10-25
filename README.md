# Galaxy-Zoo

### Running with Docker

#### Local development
`docker-compose run --service-ports galaxyzoo npm run start`

runs a local server on `http://localhost:9294/`

#### Build and deploy

First pull the prebuild Docker image (to save yourself some build time) and then
build your local image:

```
docker pull zooniverse/galaxy-zoo
docker-compose build
```

Deploy to https://galaxyzoo.org/beta for testing:

```
docker-compose run galaxyzoo npm run deploy-to-staging
```

Deploy CSS and JavaScript:

```
docker-compose run galaxyzoo npm run deploy quick
```

Full deploy (including images and other assets):

```
docker-compose run galaxyzoo npm run deploy
```

### Installation and Getting Started

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

### Translations

Galaxy Zoo uses our APIs built-in translation management for storing, and serving localized strings. The interface to add translations is available at http://translations.zooniverse.org/, though you need to be a registered dev/translator to save any changes.

#### What do I do when I add new text to the site

The way our translations system works is we store a canonical en-us version of the language strings both within the repo and remotely in a database. When changes are made to the local copy, we need to update the remote copy, so we can tell what text for languages other than en-us are out of date, missing, or otherwise need attention.

To do what, you need to either POST the current translations to the API manually, or use the https://github.com/parrish/translator-seed/ module that Michael wrote for convenience. A proper command to upload new translations to the site is conveniently provided as an npm script, runnable by `npm run seed-locale`. For the system to accept your upload, you must have an OUROBOROS_AUTH env. variable set (see https://github.com/parrish/translator-seed/issues/2 for details on what that expects) and your account must be tagged as a developer.

### License

Apache 2.

Zooniverse Galaxy Zoo translations not contained within this repo are also licensed under Apache 2.

### Troubleshooting

* If you encounter issues with the Ruby builds, ensure that you are using node version no later than 0.11.14. The [n](https://www.npmjs.com/package/n) package can help with this. This is because the path.existsSync function was removed in 0.12. Example:
```bash
npm install nvm
. ~/nvm/nvm.sh

nvm install v0.10
nvm use v0.10
```
* Also ensure that you have [SSH access for github](https://help.github.com/articles/generating-ssh-keys/) set up.
* Ensure that you are running the ```hem``` command from the local path (```./node_modules/.bin/hem```), rather than any global version when starting ```hem server```.

