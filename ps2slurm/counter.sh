#!/bin/bash
source /home/d12/03_PROSCULPT/ps2slurm/ps2slurm.config

#echo $(date +"%Y-%m-%dT%H:%M:%S%z") >> /home/d12/03_PROSCULPT/ps2slurm/ura.tece

num=$(find ${in_folder}/* -maxdepth 0 -type d -printf x | wc -c)
if [ $num -gt 0 ]; then
    echo "$(date +"%Y-%m-%dT%H:%M:%S%z") There are $num projects in the directory." >> $log_path_name
    source $env_setup_script_path
    
    # Copy each projectDirectory to the output directory with a unique name
    for dir in ${in_folder}/*; do
        if [ -d "$dir" ]; then
            #timestamp=$(date +"%Y-%m-%dT%H-%M-%S")
            DIRNAME=$(basename "$dir")
            #NEWFOLDER="$out_folder/${DIRNAME}_${timestamp}"
            NEWFOLDER="$out_folder/${DIRNAME}"
            rm -rf "$NEWFOLDER" # "The server is meant to be temporary, so people should copy stuff off."
            mv "$dir" "$NEWFOLDER"
            cd $NEWFOLDER
            # Find the .yaml file in the new folder
            yaml_file=$(find . -maxdepth 1 -type f -iname '*.yaml')
            if [ -f "$yaml_file" ]; then
                echo "$(date +"%Y-%m-%dT%H:%M:%S%z") Submitting $yaml_file in $NEWFOLDER." >> $log_path_name
                python $launch_script_path "$NEWFOLDER/$yaml_file" ++output_dir="$NEWFOLDER"
            else
                echo "$(date +"%Y-%m-%dT%H:%M:%S%z") [FATAL] No .yaml file found in $NEWFOLDER." >> $log_path_name
            fi
        fi
    done
else
    exit 0
fi