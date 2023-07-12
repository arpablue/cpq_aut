import sys
import os

import json

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','obj','BaseObj')
sys.path.append( src_path )

from BaseObj import BaseObj


class QuoteObj( BaseObj ):
    pass
