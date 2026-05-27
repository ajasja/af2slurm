#!/bin/bash

#echo $(date +"%Y-%m-%dT%H:%M:%S%z") >> /home/d12/03_PROSCULPT/ps2slurm/ura.tece

num=$(find /home/d12/PROSCULPT_MOUNT/in/* -maxdepth 0 -type d -printf x | wc -c)
if [ $num -gt 0 ]; then
    echo "$(date +"%Y-%m-%dT%H:%M:%S%z") There are $num projects in the directory." >> /home/d12/PROSCULPT_MOUNT/watcher.out.log
    source /home/d12/03_PROSCULPT/ps2slurm/set_up_prosculpt_env.sh
    source /home/d12/03_PROSCULPT/ps2slurm/ps2slurm.config2
    
    # Copy each projectDirectory to the output directory with a unique name
    for dir in /home/d12/PROSCULPT_MOUNT/in/*; do
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
                echo "$(date +"%Y-%m-%dT%H:%M:%S%z") Submitting $yaml_file in $NEWFOLDER." >> /home/d12/PROSCULPT_MOUNT/watcher.out.log
                python $launch_script_path "$NEWFOLDER/$yaml_file" ++output_dir="$NEWFOLDER"
            else
                echo "$(date +"%Y-%m-%dT%H:%M:%S%z") [FATAL] No .yaml file found in $NEWFOLDER." >> /home/d12/PROSCULPT_MOUNT/watcher.out.log
            fi
        fi
    done
else
    exit 0
fi