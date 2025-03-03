# SPDX-License-Identifier: MIT

# Function to list all GPLv3 packages

list_gplv3_packages () {
    # Redirect the output of bitbake -p to a file
    bitbake -p world > world_packages.txt

    # Read the file
    packages=$(cat world_packages.txt)

    # Loop through the packages
    for package in $packages; do
        # Use bitbake -g to get the license of each package
        license=$(bitbake -g $package | grep ^LICENSE= | cut -d'=' -f2)
        # Check if the license is GPLv3
        if [[ $license == *GPL-3.0* ]] ; then
            # Print the package name
            echo "$package"
        fi
    done

    #remove the temporary file
    rm world_packages.txt
}


# Example usage in a recipe:
# Inherit this class and call the function in a do_list_gplv3_packages task.
#
# inherit list-gplv3
#
# do_list_gplv3_packages() {
#     list_gplv3_packages
# }
#
# addtask do_list_gplv3_packages
