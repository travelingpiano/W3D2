CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  associated_author INTEGER NOT NULL,
  FOREIGN KEY (associated_author) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  questions INTEGER NOT NULL,
  users INTEGER NOT NULL,
  FOREIGN KEY (questions) REFERENCES questions(id),
  FOREIGN KEY (users) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  questions INTEGER NOT NULL,
  users INTEGER NOT NULL,
  replies INTEGER,
  FOREIGN KEY (questions) REFERENCES questions(id),
  FOREIGN KEY (users) REFERENCES users(id),
  FOREIGN KEY (replies) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  likes BOOLEAN,
  users INTEGER NOT NULL,
  questions INTEGER NOT NULL,
  FOREIGN KEY (questions) REFERENCES questions(id),
  FOREIGN KEY (users) REFERENCES users(id)
);

INSERT INTO
  users (fname,lname)
VALUES
  ('Bob','Loblaw'),
  ('Justin','White');

INSERT INTO
  questions (title,body,associated_author)
VALUES
  ('Tough Question','What is the meaning of life',1),
  ('Easy Question','What is 1+1',2);

-- INSERT INTO
--   question_follows (questions,users)
-- VALUES
--   (1,1),
--   (2,2);

INSERT INTO
  replies (body,questions,users,replies)
VALUES
  ('I don''t know',1,2,null),
  ('2',2,1,null),
  ('Why not',1,1,1),
  ('Are you sure',1,2,2);

INSERT INTO
  question_likes (likes,users,questions)
VALUES
  (1,1,2),
  (1,2,1);
