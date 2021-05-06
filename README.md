# wzer_volume
Generate wZER daily volume data from BSCScan data files

V1 contract transactions can be downloaded here: https://bscscan.com/exportData?type=addresstokentxns&a=0xb374394aee78d2f42926b9eb040e248ee2ea67ec
V2 contract transactions can be downloaded here: https://bscscan.com/exportData?type=addresstokentxns&a=0xad7b5e295a476c43f1fc3b7bb945030e9e9ffdc6

After downloading one or both of the transaction files (as .csv, the R syntax will import these files, calculate daily volume and price, and export these as an Excel file. 
