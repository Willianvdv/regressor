[![Circle CI](https://circleci.com/gh/Willianvdv/regressor.svg?style=svg)](https://circleci.com/gh/Willianvdv/regressor)

# How it works (by example)

* There are two CI jobs: develop and master

* Master stores results
* Develop stores and compares with master

* Master uses the tag 'master'
* Develop uses the tag `git rev-parse HEAD` (current commit hash)
* Comparison is between `current_commit_hash <-> master`

* storage is handled by rspec-regression gem
* comparison is done via web interface, or by using the API
  * `/api/results/compare_latest_of_tags.{json/text}?left_tag=GIT_COMMIT&right_tag=master`
  * format `text` renders markdown as plaintext
