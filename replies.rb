require_relative 'users'
require_relative 'questions'
require_relative 'aa_questions'

class Replies
  attr_accessor :id, :body, :questions, :users, :replies
  def self.find_by_id(id)
    datum = QuestionsDatabase.instance.execute(<<-SQL,id)
      SELECT *
      FROM replies
      WHERE id = ?
    SQL
    Replies.new(datum[0]) if datum
  end

  def self.find_by_body(body)
    data = QuestionsDatabase.instance.execute(<<-SQL,body)
      SELECT *
      FROM replies
      WHERE body = ?
    SQL
    data.map{|datum| Replies.new(datum)} if data
  end

  def self.find_by_questions(questions)
    datum = QuestionsDatabase.instance.execute(<<-SQL,questions)
      SELECT *
      FROM replies
      WHERE questions = ?
    SQL
    datum.map{|datum| Replies.new(datum)} if datum
  end

  def self.find_by_replies(replies)
    datum = QuestionsDatabase.instance.execute(<<-SQL,replies)
      SELECT *
      FROM replies
      WHERE replies = ?
    SQL
    Replies.new(datum[0]) if datum
  end

  def self.find_by_users(users)
    datum = QuestionsDatabase.instance.execute(<<-SQL,users)
      SELECT *
      FROM replies
      WHERE users = ?
    SQL
    Replies.new(datum[0]) if datum
  end


  def initialize(options)
    @id = options["id"]
    @body = options['body']
    @questions = options['questions']
    @users = options['users']
    @replies = options['replies']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL,@body,@questions,@users,@replies)
      INSERT INTO
        replies (body,questions,users,replies)
      VALUES
        (?,?,?,?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def author
    Users.find_by_id(@users)
  end

  def question
    Question.find_by_id(@questions)
  end

  def parent_reply
    Replies.find_by_id(@replies)
  end

  def child_reply
    data = QuestionsDatabase.instance.execute(<<-SQL,@id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies = @id
    SQL
    data.map{|datum| Replies.new(datum)} if data
  end
end
