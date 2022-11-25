import os
import glob
from numpy import *
import scipy as sp
from scipy import stats

class Sample():
    def __init__(self, name=""):
        self.name = name

qc_metrics = {'\t'.join(['Genome coverage','Gross mapping yield (Gb)','NA']):(150,),
              '\t'.join(['Genome coverage','Fully called genome fraction', 'HIGH']):(0.95,0.98),
              '\t'.join(['Exome coverage','Fully called exome fraction', 'HIGH']):(0.95,0.98),
              '\t'.join(['Genome coverage','Genome fraction where weightSumSequenceCoverage >= 40x', 'NA']):(0.55,0.85),
              '\t'.join(['Exome coverage','Exome fraction where weightSumSequenceCoverage >= 40x', 'NA']):(0.6,0.85),
              '\t'.join(['Genome variations','SNP total count', 'HIGH']):(3200000,4400000),
              '\t'.join(['Exome variations','SNP total count', 'HIGH']):(20000,30000),
              '\t'.join(['Genome variations','SNP novel fraction', 'HIGH']):(0.03,0.07),
              '\t'.join(['Exome variations','SNP novel fraction', 'HIGH']):(0.02,0.08),
              '\t'.join(['Genome variations','SNP transitions/transversions ratio', 'HIGH']):(2.05,2.18),
              '\t'.join(['Exome variations','SNP transitions/transversions ratio', 'HIGH']):(2.9,3.3),
              '\t'.join(['Genome variations','SNP heterozygous/homozygous ratio', 'HIGH']):(1.3,2.2),
              '\t'.join(['Exome variations','SNP heterozygous/homozygous ratio', 'HIGH']):(1.3,2.3)
              }

qc_metrics_labels = {'\t'.join(['Genome coverage','Gross mapping yield (Gb)','NA']): 'Genome coverage gross mapping yield (Gb)',
              '\t'.join(['Genome coverage','Fully called genome fraction', 'HIGH']): 'Genome fully called',
              '\t'.join(['Exome coverage','Fully called exome fraction', 'HIGH']): 'Exome fully called',
              '\t'.join(['Genome coverage','Genome fraction where weightSumSequenceCoverage >= 40x', 'NA']): 'Genome coverage >= 40x',
              '\t'.join(['Exome coverage','Exome fraction where weightSumSequenceCoverage >= 40x', 'NA']): 'Exome coverage >= 40x',
              '\t'.join(['Genome variations','SNP total count', 'HIGH']): 'Genome variant SNP count',
              '\t'.join(['Exome variations','SNP total count', 'HIGH']): 'Exome variant SNP count',
              '\t'.join(['Genome variations','SNP novel fraction', 'HIGH']): 'Genome novel SNP fraction',
              '\t'.join(['Exome variations','SNP novel fraction', 'HIGH']): 'Exome novel SNP fraction',
              '\t'.join(['Genome variations','SNP transitions/transversions ratio', 'HIGH']): 'Genome Ti/Tv ratio',
              '\t'.join(['Exome variations','SNP transitions/transversions ratio', 'HIGH']): 'Exome Ti/Tv ratio',
              '\t'.join(['Genome variations','SNP heterozygous/homozygous ratio', 'HIGH']): 'Genome Het/Hom ratio',
              '\t'.join(['Exome variations','SNP heterozygous/homozygous ratio', 'HIGH']):' Exome Het/Hom ratio'
              }
              
summaries = list()
categories = set()
high_conf = dict()
all_conf = dict()
na_conf = dict()
samples = dict()
stats = dict()

def parse(filename):
    handle = open(filename)

    header = ''
    sample = ''
    assembly_id = ''
    colnames = list()
    data = dict()
    row =[]

    for line in handle:
        if len(line.strip()) == 0:
            continue
        if line.startswith('#'):
            header += line
            if line.startswith('#SAMPLE'):
                sample = line.split()[1]
            elif line.startswith('#ASSEMBLY_ID'):
                assembly_id = line.split()[1]
        elif line.startswith('>'):
            colnames = line.split('\t')
        else:
            row = line.strip().split('\t')
            category_metric = row[0] + '\t' + row[1]
            value = row[2]
            confidence = row[3]
            if data.has_key(category_metric):
                metric = data[category_metric]
            else:
                metric = dict()
            metric[confidence] = value
            data[category_metric] = metric

    handle.close()
    return assembly_id, sample, header, data

def convert(v):
    try:
        value = v
        value = round(float(v),3)
        value = int(v)
    except ValueError:
        pass
    return value

def compute_metric_stats(data, confidence=0.95):
    a = 1.0*array(data)
    n = len(a)
    m, stdev = mean(a), std(a, dtype=float64, ddof=1)
    minim, maxim = min(a), max(a)
    sterr = stdev/sqrt(n)
    h = sterr * sp.stats.t.ppf((1+confidence)/2., n - 1)
    return round(minim,3), round(maxim,3), round(m,3), round(stdev,3), round(m-h,3), round(m+h,3)

def compute_all_stats():    
    for k,v in high_conf.iteritems():
        if len(v) > 0:
            stats['\t'.join([k, 'HIGH'])] = list(compute_metric_stats(v))
    for k,v in all_conf.iteritems():
        if len(v) > 0:
            stats['\t'.join([k, 'ALL'])] = list(compute_metric_stats(v))
    for k,v in na_conf.iteritems():
        if len(v) > 0:
            try:
                stats['\t'.join([k, 'NA'])] = list(compute_metric_stats(v))
            except TypeError:
                pass

