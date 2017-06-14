require_relative 'users'
require_relative 'replies'
require_relative 'aa_questions'

class Question
  attr_accessor :id, :title, :body, :associated_author
  def self.find_by_id(id)
    datum = QuestionsDatabase.instance.execute(<<-SQL,id)
      SELECT *
      FROM questions
      WHERE id = ?
    SQL
    Question.new(datum[0]) if datum
  end

  def self.find_by_title(title)
    datum = QuestionsDatabase.instance.execute(<<-SQL,title)
      SELECT *
      FROM questions
      WHERE title = ?
    SQL
    Question.new(datum[0]) if datum
  end

  def self.find_by_body(body)
    datum = QuestionsDatabase.instance.execute(<<-SQL,body)
      SELECT *
      FROM questions
      WHERE body = ?
    SQL
    Question.new(datum[0]) if datum
  end

  def self.find_by_associated_author(associated_author)
    data = QuestionsDatabase.instance.execute(<<-SQL,associated_author)
      SELECT *
      FROM questions
      WHERE associated_author = ?
    SQL
    data.map{|datum| Question.new(datum)} if data
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLikes.most_liked_questions(n)
  end

  def initialize(options)
    @id = options["id"]
    @title = options['title']
    @body = options['body']
    @associated_author = options['associated_author']
  end

  def create
    raise "#{self} already in database"
    QuestionsDatabase.instance.execute(<<-SQL,@title,@body,@associated_author)
      INSERT INTO
        questions (title,body,associated_author)
      VALUES
        (?,?,?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def author
    Users.find_by_id(@associated_author)
  end

  def replies
    Replies.find_by_questions(@id)
  end

  def followers
    QuestionFollows.followers_for_question_id(@id)
  end

  def likers
    QuestionLikes.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLikes.num_likes_for_question_id(@id)
  end


end
