# alphafold-slurm-runner
Scripts to run AF2 with slurm integration.


## Installation

```bash
python -m venv .venv
source .venv/bin/activate
pip install ConfigArgParse biopython
```

## Usage of alphafold2slurm
TBW


# domesticator-slurm-runner
Scripts to run Domesticator with slurm integration.

## Usage of domesticator2slurm
Copy `.fasta` or `.pdb` file to the specified `in` folder.  
The copied file must start with a **comment** which specifies which **vector**.gb to use and any additional arguments to be passed to Domesticator.

The vector file will be searched for in the specified `vectors` folder. 

## Example:
```fasta
# pET29b.gb
>P1__P2Args
SPEDEIQALEEENAQLEQENAALEEEIAQLEY
```

### Passing additional arguments:
```fasta
# pET29b.gb --nstruct 2 --max_tries 5
>P1__P2Args
SPEDEIQALEEENAQLEQENAALEEEIAQLEY
```

# Prosculpt-slurm-runner
## Installation
1. Install [Prosculpt](https://github.com/ajasja/prosculpt#installation) 
2. Clone the ps2slurm folder from this repo
3. Modify `ps2slurm.config` to use correct paths.
    * `env_setup_script_path`: script to activate conda environments, modify as needed
    * Make sure you use full absolute paths
4. Update the second line of `counter.sh` with the correct config path
    * Also make it executable: `chmod +x counter.sh`
5. `crontab -e`
6. Esc -> `i` (to start insert mode in Vim)
7. Paste the content of `cron.sh`, make sure you add a new line
8. Esc -> `:x` to save  
    * Should print `crontab: installing new crontab`

The script will now be run every minute. If projects are found in the input directory, it will submit them.

## Usage
Add your project folder to the input directory. It should contain all needed files (run.yaml, potentially input.pdb, alignment.a3m ...). It will be moved to the output directory and submitted.  
**Destination folder will be overwritten!** The server is meant to be temporary, so people should copy stuff off.
