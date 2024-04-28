###############################################################################
# STATE COMMANDS #
###############################################################################

# list all state resources
terraform state list

# see an spefic resource
terraform state show RESOURCE_IDENTIFIER.LABEL

# move an item in a state
terraform state mv SOURCE DESTINATION

# remove an item from a state
terraform state rm RESOYRCE_IDENTIFIER.LABEL