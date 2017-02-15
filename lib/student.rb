require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]

    student = Student.new()

    student.id = id
    student.name = name
    student.grade = grade
    student
    # create a new Student object given a row from the database
  end

  def self.all
    sql = <<-SQL
    SELECT *
    FROM students
    SQL

    student_rows = DB[:conn].execute(sql)

    student_rows.map do |item|
      Student.new_from_db(item)
    end

  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade < ?
    SQL

    student_rows = DB[:conn].execute(sql,12)

    student_rows.each do |item|
      Student.new_from_db(item)
    end
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = ?
    LIMIT #{x}
    SQL

    student_rows = DB[:conn].execute(sql,10)

    student_rows.map do |item|
      Student.new_from_db(item)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    LIMIT 1
    SQL

    student_row = DB[:conn].execute(sql).flatten
    Student.new_from_db(student_row)

  end

  def self.all_students_in_grade_x(x)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = ?
    SQL

    student_rows = DB[:conn].execute(sql,x)

    student_rows.map do |item|
      Student.new_from_db(item)
    end
  end

  def self.find_by_name(name)

    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    LIMIT 1
    SQL

    student_row = DB[:conn].execute(sql,name).flatten
    Student.new_from_db(student_row)

  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = ?
    LIMIT 1
    SQL

    student_rows = DB[:conn].execute(sql,9)

    student_rows.each do |item|
      Student.new_from_db(item)
    end
  end

  def save

    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
