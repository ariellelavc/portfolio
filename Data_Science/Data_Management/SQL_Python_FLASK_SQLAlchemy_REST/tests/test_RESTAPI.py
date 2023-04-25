import pytest
import app

@pytest.fixture()
def client():
    return app.app.test_client()

def test_get_request(client):
    response = client.get("/molecule")
    vdata = b'{"id":2,"name":"70127","smiles":"FC(F)(F)c1cc([N+](=O)[O-])c(NNC(=O)c2nccnc2)cc1"},{"id":3,"name":"70545","smiles":"FC(F)(F)c1cc(C(=O)NNc2c(F)c(F)c(F)cc2)ccc1"},{"id":4,"name":"70546","smiles":"FC(F)(F)c1c(NNC(=O)c2ccc(C(=O)N(C)C)cc2)cccc1"},{"id":5,"name":"70551","smiles":"FC(F)(F)c1c(NNC(=O)c2ccc(C(F)(F)F)cc2)ccc(C#N)c1"}'

    assert vdata in response.data

def test_post_request(client):
    response = client.post("/molecule", json ={"name":"70034","smiles":"Clc1c(C(F)(F)F)cc([N+](=O)[O-])c(Nc2ccc(NC(=O)C)cc2)c1"})
    assert response.json["name"] == "70034"

def test_put_request(client):
    response = client.put("molecule/7", json={"name":"70035", "smiles":"Clc1c(C(F)(F)F)cc([N+](=O)[O-])c(Nc2ccc(NC(=O)C)cc2)c1"})
    assert response.status_code == 200

def test_delete_request(client):
    response = client.delete("molecule/7")
    assert response.status_code == 200


