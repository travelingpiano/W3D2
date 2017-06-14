require 'sqlite3'
require 'singleton'
require_relative 'aa_questions'
require_relative 'users'
require_relative 'questions'
require_relative 'questionfollows'
require_relative 'replies'
require_relative 'questionlikes'


#EASY TESTS
#User Test
# old_user = Users.find_by_name('Bob','Loblaw')
# p old_user.authored_questions
# p old_user.authored_replies

#Questions Test
# old_question = Question.find_by_id(1)
# p old_question
# p old_question.author
# p old_question.replies

#Replies Test
# parentreply = Replies.find_by_id(1)
# p parentreply
# p parentreply.child_reply
# p parentreply.author
# p parentreply.question
# childreply = Replies.find_by_id(4)
# p childreply
# p childreply.parent_reply

#MEDIUM TESTS
#QuestionFollow
# p QuestionFollows.followers_for_question_id(2)
# p QuestionFollows.followed_questions_for_user_id(1)
# old_question = Question.find_by_id(1)
# p old_question
# p old_question.followers
# old_user = Users.find_by_name('Bob','Loblaw')
# p old_user
# p old_user.followed_questions

#HARD TESTS
# p QuestionFollows.most_followed_questions(2)
#p QuestionLikes.likers_for_question_id(1)
#p QuestionLikes.num_likes_for_question_id(1)
# p QuestionLikes.liked_questions_for_user_id(1)

# old_question = Question.find_by_id(1)
# p old_question.likers
# p old_question.num_likes
#
# old_user = Users.find_by_name('Bob','Loblaw')
# p old_user.liked_questions
