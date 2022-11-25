from pathlib import Path
from collections import namedtuple


def load_config(config_filename):
    config_filename = config_filename
    config_file = Path(__file__).parent / config_filename

    if config_file.exists():
        with open(config_file) as f:
            lines = [line.split("=") for line in f.readlines()]
            entries = {key.strip():value.strip() for key, value in lines}
            Config = namedtuple('Config', ['webservice_url', 'dataset'])
            # convert the entries dictionary to a Config
            config = Config('','')
            return config._replace(**entries)
    else:
        raise IOError("Config file not found")

