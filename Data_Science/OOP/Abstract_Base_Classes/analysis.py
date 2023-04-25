# Python program to demonstrate
# use of Abstract Base Class pattern

from abc import ABCMeta, abstractmethod


class Analysis(metaclass=ABCMeta):

    @abstractmethod
    def run(self, analysis_request):
        pass

    @property
    @abstractmethod
    def analysis_result(self):
        pass

    @analysis_result.setter
    @abstractmethod
    def analysis_result(self, value):
        pass


class ChromosomalInstabilityIndexAnalysis(Analysis):

    def __init__(self):
        self._analysis_result = None

    # overriding abstract method
    def run(self, analysis_request):
        self.analysis_result = 'result'
        return self.analysis_result

    # overriding abstract property
    @property
    def analysis_result(self):
        print('in getter')
        return self._analysis_result

    # overriding abstract property setter
    @analysis_result.setter
    def analysis_result(self, value):
        print('in setter')
        self._analysis_result = value


if __name__ == '__main__':
    cin = ChromosomalInstabilityIndexAnalysis()

    print(cin.run(['request']))
