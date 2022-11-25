#!/usr/local/bin/python

# A program to count the number of spectra in the file

import xml.etree.ElementTree as ET
import sys, gzip, os

fn = 'Data1.mzXML.gz'
if len(sys.argv) == 2:
    fn = sys.argv[1]

print fn
fh = gzip.open(fn)
ns = '{http://sashimi.sourceforge.net/schema_revision/mzXML_2.0}'

mscount = 0
msmscount = 0
scancount = 0
precursorMz750to1000 = 0
for ev, ele in ET.iterparse(fh):
    if ev == 'end':
        if ele.tag == ns + 'msRun':
            scancount = int(ele.attrib['scanCount'])
        if ele.tag == ns + 'scan':
            if int(ele.attrib['msLevel']) == 1:
                mscount += 1
            elif int(ele.attrib['msLevel']) == 2:
                msmscount +=1
        if ele.tag == ns + 'precursorMz':
            print ele.tag, ele.text
            if float(750) <= float(ele.text) <= float(1000):
                print 'only matches'
                print ele.tag, ele.text
                precursorMz750to1000 +=1
        ele.clear()
    
print 'MS spectra', mscount
print 'MS/MS spectra', msmscount
print 'Total scan count', scancount, 'equals the sum of MS and MS/MS counts', mscount + msmscount
print 'MS/MS spectra with precursor m/z value between 750 and 1000 Da:', precursorMz750to1000
