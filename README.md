# Drone_SD

## Useful terminal commands
# Initializing a new repository
1. Create a new repository at github.com ( if you want your repo to be public )
2.  In terminal, Navigate to your desired directory
3. Type the following in terminal
	If your repo is public:
	'''
	git clone {repositoryURL}
	'''
	
	If private
	'''
	git init
	'''

# Change tracking and commiting
Add a new file to the repository
'''
git add {filename}
'''

Committing a file
'''
git commit {filename} -m "commit comments"
'''

Committing all tracked changes
'''
git commit -a -m "commit comments"

Removing a file from the cache
'''
git rm --cache {filename}
'''

Publishing your changes to the master
'''
git push -u
'''

