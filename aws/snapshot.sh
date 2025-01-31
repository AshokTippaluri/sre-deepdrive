#!/bin/bash

# Check if the AWS CLI is installed and configured
if ! command -v aws &> /dev/null; then
  echo "Error: AWS CLI not found. Please install and configure it."
  exit 1
fi

# Check if the file containing the snapshot list exists
if [ ! -f "sst.txt" ]; then
  echo "Error: sst.txt file not found."
  exit 1
fi

# Loop through each snapshot ID in the file
while IFS= read -r snapshot_id; do
  snapshot_id=$(echo "$snapshot_id" | xargs) # Remove whitespace

  if [[ -n "$snapshot_id" ]]; then # Skip empty lines

    # Dry run first!  This is VERY IMPORTANT.
    aws ec2 delete-snapshot --snapshot-id "$snapshot_id" --dry-run

    # Uncomment the following line ONLY after you have verified the dry run output!
    aws ec2 delete-snapshot --snapshot-id "$snapshot_id"

    if [[ $? -eq 0 ]]; then
      echo "Processed snapshot: $snapshot_id (Dry run - no actual deletion)." # Or "Deleted snapshot: $snapshot_id" after uncommenting the real delete command.
    else
      echo "Error processing snapshot: $snapshot_id"
    fi

  fi
done < "sst.txt"

echo "Finished."

----------------------------------------------------------------------------------------

#!/bin/bash

# List of snapshot IDs
snapshot_ids=(
    "snap-0e8263f79c04c6392"
    "snap-0d9022a21208e1653"
    "snap-00b01dc5f8dd7ded8"
)

# Loop through the snapshot IDs and delete them
for snapshot_id in "${snapshot_ids[@]}"; do
    echo "Deleting snapshot: $snapshot_id"
    aws ec2 delete-snapshot --snapshot-id "$snapshot_id"
    if [ $? -eq 0 ]; then
        echo "Successfully deleted snapshot $snapshot_id"
    else
        echo "Failed to delete snapshot $snapshot_id"
    fi
done

--------------------------------------------------------------------

aws ec2 delete-snapshot --snapshot-id snap-xxxxxxxxxxxxxxxxx

-------------------------------------------------------------------------


aws rds describe-db-snapshots     --query "DBSnapshots[].[DBSnapshotIdentifier, DBInstanceIdentifier, SnapshotCreateTime, Status, Engine]"     --output text |     awk -F'\t' 'BEGIN {OFS=","; print "SnapshotId,InstanceId,CreateTime,Status,Engine"} {print $1,$2,$3,$4,$5}' > rds_snapshots.csv


----------------------------------------------------







