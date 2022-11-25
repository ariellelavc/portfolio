# RESTful API - return JSON data for a client (e.g. React.js, requests)
# building a JSON microservice

from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
import os

# Init app
app = Flask(__name__)
basedir = os.path.abspath(os.path.dirname(__file__))

# Database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'molecules_db.sqlite')
# for MySQL the URI: 'mysql://username:pwd@host/databasename
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Init DB
db = SQLAlchemy(app)

# Init MA (de)/serialization
ma = Marshmallow(app)


# Create Molecule Class/Model
class Molecule(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), unique=True)
    smiles = db.Column(db.String(255))

    def __init__(self, name, smiles):
        self.name = name
        self.smiles = smiles


# Create Molecule Schema
class MoleculeSchema(ma.Schema):
    # class Meta allows for specification of attributes to be serialized
    class Meta:
        fields = ('id', 'name', 'smiles')


# Init Schema
molecule_schema = MoleculeSchema()  # for single query result
molecules_schema = MoleculeSchema(many=True)  # query set result - multiple records


# Create a Molecule REST Endpoint
@app.route('/molecule', methods=['POST'])
def add_molecule():
    name = request.json['name']
    smiles = request.json['smiles']

    new_molecule = Molecule(name, smiles)

    db.session.add(new_molecule)
    db.session.commit()

    return molecule_schema.jsonify(new_molecule)


# Get All Molecules Endpoint
@app.route('/molecule', methods=['GET'])
def get_molecules():
    all_molecules = Molecule.query.all()
    result = molecules_schema.dump(all_molecules)
    return jsonify(result)


# Get Single Molecule
@app.route('/molecule/<id>', methods=['GET'])
def get_molecule(id):
    molecule = Molecule.query.get(id)
    return molecule_schema.jsonify(molecule)


# Update Molecule
@app.route('/molecule/<id>', methods=['PUT'])
def update_molecule(id):
    molecule = Molecule.query.get(id)

    name = request.json['name']
    smiles = request.json['smiles']

    molecule.name = name
    molecule.smiles = smiles

    db.session.commit()

    return molecule_schema.jsonify(molecule)


# CRUD API delete
# Delete Molecule
@app.route('/molecule/<id>', methods=['DELETE'])
def delete_molecule(id):
    molecule = Molecule.query.get(id)
    db.session.delete(molecule)
    db.session.commit()

    return molecule_schema.jsonify(molecule)

# Entry Point
@app.route('/')
def home():
    return get_molecules()

# Run Server
if __name__ == '__main__':
    db.create_all()
    app.run(debug=True)
