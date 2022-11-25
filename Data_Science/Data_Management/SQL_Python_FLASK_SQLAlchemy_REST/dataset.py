import csv


def load_data(filename):
    data = []

    with open(filename, newline='') as f:
        reader = csv.DictReader(f)
        for row in reader:
            data.append(row)

    return data


if __name__ == '__main__':
    data = load_data('molecules.csv')
    print(data[-1])