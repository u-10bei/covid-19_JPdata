import os
from datetime import datetime

os.chdir(os.path.dirname(os.path.abspath(__file__)))
# Commit comment
now = datetime.now()
comment = datetime.now().strftime("%Y/%m/%d-%H:%M:%S")

# Push
os.system('git add .')
os.system('git commit -m {}'.format(comment))
os.system('git push --all origin')