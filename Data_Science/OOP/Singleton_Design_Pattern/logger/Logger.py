# Python program exemplifying Singleton pattern
# through use of metaclass inheritance
# Implementation of a Logger

import logging
import datetime
import os
from Validator import validate


class Singleton(type):
    def __init__(self, *args, **kwargs):
        self.__instance = None
        super().__init__(*args, **kwargs)

    def __call__(self, *args, **kwargs):
        if self.__instance is None:
            self.__instance = super().__call__(*args, **kwargs)
            return self.__instance
        else:
            return self.__instance


class Logger(metaclass=Singleton):
    def __init__(self):
        self._logger = logging.getLogger('simple')
        self._logger.setLevel(logging.DEBUG)
        formatter = logging.Formatter('%(asctime)s \t [%(levelname)s | %(filename)s:%(lineno)s] > %(message)s')

        now = datetime.datetime.now()
        dir_name = "./log"

        if not os.path.isdir(dir_name):
            os.mkdir(dir_name)
        file_handler = logging.FileHandler(dir_name + "/log_" + now.strftime("%Y-%m-%d") + ".log")

        stream_handler = logging.StreamHandler()

        file_handler.setFormatter(formatter)
        stream_handler.setFormatter(formatter)

        self._logger.addHandler(file_handler)
        self._logger.addHandler(stream_handler)

    def log(self, level: int = 1, message: str =''):
        @validate(int, str)
        def enforce_types(level, message):
            return level, message

        level, message = enforce_types(level, message)

        logger_actions = {
            logging.INFO: self._logger.info,
            logging.DEBUG: self._logger.debug,
            logging.ERROR: self._logger.error,
            logging.CRITICAL: self._logger.critical
        }

        # Call the logger action mapping function based on level received as key
        #logger_actions[level](message)
        logger_actions.get(level,self._logger.debug)(message)


if __name__ == '__main__':
    logger = Logger()
    logger1 = Logger()
    print(logger is logger1)

    logger.log(logging.INFO, 'I Logger am a singleton')
    logger.log(logging.DEBUG, 'I Logger bug alert')
    logger.log(logging.ERROR, 'I Logger error alert')
    logger.log(logging.CRITICAL, 'I Logger critical error alert')

    logger1.log(logging.INFO, 'I Logger am still a singleton')
    logger1.log(logging.DEBUG, 'I Logger bug alert')
    logger1.log(logging.ERROR, 'I Logger error alert')
    logger1.log(logging.CRITICAL, 'I Logger critical error alert')

    logger.log(1)
    logger.log('str')
    logger.log()
    logger.log(dict(), set())


