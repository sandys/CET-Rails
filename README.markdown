rails new CET -d mysql -m http://jruby.org/rails3.rb

Setting up your devel environment
=================================

 sudo -u postgres psql
 create user cet with password 'cet123';
 create database cet_db;
  grant all privileges on database cet_db to cet;

cat gemlist.sss | python -c "import sys;import re; from itertools import chain; l=sys.stdin.readlines();x=[ [ ' install --no-ri --no-rdoc ' + line[:-1][:line.index(' ')] + ' --version ' +k for k in line[line.index('(')+1:line.index(')')].split(',')]   for line in l]; print '\n'.join(item for item in chain(*x))" | xargs -L 1 -t gem
bundle install
rake db:create
rake db:migrate

