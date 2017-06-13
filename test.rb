require 'sqlite3'
require 'singleton'
require_relative 'aa_questions'
require_relative 'users'
require_relative 'questions'
require_relative 'questionfollows'
require_relative 'replies'
require_relative 'questionlikes'

#User Test
# old_user = Users.find_by_name('Bob','Loblaw')
# p old_user.authored_questions
# p old_user.authored_replies

#Questions Test
old_question = Question.find_by_id(1)
p old_question
p old_question.author
p old_question.replies

#
