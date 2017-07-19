#2017-7-17
#command line arguments are plink dosage file, then map file I created with rsIDs, then output path, then output file name.
#output is dosage file in format expected by prediXcan

import sys

dose_fname = sys.argv[1] #dose path and file name
map_fname = sys.argv[2] #map path and file name
out_path = sys.argv[3] #output path
out_fname = sys.argv[4] #output file name

dose_handle = open(dose_fname, 'r')
map_handle = open(map_fname, 'r')

dose_out_name = out_path + out_fname
dose_out = open(dose_out_name,'w')

#readin map file as a list. Iterate through it in-sync with dose file
map_list = map_handle.readlines()

count = 0
for dose_line in dose_handle:
  #parse map file
  #each line of map list is extracted and saved as a string
  map_line = map_list[count]
  #chomp newline
  map_line = map_line.rstrip()
  #convert to list for easy parsing
  map_line2 = map_line.split("\t")
  chrom = "chr" + map_line2[0]
  rsID = map_line2[1]
  position = map_line2[2]
  non_coding = map_line2[3]
  coding = map_line2[4]
  MAF = map_line2[5]
  imp = map_line2[6]

#  if MAF>=0.01 and imp>=0.3 and rsID.lower().startswith("rs"):
  if MAF>=0.01 and imp>=0.3:
    #parse dosage file
    #chomp newline
    dose_line = dose_line.rstrip()
    dose_list = dose_line.split("\t")
    dose_list = dose_list[3:]
    delimiter = "\t"
    dose_line2 = delimiter.join(dose_list)
    dose_line3 = chrom + "\t" + rsID + "\t" + position + "\t" + non_coding + "\t" + coding + "\t" + MAF + "\t" + dose_line2 + "\n" 
    dose_out.write(dose_line3)
  
  #increment to keep map synced with dosage
  count = count + 1

dose_out.close()
map_handle.close()
dose_handle.close()

