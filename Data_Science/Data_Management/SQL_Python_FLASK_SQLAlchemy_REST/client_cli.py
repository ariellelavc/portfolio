# consuming Web Services by calling
# shell commands from Python

import subprocess
import config
import dataset
from argparse import ArgumentParser
import pandas as pd
import json


def parse_args():
    # Parse command-line arguments
    parser = ArgumentParser()
    parser.add_argument(dest='config_filename', metavar='config_filename',
                        help='Configuration file e.g. molecules_cli.cfg '
                             'specifying the REST API url and the dataset to use')

    args = parser.parse_args()
    return args


def create(api_url, data):
    # Define command and options
    command = 'curl'
    content_type = '"Content-Type: application/json"'
    # to_post = json.dumps(json.dumps(data))
    to_post = '"{}"'.format(json.dumps(data).replace('"', '\\"'))

    print(to_post)
    args = [command, '-i', api_url, '-X POST', '-H', content_type, '-d', to_post]

    print('Executing shell command:', ' '.join(args))
    posted = subprocess.run(args, capture_output=True)
    print(posted)
    response = posted.stdout.decode("utf-8")
    print(f'HTTP Response:\n{response}')

    return response


def retrieve(api_url, *rid):
    if rid:
        api_url = '/'.join([api_url, str(rid[0])])

    # Define command and options
    command = 'curl'
    args = [command, '-i', api_url]
    '''args = []
    args.append(command)
    # Add options
    args.append('-i')
    args.append(api_url)'''

    print('Executing shell command:', ' '.join(args))
    fetched_all = subprocess.run(args, capture_output=True)
    response = fetched_all.stdout.decode("utf-8")
    print(f'HTTP Response:\n{response}')

    return response


def view(response):
    df = pd.read_json(response.split('\r\n\r\n')[-1])
    print(df.to_string(index=False))


def main():
    """The main entry point of a client program
    communicating with/consuming a REST Webservice API"""

    # Parse command-line arguments
    args = parse_args()

    # Get the settings for the program
    settings = config.load_config(args.config_filename)
    api_url = settings.webservice_url
    dataset_fn = settings.dataset

    # Load the data to be consumed by the webservice
    data = dataset.load_data(dataset_fn)
    print(data)

    # Create request/response
    print('Posting data...')
    for record in data:
        print(record)
        response = create(api_url, record)

    # Retrieve request/response
    print('Getting all data...')
    response = retrieve(api_url)

    print('Visualizing the data...')
    view(response)

    print('Getting last record...')
    response = retrieve(api_url, 5)


    '''print('Updating a record...')
    # trying to update the first record using the data in the last record (data[-1])
    # the request will fail with 500 internal server error
    # due to sqlite3.IntegrityError: UNIQUE constraint failed: molecule.name
    updated = update(api_url, 1, data[-1])

    if updated[1] == 500:
        print(f'HTTP Response: IntegrityError: UNIQUE constraint failed: molecule.name, HTTP Status: {updated[1]}')
    else:
        print(f'HTTP Response: {updated[0]}, HTTP Status: {updated[1]}')

    # to do: streamline exception handling for CRUD operations

    print('Updating a record...')
    ff = fetched_first[0].copy()
    ff['name'] = '70126'
    ff['smiles'] = 'FC(F)(F)c1cc([N+](=O)[O-])c(NNC(=O)c2nccnc2)cc1'
    updated = update(api_url, 1, ff)
    print(f'HTTP Response: {updated[0]}, HTTP Status: {updated[1]}')

    print('Deleting a record...')
    deleted = delete(api_url, 1)
    print(f'HTTP Response: {deleted[0]}, HTTP Status: {deleted[1]}')

    print('Visualizing the data...')
    view(api_url)'''


if __name__ == '__main__':
    main()
