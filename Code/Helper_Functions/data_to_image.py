#! /usr/bin/python
import os, sys

if len(sys.argv) < 2:
    """
	print '\nExample usage:\n'
    print '    ./data_to_image 1,4,2,5,7,7\n'
    print 'Downloads an image of a chess position with the white king on square'
    print '(1,4), the white rook on square (2,5), and the black king on square'
    print '(7,7).\n'
	"""
    exit()

position = sys.argv[1].split(',')
position = [int(i) for i in position]
pieces = {0:'K', 1:'R', 2:'k'}

fen = ''
for i in range(8,0,-1):
    offset = 1
    for j in range(1,9):
        for k in range(3):
            if position[k*2] == j and position[k*2+1] == i:
                if j - offset != 0:
                    fen += str(j - offset)
                fen += str(pieces[k])
                offset = j + 1
    if 9 - offset != 0:
        fen += str(9 - offset)
    fen += '/'

url = 'http://www.eddins.net/steve/chess/ChessImager/ChessImager.php?fen='+fen
os.system('wget ' + url)
dir_contents = os.listdir('.')
prefix = 'ChessImager.php?fen='
img_name = [i for i in dir_contents if i[:len(prefix)] == prefix][0]
os.system('mv %s position.png' % img_name)

"""
print 'Saved image as position.png'
print 'Pulled image from:'
print ' %s' % url
"""