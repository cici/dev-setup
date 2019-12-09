#!/usr/bin/env bash

# ~/pydata.sh

# Removed user's cached credentials
# This script might be run with .dots, which uses elevated privileges
sudo -v

log_info "------------------------------"
log_info "Setting up pip."

# Download and install pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py

###############################################################################
# Virtual Enviroments                                                         #
###############################################################################

log_info "------------------------------"
log_info "Setting up virtual environments."

# Install virtual environments globally
# It fails to install virtualenv if PIP_REQUIRE_VIRTUALENV was true
# Python Dev Environment docs
# https://jacobian.org/2019/nov/11/python-environment-2020/
brew install pyenv
pyenv install 3.8.0
pyenv global 3.8.0

#export PIP_REQUIRE_VIRTUALENV=false
#pip install virtualenv
#pip install virtualenvwrapper

log_info "------------------------------"
log_info "Source virtualenvwrapper from ~/.extra"

EXTRA_PATH=~/.extra
log_info $EXTRA_PATH
log_info "" >> $EXTRA_PATH
log_info "" >> $EXTRA_PATH
log_info "# Source virtualenvwrapper, added by pydata.sh" >> $EXTRA_PATH
log_info "export WORKON_HOME=~/.virtualenvs" >> $EXTRA_PATH
log_info "source /usr/local/bin/virtualenvwrapper.sh" >> $EXTRA_PATH
log_info "" >> $BASH_PROFILE_PATH
source $EXTRA_PATH


###############################################################################
# Python 3 Virtual Enviroment                                                 #
###############################################################################

log_info "------------------------------"
log_info "Setting up py3-data virtual environment."

# Create a Python3 data environment
mkvirtualenv --python=/usr/local/bin/python3 py3-data
workon py3-data

# Install Python data modules
pip install numpy
pip install scipy
pip install matplotlib
pip install pandas
pip install sympy
pip install nose
pip install unittest2
pip install seaborn
pip install scikit-learn
pip install "ipython[all]"
pip install bokeh
pip install Flask
pip install sqlalchemy
#pip install mysql-python  # Python 2 only, use mysqlclient instead
pip install mysqlclient

pip install glances  # https://nicolargo.github.io/glances/

###############################################################################
# Install IPython Profile
###############################################################################

log_info "------------------------------"
log_info "Installing IPython Notebook Default Profile"

# Add the IPython profile
mkdir -p ~/.ipython
cp -r init/profile_default/ ~/.ipython/profile_default

log_info "------------------------------"
log_info "Script completed."
log_info "Usage: workon py3-data for Python3"

pip install glances