# consuming Web Services using the requests HTTP library

import requests
import config
import dataset
from argparse import ArgumentParser
import pandas as pd


def create(api_url, data):
    response = requests.post(api_url, json=data)
    return response.json(), response.status_code


def retrieve(api_url, *rid):
    if rid:
        api_url = '/'.join([api_url, str(rid[0])])
    response = requests.get(api_url)
    return response.json(), response.status_code


def update(api_url, rid, data):
    api_url = '/'.join([api_url, str(rid)])
    response = requests.put(api_url, json=data)
    if response.status_code == 500:
        return {'Internal Server Error': 'IntegrityError: UNIQUE constraint failed: molecule.name'}, 500
    else:
        return response.json(), response.status_code


def delete(api_url, rid):
    api_url = '/'.join([api_url, str(rid)])
    response = requests.delete(api_url)
    return response.json(), response.status_code


def view(api_url):
    df = pd.read_json(api_url)
    print(df.to_string(index=False))


def parse_args():
    # Parse command-line arguments
    parser = ArgumentParser()
    parser.add_argument(dest='config_filename', metavar='config_filename',
                        help='Configuration file e.g. molecules.cfg '
                        'specifying the REST API url and the dataset to use')

    args = parser.parse_args()
    return args


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

    # Create request/response
    print('Posting data...')
    for record in data:
        posted = create(api_url, record)
        print(f'HTTP Response: {posted[0]}, HTTP Status: {posted[1]}')

    # Retrieve request/response
    print('Getting all data...')
    fetched_all = retrieve(api_url)
    print(f'HTTP Response: {fetched_all[0]}, HTTP Status: {fetched_all[1]}')

    print('Visualizing the data...')
    view(api_url)

    print('Getting first record...')
    fetched_first = retrieve(api_url, 1)
    print(f'HTTP Response: {fetched_first[0]}, HTTP Status: {fetched_first[1]}')

    print('Getting last record...')
    fetched_last = retrieve(api_url, 5)
    print(f'HTTP Response: {fetched_last[0]}, HTTP Status: {fetched_last[1]}')

    print('Updating a record...')
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
    view(api_url)


if __name__ == '__main__':
    main()
