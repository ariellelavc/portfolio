import dash
import pandas as pd
import pathlib
from dash import html
from dash import dcc

from dash.dependencies import Input, Output
from dash.exceptions import PreventUpdate

import dash_molstar
from dash_molstar.utils import molstar_helper


app = dash.Dash(
    __name__,
    meta_tags=[{"name": "viewport", "content": "width=device-width, initial-scale=1"}],
)

server = app.server

DATA_PATH = pathlib.Path(__file__).parent.joinpath("data").resolve()

# read from datasheet
df = pd.read_csv(DATA_PATH.joinpath("hnRNPA1_dash.csv"))

STARTING_LIG = "5'-AG-3' RNA"
STARTING_PDB = molstar_helper.parse_molecule('assets/hnRNPA1_'+STARTING_LIG+'.pdb', fmt='pdb')


def get_image_path(image):
    return app.get_asset_url(image)

def make_dash_table(selection, df):
    """ Return a dash definition of an HTML table from a Pandas dataframe. """

    df_subset = df.loc[df["name"].isin(selection)]
    
    table = []

    header = []
    header.append(html.Td(["name"]))
    header.append(html.Td(["2D structure"]))
    header.append(html.Td(["smiles"]))
    header.append(html.Td(["MW"]))
    header.append(html.Td(["logP"]))
    header.append(html.Td(["tPSA"]))     
    header.append(html.Td(["LE"])) 
    header.append(html.Td(["Glide"])) 
    header.append(html.Td(["RMSD"])) 
    header.append(html.Td(["ddG FEP+"]))     
    header.append(html.Td(["ADMET"]))
            
    table.append(html.Tr(header))

    for index, row in df_subset.iterrows():
        rows = []          
        rows.append(html.Td([row["name"]]))
        rows.append(html.Td([html.Img(src=get_image_path(row["structure"]))]))        
        rows.append(html.Td([row["smiles"]]))
        rows.append(html.Td([row["MW"]]))
        rows.append(html.Td([row["logP"]]))
        rows.append(html.Td([row["tPSA"]]))
        rows.append(html.Td([row["LE"]]))
        rows.append(html.Td([row["Glide"]]))
        rows.append(html.Td([row["RMSD"]]))
        rows.append(html.Td([row["ddG FEP+"]]))
        rows.append(html.Td([row["ADMET"]]))        
        table.append(html.Tr(rows))

    return table

app.layout = html.Div(
    [              
        html.Div(
            [   
                html.Div(
                        [
                                                
                        html.Div(
                            [
                                
                                html.H6(
                                    "discovery and optimization of small molecule inhibitors",
                                    className="uppercase title",
                                ),
                                html.H6(
                                    "targeting RNA splicing activity of the heterogeneous nuclear riboprotein A1",
                                    className="uppercase title",
                                ),
                                html.Span("Select ", className="uppercase bold"),
                                html.Span(
                                    "a ligand in the dropdown to visualize the protein-ligand complex in Dash Molstar 3D Viewer, "
                                ),
                                html.Span(
                                    "and to add the ligand's 2D structure, descriptors and binding free energy estimates to the potential inhibitors table at the bottom."
                                ),
                            ]
                        )
                    ],
                    className="app__header",
                ), 

                html.Div(
                    [
                        dcc.Dropdown(
                            id="chem_dropdown",
                            multi=True,
                            value=[STARTING_LIG],
                            options=[{"label": i, "value": i} for i in df["name"]],
                        )
                    ],
                    className="app__dropdown",                    
                ),

                html.Div(
                    [
                        
                        html.Div(
                            [
                               html.Div(
                                    [html.Img(src=app.get_asset_url("hnRNPA1.png"))]
                                    ), 
                            ], className="one-half column",                               
                        ),
                        
                        html.Div(
                            [
                                dash_molstar.MolstarViewer(
                                    data=STARTING_PDB, id='viewer', style={'width': '500px', 'height':'500px'}
                                ),                                                 
                            ], className="one-half column",                               
                        ),
                                 
                    ], className="container app__content bg-white", style={'width': '1200px'}
                ),
                                                  
                html.Div(
                    [
                        html.Table(
                            make_dash_table([STARTING_LIG], df),
                            id="table-element",
                            className="table__container",
                        )
                    ],
                    className="container bg-white p-0",
                ),
                
            ],
            className="app__container",
        ),
    ]
)

@app.callback(Output("table-element", "children"), [Input("chem_dropdown", "value")])
def update_table(chem_dropdown_value):
    """
    Update the table rows.

    :params chem_dropdown_values: selected dropdown values
    """
    return make_dash_table(chem_dropdown_value, df)

@app.callback(Output('viewer', 'data'),
              [Input("chem_dropdown", "value")],
              prevent_initial_call=True)
def display_output(chem_dropdown_value):      
    data = molstar_helper.parse_molecule('assets/hnRNPA1_'+chem_dropdown_value[-1]+'.pdb', fmt='pdb')
    return data


if __name__ == "__main__":    
    app.run_server(debug=True)