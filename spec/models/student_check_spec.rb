require 'spec_helper'

describe StudentCheck do

  before(:all) do
    @student_check = Factory(:student_check)
  end

  let(:student_check) {@student_check.reload}

  it "should split name" do
    no_name = Factory.build(:student_check , :name=> "amit kumar gupta")
    no_name.should be_valid
    no_name.split_name.should be_true
    no_name.middle_name.should == "kumar"
    no_name.last_name.should == "gupta"
  end

  it "should require year" do
    no_year = Factory.build(:student_check , :year => '')
    no_year.should_not be_valid
  end

  it "should fix name before validation check" do
    student = Factory.build(:student_check , :name=> "", :first_name => "amit", :middle_name => "kumar", :last_name => "gupta")
    student.fix_name.should == "Amit Kumar Gupta"
  end

  it "should test titlecase if values are not in title case" do
    student = Factory.build(:student_check, :name => 'david h hanson', :first_name => 'david', :middle_name => 'h', :last_name => 'hanson', :year => 2011 )
    student.should be_valid
    student.titlecase_fields.should be_true    
    student.name.should == "David H Hanson"
    student.first_name.should == "David"
    student.middle_name.should == "H"
    student.last_name.should == "Hanson"
  end

  it "should test titlecase if values are already in title case" do
    student = Factory.build(:student_check, :name => 'David H Hanson', :first_name => 'David', :middle_name => 'H', :last_name => 'Hanson', :year => 2011 )
    student.titlecase_fields.should be_true
    student.name.should == "David H Hanson"
    student.first_name.should == "David"
    student.middle_name.should == "H"
    student.last_name.should == "Hanson"
  end

  it "should check unregistered batch members " do
    student = StudentCheck.unregistered_batch_members(2011)
    student.should be_blank
    student.should be_kind_of(Array)
    Factory(:student_check, :profile_id => nil)
    StudentCheck.unregistered_batch_members(2011).should_not be_blank
    StudentCheck.unregistered_batch_members(2011).should be_kind_of(Array)
  end

  it "should test 'unregistered_batch_count' method" do
    Factory(:student_check, :profile_id => nil)
    unregistered_batch_count = StudentCheck.unregistered_batch_count
    unregistered_batch_count.should_not be_blank
    unregistered_batch_count.should be_kind_of(Hash)
    unregistered_batch_count.keys.should == ["2011"]
    unregistered_batch_count.values.should == [1]
  end  

  it "should test full name" do
    full_name= student_check.full_name
    full_name.should be_kind_of(String)
    full_name.should_not be_blank
    full_name.should == "Amit Kumar Gupta"
  end

  it "should test emails" do
    emails = student_check.emails
    emails.should_not be_blank
    emails.should be_kind_of(Array)
    emails.should == ["amit1@gmail.com", "amit2@gmail.com"]
  end

  it "should test with_emails method" do
    students = StudentCheck.with_emails
    students.should_not be_blank
    students.should be_kind_of(Array)
  end

  it "should get students" do
    StudentCheck.get_students(:year => "2011").all.should be_kind_of(Array)
    StudentCheck.get_students(:year => "2011").should_not be_blank    
  end

end