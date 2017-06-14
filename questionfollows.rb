require_relative 'aa_questions'
require_relative 'users'

class QuestionFollows
  attr_accessor :id, :questions, :users
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL,id)
      SELECT *
      FROM question_follows
      WHERE id = ?
    SQL
    data.map{|datum| QuestionFollows.new(datum)} if data
  end

  def self.find_by_questions(questions)
    datum = QuestionsDatabase.instance.execute(<<-SQL,questions)
      SELECT *
      FROM question_follows
      WHERE questions = ?
    SQL
    QuestionFollows.new(datum[0]) if datum
  end

  def self.find_by_users(users)
    datum = QuestionsDatabase.instance.execute(<<-SQL,users)
      SELECT *
      FROM question_follows
      WHERE users = ?
    SQL
    QuestionFollows.new(datum[0]) if datum
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL,question_id)
    SELECT users.id, users.fname, users.lname
    FROM question_follows
    JOIN users ON question_follows.users = users.id
    WHERE question_follows.questions = ?
    SQL
    data.map { |datum| Users.new(datum) } if data
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL,user_id)
    SELECT *
    FROM question_follows
    JOIN questions ON question_follows.questions = questions.id
    WHERE question_follows.users = ?
    SQL
    data.map { |datum| Question.new(datum) } if data
  end

  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL,n)
      SELECT *
      FROM question_follows
      JOIN questions ON question_follows.questions = questions.id
      GROUP BY questions
      ORDER BY COUNT(*)
      LIMIT ?
    SQL
    data.map{|datum| Question.new(datum)} if data
  end


  def initialize(options)
    @id = options["id"]
    @questions = options['questions']
    @users = options['users']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL,@questions,@users)
      INSERT INTO
        question_follows (questions,users)
      VALUES
        (?,?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end


end
