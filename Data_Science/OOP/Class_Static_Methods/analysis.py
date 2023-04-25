# Python program to demonstrate
# use of class and static methods
from datetime import datetime


class Analysis:
    def __init__(self, analysis_type):
        self.analysis_type = analysis_type

    def __repr__(self):
        return f'{self.analysis_type}Analysis Requested'

    @classmethod
    def cin(cls):
        return cls('ChromosomalInstabilityIndex')

    @classmethod
    def pca(cls):
        return cls('PrincipalComponent')

    @classmethod
    def hc(cls):
        return cls('HierarchicalClustering')

    @classmethod
    def cc(cls):
        return cls('ClassComparison')

    @staticmethod
    def logger(info):
        print(str(datetime.now()) + ': ', info)

    @staticmethod
    def test(info):
        assert isinstance(info, Analysis), f'{info} of {info.__class__} is not an Analysis'
        print(f'Is Analysis? {isinstance(info, Analysis)}')


Analysis.test(Analysis.pca())

Analysis.logger(Analysis.pca())
Analysis.logger(Analysis.hc())

try:
    Analysis.test({'Analysis': 'PCA'})
except AssertionError as e:
    print(f'Error: ', e)


