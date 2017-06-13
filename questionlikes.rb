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
    datum = QuestionsDatabase.instance.execute(<<-SQL,users)
      SELECT *
      FROM question_likes
      WHERE users = ?
    SQL
    QuestionLikes.new(datum[0]) if datum
  end

  def self.find_by_likes(likes)
    datum = QuestionsDatabase.instance.execute(<<-SQL,likes)
      SELECT *
      FROM question_likes
      WHERE likes = ?
    SQL
    QuestionLikes.new(datum[0]) if datum
  end

  def self.find_by_questions(questions)
    datum = QuestionsDatabase.instance.execute(<<-SQL,questions)
      SELECT *
      FROM question_likes
      WHERE questions = ?
    SQL
    QuestionLikes.new(datum[0]) if datum
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
