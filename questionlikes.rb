require_relative 'aa_questions'
require_relative 'questions'
require_relative 'users'

class QuestionLikes
  attr_accessor :id, :likes, :users, :questions
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL,id)
      SELECT *
      FROM question_likes
      WHERE id = ?
    SQL
    data.map{|datum| QuestionLikes.new(datum)} if data
  end

  def self.find_by_users(users)
    data = QuestionsDatabase.instance.execute(<<-SQL,users)
      SELECT *
      FROM question_likes
      WHERE users = ?
    SQL
    data.map{|datum| QuestionLikes.new(datum)} if data
  end

  def self.find_by_likes(likes)
    data = QuestionsDatabase.instance.execute(<<-SQL,likes)
      SELECT *
      FROM question_likes
      WHERE likes = ?
    SQL
    data.map{|datum| QuestionLikes.new(datum)} if data
  end

  def self.find_by_questions(questions)
    data = QuestionsDatabase.instance.execute(<<-SQL,questions)
      SELECT *
      FROM question_likes
      WHERE questions = ?
    SQL
    data.map{|datum| QuestionLikes.new(datum)} if data
  end

  def self.likers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL,question_id)
      SELECT users.lname,users.fname,users.id
      FROM question_likes
      JOIN users ON question_likes.users = users.id
      WHERE question_likes.questions = ?
    SQL
    data.map{|datum| Users.new(datum)} if data
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL,question_id)
      SELECT COUNT(*)
      FROM question_likes
      WHERE question_likes.questions = ?
    SQL
    data[0].values[0]
  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL,user_id)
      SELECT *
      FROM question_likes
      JOIN questions ON question_likes.questions = questions.id
      WHERE question_likes.users = ?
    SQL
    data.map{|datum| Question.new(datum)} if data
  end

  def self.most_liked_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL,n)
      SELECT *
      FROM question_likes
      JOIN questions ON question_likes.questions = questions.id
      GROUP BY question_likes.questions
      ORDER BY COUNT(*)
      LIMIT n
    SQL
    data.map{|datum| Question.new(datum)} if data
  end

  def initialize(options)
    @id = options["id"]
    @likes = options['likes']
    @users = options['users']
    @questions = options['questions']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL,@likes,@users,@questions)
      INSERT INTO
        question_likes (likes,users,questions)
      VALUES
        (?,?,?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
end
