rails new CET -d mysql -m http://jruby.org/rails3.rb

cat gemlist.sss | python -c "import sys;import re; from itertools import chain; l=sys.stdin.readlines();x=[ [ ' install --no-ri --no-rdoc ' + line[:-1][:line.index(' ')] + ' --version ' +k for k in line[line.index('(')+1:line.index(')')].split(',')]   for line in l]; print '\n'.join(item for item in chain(*x))" | xargs -L 1 -t gem
