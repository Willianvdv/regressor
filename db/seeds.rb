user = User.create email: 'developers@example.com'

project = user.projects.create! user: user, name: 'Regressor project'

result = project.results.create! tag: 'master'
result.queries.create! statement: 'SELECT * FROM users;'
result.queries.create! statement: 'SELECT * FROM projects;'

result = project.results.create! tag: 'master'
result.queries.create! statement: 'SELECT * FROM users;'
result.queries.create! statement: 'SELECT * FROM projects;'
result.queries.create! statement: 'SELECT * FROM queries;'

result = project.results.create! tag: 'pull-request'
result.queries.create! statement: 'SELECT * FROM users;'
result.queries.create! statement: 'SELECT * FROM projects;'
result.queries.create! statement: 'SELECT * FROM queries;'
result.queries.create! statement: 'DELETE FROM users;'
