#
# Cookbook Name:: respy
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
# Cookbook Name:: respy_development
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------

HOME_DIR = node['respy_development']['home']
USER = node['respy_development']['user']
ENV_DIR = HOME_DIR + '/.envs/'

# We have a whole set of PYTHON executables set up, which we try to keep in
# sync.
PYTHON_EXECS  = [ENV_DIR + 'restudToolbox3/bin/python']
PYTHON_EXECS += [ENV_DIR + 'restudToolbox2/bin/python']
PYTHON_EXECS += ['/usr/bin/python2', '/usr/bin/python3']

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------

include_recipe 'apt::default'

apt_packages  = ['python-dev', 'python-pip', 'python3-pip', 'gfortran', 'libatlas-dev']
apt_packages += ['libatlas-base-dev', 'git', 'libcr-dev', 'mpich', 'mpich-doc', 'python3-venv']
apt_packages += ['python-numpy', 'python-scipy', 'libfreetype6-dev', 'libfreetype6', 'pkg-config']

for package in apt_packages
    apt_package package
end

# Ensure that PYTHON executables are available with their recent releases.
python_runtime '2.7'
python_runtime '3.5'

# Create the two virtual environments which are used for the development and
# testing of the RESPY package.
python_virtualenv  ENV_DIR + 'restudToolbox3' do
  python '/usr/bin/python3'
end

python_virtualenv  ENV_DIR + 'restudToolbox2' do
  python '/usr/bin/python2'
end

directory HOME_DIR  + '/restudToolbox' do
  owner USER
  group USER
  mode '0755'
end

git HOME_DIR + '/restudToolbox/package' do
    repository 'https://github.com/restudToolbox/package.git'
end

# Install RESPY for all the PYTHON packages.
for python_exec in PYTHON_EXECS
    # TODO: Updated RESPY installation. here
    for package in ['pytest']
        python_package package do
            python python_exec
        end
    end
end

# Ensure correct ownership of the resources in the HOME directory.
execute 'home_permissions' do
  command 'chown vagrant:vagrant -R ' + HOME_DIR
  action :nothing
end
