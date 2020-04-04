#!/usr/bin/env bash

# ~/pydata.sh
sudo -v

log_info "Configuring Python 3"

# Install virtual environments globally
# It fails to install virtualenv if PIP_REQUIRE_VIRTUALENV was true
# Python Dev Environment docs
# https://jacobian.org/2019/nov/11/python-environment-2020/
pip3 install virtualenv

pyenv install 3.8.2
pyenv global 3.8.2
pyenv shell 3.8.2

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
pip install bokeh
pip install Flask
pip install sqlalchemy
#pip install mysql-python  # Python 2 only, use mysqlclient instead
pip install mysqlclient


log_info "------------------------------"
log_info "Script completed."
log_info "Usage: workon py3-data for Python3"


# Make sure we have the latest version
pip install --upgrade pip

# Install packages
pip install --upgrade autopep8
pip install --upgrade glances # https://nicolargo.github.io/glances/
pip install --upgrade jedi
pip install --upgrade mkdocs
pip install --upgrade mkdocs-material
pip install --upgrade numpy
pip install --upgrade pandas
pip install --upgrade pyflakes
pip install --upgrade pylint
pip install --upgrade python-language-server
pip install --upgrade scipy
pip install --upgrade sphinx
pip install --upgrade yapf
