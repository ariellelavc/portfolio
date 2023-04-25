# Python program to demonstrate
# use of Factory method design pattern


class ChromosomalInstabilityIndexAnalysis:
    def __init__(self):
        self.analysis_type = self.__class__.__name__
        self.data = ['cin_matrix', 'cin_clinical_cohort1', 'cin_clinical_cohort2']

    def run(self):
        return f'Running a {self.analysis_type} using {self.data} input data.'


class PrincipalComponentAnalysis:

    def __init__(self):
        self.analysis_type = self.__class__.__name__
        self.data = ['pca_matrix', 'pca_clinical_cohort1', 'pca_clinical_cohort2']

    def run(self):
        return f'Running a {self.analysis_type} using {self.data} input data.'


class HierarchicalClusteringAnalysis:

    def __init__(self):
        self.analysis_type = self.__class__.__name__
        self.data = ['hc_matrix', 'hc_clinical_cohort1', 'hc_clinical_cohort2']

    def run(self):
        return f'Running a {self.analysis_type} using {self.data} input data.'


class ClassComparisonAnalysis:

    def __init__(self):
        self.analysis_type = self.__class__.__name__
        self.data = ['cc_matrix', 'cc_clinical_cohort1', 'cc_clinical_cohort2']

    def run(self):
        return f'Running a {self.analysis_type} using {self.data} input data.'


def analysis_factory(analysis_type='pca'):

    """Factory method"""
    analyses = {
        'cin': ChromosomalInstabilityIndexAnalysis,
        'pca': PrincipalComponentAnalysis,
        'hc': HierarchicalClusteringAnalysis,
        'cc': ClassComparisonAnalysis
    }

    return analyses[analysis_type]()


if __name__ == '__main__':
    cin = analysis_factory('cin')
    pca = analysis_factory('pca')

    print(cin.run())
    print(pca.run())