def qc(category_metric_conf, value):
    qc = 'OUT OF RANGE'
    ci = ''
    nub = False
    ci_ub = 0
    try:
        try:
            ci_ub = qc_metrics[category_metric_conf][1]
        except IndexError:
            nub = True
        ci_lb = qc_metrics[category_metric_conf][0]
        ci = '(' + str(ci_lb) + ' - ' + str(ci_ub) + ')'
        if nub:
            if float(ci_lb) <= float(value):
                qc = 'IN RANGE'
        else:
            if float(ci_lb) <= float(value) <= float(ci_ub):
                qc = 'IN RANGE'
    except KeyError:
        qc = 'NA'
        pass
    return ci, qc   

def make_sample(k, v):
    sample = Sample(k)
    sd = list()
    nk = ''
    for key,val in sorted(v[2].iteritems()):
        for kk, vv in val.iteritems():
            nk = '\t'.join([key,kk])
            vars(sample)[nk] = (str(vv), qc('\t'.join([key, kk]), vv)[1]) 
    return sample

path = os.getcwd()

for filename in glob.glob(os.path.join( path, 'summary*.tsv')):
    assembly_id, sample, header, summary = parse(filename)
    samples[assembly_id] = [assembly_id, header, summary]
    summaries.append(summary)
    categories = set(summary.keys())

for cat in categories:
    high_conf[cat] = list()
    all_conf[cat] = list()
    na_conf[cat] = list()

for summary in summaries:
    for k,v in summary.iteritems():
        try:
            high_conf[k].append(convert(v['HIGH']))
            all_conf[k].append(convert(v['ALL']))
        except KeyError:
            pass
        try:
            na_conf[k].append(convert(v['NA']))
        except KeyError:
            pass
        
compute_all_stats()

#all metrics
def qc_merged_summaries():
    new_samples = list()

    for k,v in samples.iteritems():
        #print_sample_qc(k, v)
        spl = make_sample(k,v)
        new_samples.append(spl)
    
    raw_out = 'qc_merged_summaries.tsv'
    handle = open(raw_out, 'wb')
    
    hdrs = [k.replace('\t', ' ') for k in sorted(stats.keys())]
    handle.write('' + '\t' + '\t'.join(hdrs) + '\n')

    for ns in new_samples:
        rl = ''
        rl += ns.name + '\t'
        for k in sorted(stats.keys()):
            rl += vars(ns)[k][0] + '\t'
        rl += '\n'
        handle.write(rl)
        
    handle.close()

def make_stats_rows():
    min_row = 'MIN' + '\t'
    max_row = 'MAX' + '\t'
    mean_row = 'MEAN' + '\t'
    stdev_row = 'STDEV' + '\t'
    for k in sorted(qc_metrics.keys(), reverse=True):
        min_row += str(stats[k][0]) +'\t'
        max_row += str(stats[k][1]) +'\t'
        mean_row += str(stats[k][2]) +'\t'
        stdev_row += str(stats[k][3]) +'\t'
    return [min_row + '\n', max_row + '\n', mean_row + '\n', stdev_row + '\n']
        
make_stats_rows() 

#basic metrics qc
def qc_report():
    new_samples = list()

    for k,v in samples.iteritems():
        spl = make_sample(k,v)
        new_samples.append(spl)
    
    raw_out = 'qc_report.tsv'
    handle = open(raw_out, 'wb')

    hdrs = '' + '\t'
    for k in sorted(qc_metrics.keys(), reverse=True):
        hdrs += qc_metrics_labels[k] +'\t'
    handle.write(hdrs + '\n') 

    for ns in new_samples:
        rl = ''
        rl += ns.name + '\t'
        for k in sorted(qc_metrics.keys(), reverse=True):
            rl += vars(ns)[k][1] + '\t'
        rl += '\n'
        handle.write(rl)

    rl = '\nALLOWABLE RANGE' + '\t'
    for k in sorted(qc_metrics.keys(), reverse=True):
        nub = False
        ub = 0
        try:
            ub = qc_metrics[k][1]
        except IndexError:
            nub = True
        lb = qc_metrics[k][0]
        if nub:
            rl += '> ' + str(lb)
        else:
            rl += '( ' + '-'.join([str(lb), str(ub)]) + ' )'
        rl +='\t'
    rl += '\n'
    handle.write(rl)
    
    for rl in make_stats_rows():
        handle.write(rl)
    handle.close()

qc_report()

#basic metrics values
def qc_report_data():
    new_samples = list()

    for k,v in samples.iteritems():
        spl = make_sample(k,v)
        new_samples.append(spl)
    
    raw_out = 'qc_report_data.tsv'
    handle = open(raw_out, 'wb')

    hdrs = '' + '\t'
    for k in sorted(qc_metrics.keys(), reverse=True):
        hdrs += qc_metrics_labels[k] +'\t'
    handle.write(hdrs + '\n') 

    for ns in new_samples:
        rl = ''
        rl += ns.name + '\t'
        for k in sorted(qc_metrics.keys(), reverse=True):
            rl += vars(ns)[k][0] + '\t'
        rl += '\n'
        handle.write(rl)

    rl = '\nALLOWABLE RANGE' + '\t'
    for k in sorted(qc_metrics.keys(), reverse=True):
        nub = False
        ub = 0
        try:
            ub = qc_metrics[k][1]
        except IndexError:
            nub = True
        lb = qc_metrics[k][0]
        if nub:
            rl += '> ' + str(lb)
        else:
            rl += '( ' + '-'.join([str(lb), str(ub)]) + ' )'
        rl +='\t'
    rl += '\n'
    handle.write(rl)

    for rl in make_stats_rows():
        handle.write(rl)
    handle.close()

qc_report_data()




