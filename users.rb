require_relative 'aa_questions'
require_relative 'questions'
require_relative 'replies'

class Users
  attr_accessor :id, :fname, :lname
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL,id)
      SELECT *
      FROM users
      WHERE id = ?
      SQL
      data.map{|datum| Users.new(datum)} if data
  end

  def self.find_by_name(fname,lname)
    @fname = fname
    @lname = lname
    datum = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT *
      FROM users
      WHERE fname = ? AND lname = ?
      SQL

      Users.new(datum[0]) if datum
  end


  def initialize(options)
    @id = options["id"]
    @fname = options['fname']
    @lname = options['lname']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL,@fname,@lname)
      INSERT INTO
        users (fname,lname)
      VALUES
        (?,?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def authored_questions
    Question.find_by_associated_author(@id)
  end

  def authored_replies
    Replies.find_by_users(@id)
  end
end
