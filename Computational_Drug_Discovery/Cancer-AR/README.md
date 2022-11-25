# Cheminformatics: Engineered Protein-Ligand Interaction Descriptors Predictive of Adverse Drug Responses of Novel Mutants of Androgen Receptor - main driver and drug target in prostate cancer 

Scripting Language: SVL (Scientific Vector Language)

Purpose:  Quantify key protein-ligand interactions (i.e. steric, electrostatic) within a user-defined cutoff region around the binding site for wild-type/mutated protein-drug/ligand complexes at atomic level;

	 Computes descriptors based on interatomic distances and fundamental properties such as electronegativity, covalent radii, atom types and hybridization state of and between protein and ligand atoms within the cutoff region of the binding site;

         Generates novel features (descriptors) for machine learning algorithms (binary classifiers of drug response as agonist or antagonist);  

	 Predict adverse drug responses by clinically relevant mutants of protein target in disease of interest.
	
Usage:

svl > db_save_entries ['input_MOE_database.mdb', 'output_MOE_database.mdb', 'electronegativity_scale', 'cutoff region around binding site', 'maximum binding site region definition', 'mutations list']

Example:

svl > db_save_entries ['./docked_complexes_in.mdb', './docked_complexes_PLI_descriptors_out.mdb', 'electronegativity_scale - lookup table', 'cutoff region around binding site - Angstroms', 'define max binding site region - boolean', 'mutations list']

svl> db_save_entries ['C:/Users/lcarabet/SVL_Task/xpdock/xpdock_drugsonly.mdb', 'C:/Users/lcarabet/SVL_Task/xpdock/xpdock_drugsonly_out.mdb', 'EO', 10, 'T', ['877','878','875','880','894','896','898','882','889','891','742','716','731','702',['878','889'], ['878','891'], ['877','878']]]

Input: 

- MOE database containing docked structures of protein-drug/native ligand complexes and their experimental response/activity (agonist/antagonist; 0/1)

- Desired electronegativity scale: (e.g. 'EO')

- Desired cutoff region (A): within A Angstroms distance around binding site (e.g. 10, 5) for selection of protein and ligand atoms to include in computation of descriptors

- Maximum binding site region Calculation (boolean): if 'T' computes the maximum number of atoms in the selected binding site region among all docked complexes in the dataset

- List of mutated (single, double, etc.) protein residue numbers: e.g. ['877','878','875','880','894','896','898','882','889','891','742','716','731','702',['878','889'], ['878','891'], ['877','878']]

Output:

- MOE database containing the input docked complexes structures, the extracted structure of the user-defined binding site region, the extracted structure of the drug/native ligand, name of complex and computed molecular descriptors.

Algorithm Outline:

- Open MOE input database for reading

- Create MOE output database in which input and extracted structural data as well as calculated molecular descriptors and target activity will be stored

- Retrieve all molecular complexes and activity from input DB and expands their content into ouput DB, specifically writes entries into output DB: the original input molecule, extracted binding site region within desired cutoff, extracted ligand, name of complex and activity

- Computes all protein and ligand atoms within the user-defined cutoff binding site region

- Computed descriptors as follows:
	1. descriptors that measure the cumulative influence - steric (Rs_L_R), polar (Sigma_L_R), and induced charge (Q_L_R) - of all ligand (L) atoms on all receptor (R) atoms within the cutoff (e.g. 10 Angstroms) binding site region surrounding the ligand;

	2. descriptors that quantify the steric (AA#_Rs_AA_R) and inductive effects (AA#_Sigma_AA_R) of all atoms of mutated receptor amino acid residues (AA#) provided in the mutations list argument relative to wild-type (AA);
	
	3. descriptors to quantify PLI (R_Ah_L_Ah) between all receptor atoms in all possible hybridization states (R_Ah) and all ligand atoms in their hybridized states (L_Ah) within the cutoff region.

- Create new numeric (float) database fields and store each computed descriptor in these fields for their corresponding entries.

- Opens a MOE Database Viewer with the output database.

- Train and evaluate QSAR models (SVM, RF, ANN).


