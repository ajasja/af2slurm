#!/bin/bash

# Load the config variables
source /home/d12/03_PROSCULPT/ps2slurm/ps2slurm.config

# Count number of input directories (input projects)
num=$(find ${in_folder}/* -maxdepth 0 -type d -printf x | wc -c)
if [ $num -gt 0 ]; then
    echo "$(date +"%Y-%m-%dT%H:%M:%S%z") There are $num projects in the directory." >> $log_path_name
    source $env_setup_script_path

    mkdir -p /tmp/ps2slurm/ # Project locks are saved here
    
    # Copy each projectDirectory to the output directory
    for dir in ${in_folder}/*; do
        if [ -d "$dir" ]; then
            DIRNAME=$(basename "$dir")
            NEWFOLDER="$out_folder/${DIRNAME}"

            # Check if another cron is already consuming this directory
            if mkdir /tmp/ps2slurm/${DIRNAME}.lock; then
                # Lock acquired
                echo "$(date +"%Y-%m-%dT%H:%M:%S%z") Found $DIRNAME, waiting 30s to ensure the whole directory has been copied." >> $log_path_name
            else
                # Previous run of cronjob is still running and processing this project. Continue with the next project.
                echo "$(date +"%Y-%m-%dT%H:%M:%S%z") Lock file for $DIRNAME already exists. Another instance is already consuming it?" >> $log_path_name
                continue
            fi

            rm -rf "$NEWFOLDER" # "The server is meant to be temporary, so people should copy stuff off."

            # Everything from here on should be done in the background not to block the script from checking for new directories.
            { 
                # Wait 30 s to ensure the whole directory has been copied by the user. 
                sleep 30;
                mv "$dir" "$NEWFOLDER";
                cd $NEWFOLDER;

                rm -rf /tmp/ps2slurm/${DIRNAME}.lock; # Release the lock

                # Find the .yaml file in the new folder
                yaml_file=$(find . -maxdepth 1 -type f -iname '*.yaml');
                if [ -f "$yaml_file" ]; then
                    echo "$(date +"%Y-%m-%dT%H:%M:%S%z") Submitting $yaml_file in $NEWFOLDER." >> $log_path_name;
                    python $launch_script_path "$NEWFOLDER/$yaml_file" ++output_dir="$NEWFOLDER" 2>> $log_path_name; # Redirect errors to log file
                else
                    echo "$(date +"%Y-%m-%dT%H:%M:%S%z") [FATAL] No .yaml file found in $NEWFOLDER." >> $log_path_name;
                fi
            } &
        fi
    done
else
    exit 0
fi