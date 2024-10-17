from deduce import Deduce
import re
from fpdf import FPDF

deduce = Deduce()

# Define text and patterns to replace
with open('medical_record_to_deidentify.txt', 'r') as file:
    text = file.read()

doc = deduce.deidentify(text)

patterns = [r'PERSOON-\d{1}', r'DATUM-\d{1}', r'EMAILADRES-\d{1}',  
            r'\d{3}[-]\d{3}[-]\d{4}', 
            r'\d{1,5} \w+ (?:St|Ave|Blvd|Dr|Ln|Ct|Pl|Rd|Way|Walk|Pkwy|Sq|Trl|Cir|Terr), (?:[A-Za-z ]+), (?:[A-Z]{2}) \d{5}', 
            r'\d{3}[-]\d{2}[-]\d{4}']

# Define replacement strings
replacements = ["PERSON", "DATE", "EMAILADDRESS", "[PHONENUMBER]", "[ADDRESS]", "[SSN]"]

# re.sub() function to replace all matches of the pattern
deidentified_text = doc.deidentified_text

for pattern, replacement in zip(patterns, replacements):
    deidentified_text = re.sub(pattern, replacement, deidentified_text)

# Print the new text
print(deidentified_text)

# Create pdf
pdf = FPDF()
pdf.add_page()
pdf.set_font('Arial', size=12)
pdf.write(5, deidentified_text)
pdf.output('medical_record_deidentified.pdf')



