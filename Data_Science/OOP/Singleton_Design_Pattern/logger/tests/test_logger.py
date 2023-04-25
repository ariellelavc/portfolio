import unittest

from Logger import Logger, Singleton
import re


class TestLogger(unittest.TestCase):
    def test_isSingleton(self):
        self.assertEqual(Logger.__class__.__name__, Singleton.__name__)

    def test_oneInstance(self):
        logger_a = Logger()
        logger_b = Logger()
        self.assertIs(logger_a, logger_b)

    def test_log(self):
        logger = Logger()
        self.assertLogs(logger, 50)

    def test_log_output(self):
        logger = Logger()
        logger_output = str(logger.log(10, 'I Logger bug alert'))
        debug_in_output = str(re.match('BUG', logger_output, flags=re.IGNORECASE))
        self.assertIn(debug_in_output, logger_output)

    def test_log_signature(self):
        logger = Logger()
        logger_output = str(logger.log(dict(), set()))
        signature_check = str(re.match('Arg', logger_output, flags=re.IGNORECASE))
        self.assertIn(signature_check, logger_output)


if __name__ == '__main__':
    unittest.main()

# (venv) D:\metaclasses\logger> python -m unittest tests/test_logger.py