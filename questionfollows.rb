require_relative 'aa_questions'

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
