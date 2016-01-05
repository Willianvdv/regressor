[![Circle CI](https://circleci.com/gh/Willianvdv/regressor.svg?style=svg)](https://circleci.com/gh/Willianvdv/regressor)


# Note to self

How it works:

	* There are two CI jobs: develop and master

	* Master stores results
	* Develop stores and compares with master

	* Master uses the tag 'master'
	* Develop uses the tag `git rev-parse HEAD` (current commit hash)
	* Comparison is between `current_commit_hash <-> master`
