###############################################################################
# COMMANDS #
###############################################################################

terraform plan -out namefile.tfplan

# how to lint
terraform validate # validates the code correctness

terraform fmt # fix identation
terraform fmt -check 

# How we handle with variabless
# we can pass variables at the command line
# terraform plan -var=billing_code="ACT@#f4454" -var=project="web_app" -var=aws_access_key="KEY_HERE" -var=aws_secret_key="KEY_HERE" -out m3.tfplan

# Let's store our variables at terraform.tfvars
# for linux
export TF_VAR_aws_access_key="KEY_HERE"
export TF_VAR_aws_secret_key="KEY_HERE"
# in linux console check if exported variable is set up
echo $TF_VAR_aws_access_key # $variable_name
# for PowerShell
$env:TF_VARS_aws_access_key=YOUR_ACCESS_KEY
$env:TF_VARS_aws_secret_key=YOUR_SECRET_KEY

# Now you can run plan without the extra stuff
terraform plan -out m4.tfplan
terraform apply "m4.tfplan"

terraform show
terraform output