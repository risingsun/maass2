class CreateStudentChecks < ActiveRecord::Migration
  def self.up
    create_table :student_checks do |t|
      t.string   "name"
      t.string   "first_name"
      t.string   "middle_name"
      t.string   "last_name"
      t.date     "birth_date"
      t.string   "sex"
      t.string   "f_name"
      t.string   "m_name"
      t.string   "f_desg"
      t.string   "m_desg"
      t.string   "r_add1"
      t.string   "r_add2"
      t.string   "r_add3"
      t.string   "o_add1"
      t.string   "o_add2"
      t.string   "o_add3"
      t.string   "o_ph_no"
      t.string   "r_ph_no"
      t.string   "mobile"
      t.string   "enroll_no"
      t.string   "year"
      t.string   "roll_no"
      t.string   "classname"
      t.string   "house_name"
      t.integer  "profile_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "e_mail_1"
      t.string   "e_mail_2"
    end
  end

  def self.down
    drop_table :student_checks
  end
end