#!/usr/bin/env zsh

# ~/aws.sh

# Removed user's cached credentials
# This script might be run with .dots, which uses elevated privileges
sudo -v

log_info "------------------------------"
log_info "Setting up AWS."
log_info "This script requires pip and virtualenvwrapper to be installed."
log_info "See the pydata.sh script."

log_info "------------------------------"
log_info "Source virtualenvwrapper from ~/.extra"
log_info ~/.extra

###############################################################################
# Python 2 Virtual Enviroment                                                 #
###############################################################################

echo "------------------------------"
echo "Updating py2-data virtual environment with AWS modules."

# Create a Python2 data environment
# If this environment already exists from running pydata.sh,
# it will not be overwritten
mkvirtualenv py2-data
workon py2-data

pip install boto
pip install awscli

EXTRA_PATH=~/.extra
echo $EXTRA_PATH
echo "" >> $EXTRA_PATH
echo "" >> $EXTRA_PATH
echo "# Configure aws cli autocomplete, added by aws.sh" >> $EXTRA_PATH
echo "complete -C '~/.virtualenvs/py2-data/bin/aws_completer' aws" >> $EXTRA_PATH
source $EXTRA_PATH

###############################################################################
# Python 3 Virtual Enviroment                                                 #
###############################################################################

echo "------------------------------"
echo "Updating py3-data virtual environment with AWS modules."

# Create a Python3 data environment
# If this environment already exists from running pydata.sh,
# it will not be overwritten
mkvirtualenv --python=/usr/local/bin/python3 py3-data
workon py3-data

pip install boto
pip install awscli
#pip install mrjob  # Python 2 only
#pip install s3cmd  # Python 2 only

# Uncomment if you want to hook up the aws cli autocomplete for Python 3
#EXTRA_PATH=~/.extra
#echo $EXTRA_PATH
#echo "" >> $EXTRA_PATH
#echo "" >> $EXTRA_PATH
#echo "# Configure aws cli autocomplete, added by aws.sh" >> $EXTRA_PATH
#echo "complete -C '~/.virtualenvs/py3-data/bin/aws_completer' aws" >> $EXTRA_PATH
#source $EXTRA_PATH


echo "------------------------------"
echo "TODO: Update .aws/ with your AWS credentials and region, or run aws --configure."
echo "TODO: Update .mrjob.conf with your credentials, keypair, keypair location, region, and bucket info."
echo "TODO: Update .s3cfg with your credentials, location, and passphrase or run s3cmd --configure."
echo "Script completed."