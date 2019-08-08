create table department
	(dept_name varchar(20), 
	 primary key (dept_name)
	);

create table course
	(course_id varchar(8), 
	 title varchar(50), 
	 dept_name varchar(20),
	 credits numeric(2,0) check (credits > 0),
	 primary key (course_id),
	 foreign key (dept_name) references department
		on delete set null
	);

create table instructor
	(ID varchar(5), 
	 name varchar(20) not null, 
	 dept_name varchar(20), 
	 password varchar(20) not null,
	 primary key (ID),
	 foreign key (dept_name) references department
		on delete set null
	);

create table section
	(course_id varchar(8), 
     sec_id varchar(8),
	 semester varchar(6) check (semester in ('Fall', 'Winter', 'Spring', 'Summer')), 
	 year numeric(4,0) check (year > 1701 and year < 2100),
	 primary key (course_id, sec_id, semester, year),
	 foreign key (course_id) references course
		on delete cascade
	);

create table teaches
	(ID varchar(5), 
	 course_id varchar(8),
	 sec_id varchar(8), 
	 semester varchar(6),
	 year numeric(4,0),
	 primary key (ID, course_id, sec_id, semester, year),
	 foreign key (course_id,sec_id, semester, year) references section
		on delete cascade,
	 foreign key (ID) references instructor
		on delete cascade
	);

create table student
	(ID varchar(5), 
	 name varchar(20) not null, 
	 dept_name varchar(20), 
	 password varchar(20) not null,
	 primary key (ID),
	 foreign key (dept_name) references department
		on delete set null
	);



create table takes
	(ID varchar(5), 
	 course_id varchar(8),
	 sec_id varchar(8), 
	 semester varchar(6),
	 year numeric(4,0),
	 primary key (ID, course_id, sec_id, semester, year),
	 foreign key (course_id,sec_id, semester, year) references section
		on delete cascade,
	 foreign key (ID) references student
		on delete cascade
	);

create table TA
	(ID varchar(5), 
	 course_id varchar(8),
	 sec_id varchar(8), 
	 semester varchar(6),
	 year numeric(4,0),
	 primary key (ID, course_id, sec_id, semester, year),
	 foreign key (course_id,sec_id, semester, year) references section
		on delete cascade,
	 foreign key (ID) references student
		on delete cascade
	);

create table exam
	(exam_id serial primary key,
	 course_id varchar(8),
	 sec_id varchar(8), 
	 semester varchar(6),
	 year numeric(4,0),
	 exam_name varchar(20),
	 weightage numeric(4,0),
	 total_marks numeric(4,0),
	 checking_status BOOLEAN NOT NULL DEFAULT FALSE,
	 exam_date DATE,
	 start_time time,
	 end_time time,
	 upload_end_time time,
	 foreign key (course_id,sec_id, semester, year) references section
	   	);

create table question
	(question_id serial primary key,
	 exam_id integer references exam(exam_id),
	 question_name varchar(5),
	 total_marks numeric(4,0),
	 question_img BYTEA,
	 solution_img BYTEA
 	);

create table submission
	(student_id varchar(5) references student(ID),
	 question_id integer references question(question_id),
	 image_num serial,
	 image BYTEA,
	 primary key (student_id,question_id,image_num)
	);


create table evaluation(
	checker_id varchar(5),
	question_id integer references question(question_id),
	student_id varchar(5) references student(ID),
	marks numeric(4,2),
	comment varchar(256),
	primary key (checker_id,question_id,student_id)
	);


create table assignment(
	question_id integer references question(question_id),
 	checker_id varchar(5),
 	checking_status BOOLEAN NOT NULL DEFAULT FALSE,
 	primary key (checker_id,question_id)

	);
