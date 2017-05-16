# jifu - Just It File Uploader

### SETUP

In `config.yml`, write your username, password and full name (for your personal folder on the VLE). All these options can be changed at the command line too.

Please also create the folder you want to upload to on the VLE, under 'Evidence Portfolio'.


### Installation

First download [chromedriver](https://sites.google.com/a/chromium.org/chromedriver/downloads) and install it by including it in a folder in your PATH. (I recommend creating a new folder eg `~/bin` and adding that to your PATH.)
This is required for the automated browser operation done by this script.

Then, clone this repo into a folder of your choice and run `bundle install` in said folder.


### To run

When running jifu you will need to specify all the files you wish to upload and specify the folder under 'Evidence Portfolio' that you want to upload to.

#### Usage example

`ruby jifu.rb -f 2017-04-Apr screenshot.png screenshot-2.png some-document.docx`
