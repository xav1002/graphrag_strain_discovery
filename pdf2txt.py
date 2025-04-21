from PyPDF2 import PdfReader
import sys
from os import listdir
from os.path import isfile, join

dirs = sys.argv[1:]
print('dirs',dirs)

for dir in dirs:
    only_files = [f for f in listdir('./'+dir) if isfile(join('./'+dir, f))]
    only_pdfs = [x for x in only_files if '.pdf' in x]

    print(only_pdfs)
    for pdf in only_pdfs:
        reader = PdfReader('./'+dir+'/'+pdf)
        extracted_text = ''
        for page in reader.pages:
            extracted_text += page.extract_text()
        
        with open('./graphrag/input/'+pdf.split('.p')[0]+'.txt','w',encoding='utf-8') as f:
            f.write(extracted_text)