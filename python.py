#!/usr/bin/python
#coding=utf-8
# print "%x" % 108
# print '%f' % 1234.567890
# w, p=3, 5 #元组 
# print 'http://xx/%s/%s.html' % (w , p)
# print 3*4//3.3
# print 3*4/3.3
# print 8**2
# print 8%3
# print 2<4
# print 2<<4
# print 3<<2
# print not 3 < 2
# print not 2
# print not '1'
# print 3 < 4 > 5
# bobo = 'abc'
# print bobo
# decimal=1
# print bobo[0:2]
# alist = [1, 'a', 2, 'c']
# alist[1]=3
# print alist[0:]
# aTuple = ('robots', 77, 93, 'try')
# #aTuple[1]=3//wrong
# print aTuple[0:3]
# aDic={'chang':100, 'kuan':50}
# aDic['gao']=40
# print aDic['chang']
# x=-3
# if x < 0:
#     print 'x must be atleast 0!'.encode("utf-8").decode("utf-8")
#     print u"✓ means check".encode("utf-8").decode("utf-8")
# else:
#     print 'fuck you'

# while x < 0:
#    print 'in while' 
#    x+=1
# for item in ['a', 1, '2', 3]:
#     print item
# for item in range(3):
#     print item
# ran=range(0, 3, 1)
# foo='abc'
# for item in foo:
#     print item
# for i, ch in enumerate(foo):
#     print ch, i
# file_name='/home/wuming/xinde/v6sh/test'
# #    filename = raw_input('Enter file name: ')
# access_mode = 'r'
# content=''
# handle = open(file_name,access_mode)
# for eachLine in handle:
#     print eachLine
#     handle.close()

# def func():
#     return "Hello"
# print func()

# def addMe2Me(x):
#     'apply + operation to argument'
#     return (x + x)
# print addMe2Me(['a','b' , 'aefff'])

# class FooClass(object):
#     """my very first class: FooClass"""
#     version = 0.1 # class (data) attribute
#     def __init__(self, nm='John Doe'):
#         """constructor"""
#         self.name = nm # class instance (data) attribute
#         print 'Created a class instance for', nm
#     def showname(self):
#         """display instance attribute and class name"""
#         print 'Your name is', self.name
#         print 'My name is', self.__class__.__name__
#     def showver(self):
#        """display class(static) attribute"""
#        print self.version       # references FooClass.version
#     def addMe2Me(self, x): # does not use 'self'
#        """apply + operation to argument"""
#        return x + x

# foo1 = FooClass()
# foo1.showname()

# foo2 = FooClass("wuming")
# foo2.showname()

# from math import pi
# print 2**3*pi
# #print pow(2, 3)
# print max(3, 56, 46)
# f=max
# f
# print f(3, 5, 6)
# def t():
#     """jjj"""
#     print 'aa'
# help(t)
# def	summation(n,term,next):
#     total,	k	=	0,	1
#     while	k	<=	n:
#         total,k=total+term(k),next(k)
#     return	total
# def	cube(k):
#     return	pow(k,	3)
# def nex(k):
#     return k+1
# print summation(3,cube,nex)
# print cube(2)
# import sys
# sys.stdout.write('Hello World!\n')
# sys.stdout.writelines("aaa")
# a, b=3, 5
