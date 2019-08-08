/**
 * Sample javascript file. Read the contents and understand them, then modify
 * this file for your use case.
 */

var myTable;
var myStr = "";

var QuesImg = "";
var SolImg = "";
var Course_id = "";
var question_id = "";

var iSTA = "0";

function login() {
	myStr = "  <form action=\"javascript:authenticate(ID.value,password.value)\" method=\"post\"> \n"
			+ "           Enter your ID: <input type=\"text\" name = \"ID\" id = \"ID\" ><br><br>\n"
			+ "           Enter your password: <input type=\"password\" name = \"password\" id = \"password\"><br>\n"
			+ "           <input class=\"w3-button w3-black\" type=\"submit\" value = \"Login\"> \n"
			+ "</form> ";
	$('#content').html(myStr);
}

function TAlogin() {
	myStr = "  <form action=\"javascript:TAauthenticate(ID.value,password.value)\" method=\"post\"> \n"
			+ "           Enter your ID: <input type=\"text\" name = \"ID\" id = \"ID\" ><br><br>\n"
			+ "           Enter your password: <input type=\"password\" name = \"password\" id = \"password\"><br>\n"
			+ "           <input class=\"w3-button w3-black\" type=\"submit\" value = \"Login\"> \n"
			+ "</form> ";
	$('#content').html(myStr);
}

function authenticate(ID, password) {
	console.log(ID);
	console.log(password);
	var xhttp;

	xhttp = new XMLHttpRequest();

	xhttp.onreadystatechange = function() {

		if (this.readyState == 4 && this.status == 200) {
			var obj = JSON.parse(this.responseText);
			console.log(this.responseText);
			if ($.trim(obj.status) === "true") {
				loadCourseTable();
			} else {
				alert("Authentication failed please try again");
			}
		}

	};

	xhttp.open("POST", "LoginInstr?userid=" + ID + "&password=" + password,
			true);

	xhttp.send();
}

function TAauthenticate(ID, password) {
	console.log(ID);
	console.log(password);
	var xhttp;

	xhttp = new XMLHttpRequest();

	xhttp.onreadystatechange = function() {

		if (this.readyState == 4 && this.status == 200) {
			var obj = JSON.parse(this.responseText);
			console.log(this.responseText);
			if ($.trim(obj.status) === "true") {
				AvailableQuesTable();
			} else {
				alert("Authentication failed please try again");
			}
		}

	};

	xhttp.open("POST", "TALogin?userid=" + ID + "&password=" + password,
			true);

	xhttp.send();
}


function logout(){
	var xhttp;

	xhttp = new XMLHttpRequest();
	xhttp.open("GET", "Logout", true);

	xhttp.send();
	login();

}

function loadCourseTable() {
	myStr = "<div class=\"w3-bar w3-green w3-xlarge\">" +
		"<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:loadCourseTable()\">Home</button>"
			+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>"
			+ "</div>"
			+ "<div class=\"w3-container\" style=\"margin-top:30px;\">"
			+ "<table id=\"CourseTable\" class=\"cell-border\">"
			+ "<thead>"
			+ "<tr> <th> Sr. No. </th> <th>Course ID</th> <th>Title</th> </tr>"
			+ "</thead>" + "</table>"
			+ "</div>";

	$('#content').html(myStr);

	myTable = $("#CourseTable").DataTable({

		columns : [ {
			data : null
		}, {
			data : "course_id"
		}, {
			data : "title"
		} ],
		columnDefs : [ {
			"searchable" : false,
			"orderable" : false,
			"targets" : 0
		} ],
		order : [ [ 1, 'asc' ] ]
	});

	myTable.on('order.dt search.dt', function() {
		myTable.column(0, {
			search : 'applied',
			order : 'applied'
		}).nodes().each(function(cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();

	$('#CourseTable tbody').on('click', 'tr', function() {
		if ($(this).hasClass('selected')) {
			$(this).removeClass('selected');
		} else {
			myTable.$('tr.selected').removeClass('selected');
			$(this).addClass('selected');
		}

		Course_id = myTable.row(this).data()["course_id"];
		quizpage(myTable.row(this).data()["course_id"]);
		
	});

	myTable.ajax.url("InstrHome").load();

}

function AvailableQuesTable() {
	iSTA = "1";
	myStr = "<div class=\"w3-bar w3-green w3-xlarge\">" +
		"<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:AvailableQuesTable()\">Home</button>"
			+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>"
			+ "</div>"
			+ "<div class=\"w3-container\" style=\"margin-top:30px;\">"
			+ "<table id=\"AvalQuesTable\" class=\"cell-border\">"
			+ "<thead>"
			+ "<tr> <th> Sr. No. </th> <th>Question No.</th> <th>Quiz Name ID</th> <th>Course ID</th> <th>Title</th> </tr>"
			+ "</thead>" + "</table>"
			+ "</div>";

	$('#content').html(myStr);

	myTable = $("#AvalQuesTable").DataTable({

		columns : [ {
			data : null
		}, {
			data : "question_name"
		}, {
			data : "exam_name"
		},{
			data : "course_id"
		},{
			data : "title"
		}],
		columnDefs : [ {
			"searchable" : false,
			"orderable" : false,
			"targets" : 0
		} ],
		order : [ [ 1, 'asc' ] ]
	});

	myTable.on('order.dt search.dt', function() {
		myTable.column(0, {
			search : 'applied',
			order : 'applied'
		}).nodes().each(function(cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();

	$('#AvalQuesTable tbody').on('click', 'tr', function() {
		if ($(this).hasClass('selected')) {
			$(this).removeClass('selected');
		} else {
			myTable.$('tr.selected').removeClass('selected');
			$(this).addClass('selected');
		}

		getQuesSolImg(myTable.row(this).data()["question_id"],myTable.row(this).data()["question_name"]);

	});

	myTable.ajax.url("TAAssignedQues").load();

}

function quizpage(course_id) {
	myStr = "<div class=\"w3-bar w3-green w3-xlarge\">" +
			"<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:loadCourseTable()\">Home</button>"
			+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>"
			+ "<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:createquizPage(\'"
			+ course_id
			+ "\')\">Create quiz for course "
			+ course_id
			+ " </button>"
			+ "<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:viewCourseMarks(\'"+ course_id+ "\')\">View Student scores in course "
			+ course_id
			+ "</button>"
			+ "</div>"
			+ "<div class=\"w3-container\" style=\"margin-top:30px;\">"
			+ "<table id=\"QuizTable\" class=\"display\">"
			+ "<thead>"
			+ "<tr> <th>Quiz Name</th> <th>Weightage</th> <th>Date</th> <th>Exam start time</th> <th>Exam end time</th> <th>checking status</th> </tr>"
			+ "</thead>" + "</table>"
			+ "</div>";

	$('#content').html(myStr);
	myTable = $("#QuizTable").DataTable({
		columns : [ {
			data : "exam_name"
		}, {
			data : "weightage"
		}, {
			data : "exam_date"
		}, {
			data : "start_time"
		}, {
			data : "end_time"
		}, {
			data : "checking_status"
		} ]
	});

	$('#QuizTable tbody').on('click', 'tr', function() {
		if ($(this).hasClass('selected')) {
			$(this).removeClass('selected');
		} else {
			myTable.$('tr.selected').removeClass('selected');
			$(this).addClass('selected');
		}
		questionPage(myTable.row(this).data()["exam_id"],myTable.row(this).data()["exam_name"]);
	});

	myTable.ajax.url("CourseQuizes?course_id=" + course_id).load();
}

function questionPage(exam_id,exam_name) {

	console.log(exam_id);
	myStr = "<div class=\"w3-bar w3-green w3-xlarge\">" 
			+ "<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:loadCourseTable()\">Home</button>"
			+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>" 
			+ "<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"viewQuizMarks(\'"+ exam_id+ "\',\'"+ exam_name+ "\')\">View Student Marks for " +exam_name +" </button>"
			+ "<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"UpdateQuizPage(\'"+ exam_id+ "\',\'"+ exam_name+ "\')\">Change " +exam_name +" Details </button>" 
			+ "<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"MarkQuizChecked(\'"+ exam_id+ "\',\'"+ exam_name+ "\')\">Mark Quiz Checked </button>" 
			+ "</div>"
			+ "<div class=\"w3-container\" style=\"margin-top:30px;\">"
			+ "<table id=\"QuestionTable\" class=\"display\">" + "<thead>"
			+ "<tr> <th>Question Number</th> <th>Total Marks</th></tr>"
			+ "</thead>" + "</table>"
			+ "<button onclick=\"javascript:createquestionPage(\'" + exam_id
			+ "\')\">Add Question</button>"
			+ "</div>";

	$('#content').html(myStr);

	myTable = $("#QuestionTable").DataTable({
		columns : [ {
			data : "question_name"
		}, {
			data : "total_marks"
		} ]
	});

	$('#QuestionTable tbody').on('click', 'tr', function() {
		if ($(this).hasClass('selected')) {
			$(this).removeClass('selected');
		} else {
			myTable.$('tr.selected').removeClass('selected');
			$(this).addClass('selected');
		}
		getQuesSolImg(myTable.row(this).data()["question_id"],myTable.row(this).data()["question_name"]);

	});

	myTable.ajax.url("QuizQuestions?exam_id=" + exam_id).load();
}

function MarkQuizChecked(exam_id,exam_name) {

		var xhttp;

		xhttp = new XMLHttpRequest();

		xhttp.onreadystatechange = function() {

			if (this.readyState == 4 && this.status == 200) {
				var obj = JSON.parse(this.responseText);
				console.log(this.responseText);
				console.log(obj.status);
				if ($.trim(obj.status) === "true") {
					alert(exam_name + " Marked Checked and sent to student");
					questionPage(exam_id,exam_name);
				} else {
					alert( exam_name +"is Already Marked checked");
					questionPage(exam_id,exam_name);

				}

			}
		};

		xhttp.open("GET", "MarkExam?exam_id="+exam_id, true);

		xhttp.send();


}

function getQuesSolImg(question_id,question_name) {

	var xhttp;

	// $("#ConversationTable").hide();

	xhttp = new XMLHttpRequest();

	xhttp.onreadystatechange = function() {

		currImg = 0;

		if (this.readyState == 4 && this.status == 200) {

			var obj = JSON.parse(this.responseText);
			QuesImg = obj.data[0].question_img
			SolImg = obj.data[0].solution_img

		}

		console.log(QuesImg);
		console.log(SolImg);
		attemptsPage(question_id,question_name);

	};

	xhttp.open("GET", "QuesSolImg?question_id=" + question_id, true);
	xhttp.send();

}

function UpdateQuestionPage(question_id,question_name){
	
	SolImg = "";
	QuesImg = "";
	myStr = "<div class=\"w3-bar w3-green w3-xlarge\">" +
	"<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:loadCourseTable()\">Home</button>"
	+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>"
	+ "</div> <br><br>"
		+ "<form action=\"javascript:Updatequestion(\'"
		+ question_id
		+ "\',tot_marks.value,qno.value)\" method=\"post\"> \n"
		+ "Enter Question No.: <input type=\"number\" name = \"qno\" id = \"qno\" min = \"0\" max = \"100\" ><br><br>"
		+ "Enter Maximum marks: <input type=\"number\" name = \"tot_marks\" id = \"tot_marks\" min = \"0\" max = \"10000\" ><br><br>"
		+ "<label for=\"ques_img\">Upload Question Image:</label><br>"
		+ "<input type=\"file\" id=\"ques_img\" name=\"ques_img\" accept=\"image/png, image/jpeg\" /><br><br>"
		+ "<label for=\"sol_img\">Upload Solution Image:</label><br>"
		+ "<input type=\"file\" id=\"sol_img\" name=\"sol_img\" accept=\"image/png, image/jpeg\" /><br><br>"
		+ "<input type=\"submit\" value = \"Create Question\"> \n"
		+ "</form><br> ";

$('#content').html(myStr);

function readQuesFile() {

	if (this.files && this.files[0]) {

		var FR = new FileReader();

		FR.addEventListener("load", function(e) {
			QuesImg = e.target.result;
			console.log(QuesImg);
		});

		FR.readAsDataURL(this.files[0]);
	}

}

function readSolFile() {

	if (this.files && this.files[0]) {

		var FR = new FileReader();

		FR.addEventListener("load", function(e) {
			SolImg = e.target.result;
			console.log(SolImg);

		});
		FR.readAsDataURL(this.files[0]);
	}
}

document.getElementById("ques_img")
		.addEventListener("change", readQuesFile);
document.getElementById("sol_img").addEventListener("change", readSolFile);

}

function Updatequestion(question_id, total_marks, question_num){
	
	var Str = "question_id="+question_id;

	if(total_marks !== 'null' && total_marks !== 'undefined' && total_marks ){
		Str += "&total_marks="+total_marks;
	}
	if(question_num !== 'null' && question_num !== 'undefined' && question_num ){
		Str += "&ques_name="+question_num;
	}
	if(SolImg !== 'null' && SolImg !== 'undefined' && SolImg ){
		Str += "&SolImg="+SolImg;
	}
	if(QuesImg !== 'null' && QuesImg !== 'undefined' && QuesImg ){
		Str += "&QuesImg="+QuesImg;
	}
	
	var xhttp;

	xhttp = new XMLHttpRequest();

	xhttp.onreadystatechange = function() {

		if (this.readyState == 4 && this.status == 200) {
			var obj = JSON.parse(this.responseText);
			console.log(this.responseText);
			console.log(obj.status);
			if ($.trim(obj.status) === "true") {
				alert("Question created");
				questionPage(exam_id);
			} else {
				alert("failed to create question");
			}

		}
	};

	xhttp.open("POST", "UpdateQuestion", true);
	var qimg = encodeURIComponent(QuesImg);
	console.log("encoded uri" + qimg);

	var simg = encodeURIComponent(SolImg);
	xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhttp.send(Str);
}

function UpdateQuizPage(quiz_id,quiz_name){
	myStr = "<div class=\"w3-bar w3-green w3-xlarge\">" +
	"<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:loadCourseTable()\">Home</button>"
	+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>"
	+ "</div> <br><br>"
		+ "  <form action=\"javascript:Updatequiz(\'"
		+ quiz_id
		+ "\',ex_name.value,weightage.value,tot_marks.value,ex_date.value,ex_s_time.value,ex_e_time.value,ex_ue_time.value)\" method=\"post\"> \n"
		+ "   Enter Exam Name: <input type=\"text\" name = \"ex_name\" id = \"ex_name\" ><br><br>\n"
		+ "   Enter Exam Weightage: <input type=\"number\" name = \"weightage\" id = \"weightage\" min = \"0\" max = \"100\"  ><br><br>\n"
		+ "   Enter Maximum marks: <input type=\"number\" name = \"tot_marks\" id = \"tot_marks\" min = \"0\" max = \"10000\"  ><br><br>\n"
		+ "   Enter Date of examination: <input type=\"date\" name = \"ex_date\" id = \"ex_date\" ><br><br>\n"
		+ "   Enter Start time of examination: <input type=\"time\" name = \"ex_s_time\" id = \"ex_s_time\" ><br><br>\n"
		+ "   Enter End time of examination: <input type=\"time\" name = \"ex_e_time\" id = \"ex_e_time\" ><br><br>\n"
		+ "   Enter Upload End time of examination: <input type=\"time\" name = \"ex_ue_time\" id = \"ex_ue_time\" ><br><br>\n"
		+ "   <input type=\"submit\" value = \"Create Exam\"> \n"
		+ "</form> ";
$('#content').html(myStr);

}

function Updatequiz(quiz_id, ex_name, weightage, tot_marks, ex_date,
		ex_s_time, ex_e_time, ex_ue_time){
	
	var Str = "UpdateQuiz?quiz_id="+quiz_id;
	
	if(ex_name !== 'null' && ex_name !== 'undefined' && ex_name ){
		Str += "&exam_name="+ex_name;
	}
	if(weightage !== 'null' && weightage !== 'undefined' && weightage ){
		Str += "&weightage="+weightage;
	}
	if(tot_marks !== 'null' && tot_marks !== 'undefined' && tot_marks ){
		Str += "&total_marks="+tot_marks;
	}
	if(ex_date !== 'null' && ex_date !== 'undefined' && ex_date ){
		Str += "&date="+ex_date;
	}
	if(ex_s_time !== 'null' && ex_s_time !== 'undefined' && ex_s_time ){
		Str += "&start_time="+ex_s_time;
	}
	if(ex_e_time !== 'null' && ex_e_time !== 'undefined' && ex_e_time ){
		Str += "&end_time="+ex_e_time;
	}
	if(ex_ue_time !== 'null' && ex_ue_time !== 'undefined' && ex_ue_time ){
		Str += "&upload_end_time="+ex_ue_time;
	}
	var xhttp;

	xhttp = new XMLHttpRequest();

	xhttp.onreadystatechange = function() {

		if (this.readyState == 4 && this.status == 200) {
			var obj = JSON.parse(this.responseText);
			console.log(this.responseText);
			console.log(obj.status);
			if ($.trim(obj.status) === "true") {
				alert("quiz created");
				quizpage(course_id);
			} else {
				alert("failed to create quiz");
			}

		}
	};
	console.log(Str);

	xhttp.open("GET", Str, true);

	xhttp.send();

}


function AssignTAPage(question_id){
	
	console.log(question_id + "AssignTAPAGE");
	var myStr = 
		"<div class=\"w3-bar w3-green w3-xlarge\">" +
		"<button class=\"w3-bar-item w3-button w3-xlarge\"  onclick=\"javascript:loadCourseTable()\">Home</button>"
		+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>" + 
		"</div>" +
		"<div class=\"w3-container\" style=\"margin-top:30px;\">"+
			"<table id=\"TATable\" class=\"display\">" + "<thead>"
			+ "<tr> <th>TA ID</th> <th>TA Name</th></tr>"
			+ "</thead>" + "</table>"
			+"</div>";
	
	console.log(myStr);
	$('#content').html(myStr);

	myTable = $("#TATable").DataTable({
		columns : [ {
			data : "id"
		}, {
			data : "name"
		} ]
	});

	$('#TATable tbody').on('click', 'tr', function() {
		if ($(this).hasClass('selected')) {
			$(this).removeClass('selected');
		} else {
			myTable.$('tr.selected').removeClass('selected');
			$(this).addClass('selected');
		}

		AssignTA(myTable.row(this).data()["id"], question_id);
	});
	myTable.ajax.url("TAList?question_id=" + question_id).load();
}

function AssignTA(id,question_id){

		var xhttp;

		xhttp = new XMLHttpRequest();

		xhttp.onreadystatechange = function() {

			if (this.readyState == 4 && this.status == 200) {
				var obj = JSON.parse(this.responseText);
				console.log(this.responseText);
				console.log(obj.status);
				if ($.trim(obj.status) === "true") {
					alert("TA Assigned");
					attemptsPage(question_id);
				} else {
					alert("TA already Assigned");
					attemptsPage(question_id);
				}

			}
		};

		xhttp.open("GET", "AssignTA?id=" + id + "&question_id=" + question_id, true);
		
		xhttp.send();
}

function attemptsPage(question_id,question_name) {
	console.log(question_id);
	var myStr1 = "<div class=\"w3-bar w3-green w3-xlarge\">" 
		+ "<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:loadCourseTable()\">Home</button>"
		+ "<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"viewQuestionMarks(\'"+ question_id + "\',\'"+ question_name + "\')\">View Student Marks for " + question_name +" </button>" 
		+ "<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"UpdateQuestionPage(\'"+ question_id + "\',\'"+ question_name + "\')\">Change " + question_name +" Details</button>" 
		+ "<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"AssignTAPage(\'"+ question_id + "\')\">Assign TA</button>" 
		+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>" +
		"</div>"
		+ "<div class=\"w3-container\" style=\"margin-top:30px;\">" +
		"<table id=\"StuTable\" class=\"display\">" + "<thead>"
			+ "<tr> <th> </th> <th>Student ID</th> <th>Student Name</th></tr>"
			+ "</thead>" + "</table>"
			+ "</div>";
	
	var myStr2 = "<div class=\"w3-bar w3-green w3-xlarge\">" 
	+ "<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:AvailableQuesTable()\">Home</button>"
	+ "<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"viewQuestionMarks(\'"+ question_id + "\',\'"+ question_name + "\')\">View Student Marks for " + question_name +" </button>" 
	+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>" +
	"</div>"
	+ "<div class=\"w3-container\" style=\"margin-top:30px;\">" +
	"<table id=\"StuTable\" class=\"display\">" + "<thead>"
		+ "<tr> <th> </th> <th>Student ID</th> <th>Student Name</th></tr>"
		+ "</thead>" + "</table>"
		+ "</div>";
	
	if(iSTA === "1"){
	$('#content').html(myStr2);
	}
	if(iSTA === "0"){
	$('#content').html(myStr1);
	}
	myTable = $("#StuTable").DataTable({
		columns : [{
				data : null
			}, {
			data : "id"
		}, {
			data : "name"
		} ],
	columnDefs : [ {
		"searchable" : false,
		"orderable" : false,
		"targets" : 0
	} ],
	order : [ [ 1, 'asc' ] ]
	});

myTable.on('order.dt search.dt', function() {
	myTable.column(0, {
		search : 'applied',
		order : 'applied'
	}).nodes().each(function(cell, i) {
		cell.innerHTML = i + 1;
	});
}).draw();
	$('#StuTable tbody').on('click', 'tr', function() {
		if ($(this).hasClass('selected')) {
			$(this).removeClass('selected');
		} else {
			myTable.$('tr.selected').removeClass('selected');
			$(this).addClass('selected');
		}

		checkQuestion(myTable.row(this).data()["id"], question_id);

	});

	myTable.ajax.url("QuestionAttempts?question_id=" + question_id).load();
}

function showQuesImg() {
	$('#myimg').attr("src", QuesImg);
}


function showSolImg() {
	$('#myimg').attr("src", SolImg);
}

function toggleimg(img) {
	$('#myimg').attr("src", img);
}

function checkQuestion(id, question_id) {

	console.log("in checkQuestion");
	console.log(question_id);
	console.log(id);

	var xhttp;

	xhttp = new XMLHttpRequest();

	xhttp.onreadystatechange = function() {
		var myTable = "";
		currImg = 0;
		if(iSTA === "0"){
			mytable = 
				"<div class=\"w3-bar w3-green w3-xlarge\">" +
				"<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:loadCourseTable()\">Home</button>"
				+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\"  onclick=\"javascript:logout()\">Logout</button> <br><br>"
				+ "</div>";
		}
		if(iSTA === "1"){
			 mytable = 
					"<div class=\"w3-bar w3-green w3-xlarge\">" +
					"<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:AvailableQuesTable()\">Home</button>"
					+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\"  onclick=\"javascript:logout()\">Logout</button> <br><br>"
					+ "</div>";
			}
		if (this.readyState == 4 && this.status == 200) {
			var obj = JSON.parse(this.responseText);

			if (!obj.data || obj.data === 'null' || obj.data === 'undefined') {
				alert("Solution not yet available for this student for checking");
				return;
			}

			mytable += "<div id=\"wrapper\" class=\"w3-card-4\">\r\n"
					+ "  <div id=\"first\" style=\"margin-left:5%;float: left;width:70%\">first</div>\r\n"
					+ "  <div id=\"second\" style=\"float: right;width:25%;height:100%;background-color: #f2f2f2;\">second</div>\r\n"
					+ "  <div id=\"third\" style=\"clear: both\"></div>\r\n"
					+ "</div>";

			var firstdiv = "";
			var seconddiv = "";
			// mytable += "List of Images <br><br>";
			seconddiv += "<div id=\"formButton\" class=\"w3-container\">";

			seconddiv += "<p>"
			for (x in obj.data) {
				console.log("x is" + x);
				y = (x * 1) + (1 * 1);
				seconddiv += "<button  class=\"w3-btn w3-ripple w3-black w3-round-large\" style=\"margin:5px;\" onclick=\"toggleimg(\'"
						+ decodeURIComponent(obj.data[x].image) + "\')\">" + y + "</button>";
			}

			seconddiv += "</p>"

			seconddiv += "<br><br>";

			seconddiv += "<button onclick=\"javascript:showQuesImg()\">View Question Image</button> <br><br>"
					+ "<button onclick=\"javascript:showSolImg()\">View Solution Image</button> <br><br>";
				
			seconddiv += 
				"  <form action=\"javascript:MarksInsert(\'"+ id +"\',\'"+ question_id +"\',marks.value,comment.value)\" method=\"post\"> \n" +
				"       <div class = \"w3-group\">\r\n" + 
				"            <label class = \"w3-label\">Marks</label><br>" + 
				"            <input id=\"marks\" class = \"w3-input\" type = \"text\" style = \"width:90%\" required>\r\n" + 
				"         </div>\r\n" + 
				"         <br>" + 
				"         <div class = \"w3-group\">\r\n" + 
				"            <label class = \"w3-label\">Comments</label><br>" + 
				"            <textarea id=\"comment\" class = \"w3-input\" style = \"width:90%\" required></textarea>\r\n" + 
				"         </div><br><br>"
				+ "   <input type=\"submit\" value = \"Update Marks\"> \n" + "</form> ";
			
			seconddiv += "</div>";
			
			firstdiv += "<div id=\"image\ class=\"w3-container\">";
			firstdiv += "<img id=\"myimg\" width=\"100%\" src=\""
					+ decodeURIComponent(obj.data[0].image) + "\">";
			firstdiv += "</div>";

			$('#content').html(mytable);
			$('#first').html(firstdiv);
			$('#second').html(seconddiv);

		}

	};

	xhttp.open("GET", "QuestionImages?stu_id=" + id + "&question_id="
			+ question_id, true);

	xhttp.send();

}

function MarksInsert(id,question_id,marks,comment){
	console.log(id);
	console.log(question_id);
	console.log(marks);
	console.log(comment);


		var xhttp;

		xhttp = new XMLHttpRequest();

		xhttp.onreadystatechange = function() {

			if (this.readyState == 4 && this.status == 200) {
				var obj = JSON.parse(this.responseText);
				console.log(this.responseText);
				console.log(obj.status);
				if ($.trim(obj.status) === "true") {
					alert("Marks Updated");
					attemptsPage(question_id);
				} else {
					alert("failed to Update Marks");
					attemptsPage(question_id);
				}

			}
		};

		xhttp.open("GET", "InsertMarks?id=" + id + "&question_id="
				+ question_id + "&marks=" + marks + "&comment=" + comment, true);

		xhttp.send();

}

function createquizPage(course_id) {

	console.log("in create with id = " + course_id);
	// ///
	// quizpage(course_id);
	// /////
	myStr = "<div class=\"w3-bar w3-green w3-xlarge\">" +
	"<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:loadCourseTable()\">Home</button>"
	+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>"
	+ "</div> <br><br>"
			+ "  <form action=\"javascript:createquiz(\'"
			+ course_id
			+ "\',ex_name.value,weightage.value,tot_marks.value,ex_date.value,ex_s_time.value,ex_e_time.value,ex_ue_time.value)\" method=\"post\"> \n"
			+ "   Enter Exam Name: <input type=\"text\" name = \"ex_name\" id = \"ex_name\" ><br><br>\n"
			+ "   Enter Exam Weightage: <input type=\"number\" name = \"weightage\" id = \"weightage\" min = \"0\" max = \"100\"  ><br><br>\n"
			+ "   Enter Maximum marks: <input type=\"number\" name = \"tot_marks\" id = \"tot_marks\" min = \"0\" max = \"10000\"  ><br><br>\n"
			+ "   Enter Date of examination: <input type=\"date\" name = \"ex_date\" id = \"ex_date\" ><br><br>\n"
			+ "   Enter Start time of examination: <input type=\"time\" name = \"ex_s_time\" id = \"ex_s_time\" ><br><br>\n"
			+ "   Enter End time of examination: <input type=\"time\" name = \"ex_e_time\" id = \"ex_e_time\" ><br><br>\n"
			+ "   Enter Upload End time of examination: <input type=\"time\" name = \"ex_ue_time\" id = \"ex_ue_time\" ><br><br>\n"
			+ "   <input type=\"submit\" value = \"Create Exam\"> \n"
			+ "</form> ";
	$('#content').html(myStr);

}

function createquiz(course_id, ex_name, weightage, tot_marks, ex_date,
		ex_s_time, ex_e_time, ex_ue_time) {
	console.log(ex_name);
	console.log(weightage);
	console.log(tot_marks);
	console.log(ex_date);
	console.log(ex_s_time);
	console.log(ex_e_time);
	console.log(ex_ue_time);

	var xhttp;

	xhttp = new XMLHttpRequest();

	xhttp.onreadystatechange = function() {

		if (this.readyState == 4 && this.status == 200) {
			var obj = JSON.parse(this.responseText);
			console.log(this.responseText);
			console.log(obj.status);
			if ($.trim(obj.status) === "true") {
				alert("quiz created");
				quizpage(course_id);
			} else {
				alert("failed to create quiz");
			}

		}
	};

	xhttp.open("GET", "CreateQuiz?course_id=" + course_id + "&exam_name="
			+ ex_name + "&weightage=" + weightage + "&total_marks=" + tot_marks
			+ "&date=" + ex_date + "&start_time=" + ex_s_time + "&end_time="
			+ ex_e_time + "&upload_end_time=" + ex_ue_time, true);

	xhttp.send();

}

function createquestionPage(exam_id) {

	myStr = "<div class=\"w3-bar w3-green w3-xlarge\">" +
	"<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:loadCourseTable()\">Home</button>"
	+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>"
	+ "</div> <br><br>"
			+ "<form action=\"javascript:addquestion(\'"
			+ exam_id
			+ "\',tot_marks.value,qno.value)\" method=\"post\"> \n"
			+ "Enter Question No.: <input type=\"number\" name = \"qno\" id = \"qno\" min = \"0\" max = \"100\" ><br><br>"
			+ "Enter Maximum marks: <input type=\"number\" name = \"tot_marks\" id = \"tot_marks\" min = \"0\" max = \"10000\" ><br><br>"
			+ "<label for=\"ques_img\">Upload Question Image:</label><br>"
			+ "<input type=\"file\" id=\"ques_img\" name=\"ques_img\" accept=\"image/png, image/jpeg\" /><br><br>"
			+ "<label for=\"sol_img\">Upload Solution Image:</label><br>"
			+ "<input type=\"file\" id=\"sol_img\" name=\"sol_img\" accept=\"image/png, image/jpeg\" /><br><br>"
			+ "<input type=\"submit\" value = \"Create Question\"> \n"
			+ "</form><br> ";

	$('#content').html(myStr);

	function readQuesFile() {

		if (this.files && this.files[0]) {

			var FR = new FileReader();

			FR.addEventListener("load", function(e) {
				QuesImg = e.target.result;
				console.log(QuesImg);
			});

			FR.readAsDataURL(this.files[0]);
		}

	}

	function readSolFile() {

		if (this.files && this.files[0]) {

			var FR = new FileReader();

			FR.addEventListener("load", function(e) {
				SolImg = e.target.result;
				console.log(SolImg);

			});
			FR.readAsDataURL(this.files[0]);
		}
	}

	document.getElementById("ques_img")
			.addEventListener("change", readQuesFile);
	document.getElementById("sol_img").addEventListener("change", readSolFile);

}

function addquestion(exam_id, total_marks, question_num) {
	console.log(exam_id);
	console.log(question_num);
	console.log(total_marks);

	var xhttp;

	xhttp = new XMLHttpRequest();

	xhttp.onreadystatechange = function() {

		if (this.readyState == 4 && this.status == 200) {
			var obj = JSON.parse(this.responseText);
			console.log(this.responseText);
			console.log(obj.status);
			if ($.trim(obj.status) === "true") {
				alert("Question created");
				questionPage(exam_id);
			} else {
				alert("failed to create question");
			}

		}
	};

	xhttp.open("POST", "CreateQuestion", true);
	var qimg = encodeURIComponent(QuesImg);
	console.log("encoded uri" + qimg);

	var simg = encodeURIComponent(SolImg);
	xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhttp.send("exam_id=" + exam_id + "&ques_name=" + question_num
			+ "&total_marks=" + total_marks + "&QuesImg=" + qimg + "&SolImg="
			+ simg);
}

function viewCourseMarks(course_id) {
	myStr = "<div class=\"w3-bar w3-green w3-xlarge\">" +
			"<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:loadCourseTable()\">Home</button>"
			+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>"
			+ "</div>"
			+ "<div class=\"w3-container\" style=\"margin-top:30px;\">"
			+ "<table id=\"DisplayCourseCredits\" class=\"cell-border\">"
			+ "<thead>"
			+ "<tr> <th> Sr. No. </th> <th>Student ID</th> <th>Student Name</th> <th>Weighted Average Marks Obtained in "+ course_id + "</th> </tr>"
			+ "</thead>" + "</table>"
			+ "</div>";

	$('#content').html(myStr);

	myTable = $("#DisplayCourseCredits").DataTable({

		columns : [ {
			data : null
		}, {
			data : "id"
		}, {
			data : "name"
		}, {
			data : "marks"
		} ],
		columnDefs : [ {
			"searchable" : false,
			"orderable" : false,
			"targets" : 0
		} ],
		order : [ [ 1, 'asc' ] ]
	});

	myTable.on('order.dt search.dt', function() {
		myTable.column(0, {
			search : 'applied',
			order : 'applied'
		}).nodes().each(function(cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();

	myTable.ajax.url("CourseGrades?course_id=" + course_id).load();

}

function viewQuizMarks(exam_id,exam_name) {
	
	myStr = "<div class=\"w3-bar w3-green w3-xlarge\">" +
			"<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:loadCourseTable()\">Home</button>"
			+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>"
			+ "</div>" +
			"<div class=\"w3-container\" style=\"margin-top:30px;\">"
			+ "<table id=\"DisplayQuizCredits\" class=\"cell-border\">"
			+ "<thead>"
			+ "<tr> <th> Sr. No. </th> <th>Student ID</th> <th>Student Name</th> <th>Total Marks Obtained in " + exam_name+ "</th> </tr>"
			+ "</thead>" + "</table>"
			+ "</div>";

	$('#content').html(myStr);

	myTable = $("#DisplayQuizCredits").DataTable({

		columns : [ {
			data : null
		}, {
			data : "id"
		}, {
			data : "name"
		}, {
			data : "marks"
		} ],
		columnDefs : [ {
			"searchable" : false,
			"orderable" : false,
			"targets" : 0
		} ],
		order : [ [ 1, 'asc' ] ]
	});

	myTable.on('order.dt search.dt', function() {
		myTable.column(0, {
			search : 'applied',
			order : 'applied'
		}).nodes().each(function(cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();

	myTable.ajax.url("QuizGrades?exam_id=" + exam_id).load();

}

function viewQuestionMarks(question_id,question_name) {
	
	myStr = "<div class=\"w3-bar w3-green w3-xlarge\">" +
			"<button class=\"w3-bar-item w3-button w3-xlarge\" onclick=\"javascript:loadCourseTable()\">Home</button>"
			+ "<button class=\"w3-bar-item w3-button w3-xlarge\" style=\"float:right\" onclick=\"javascript:logout()\">Logout</button>"
			+ "</div>"
			+ "<div class=\"w3-container\" style=\"margin-top:30px;\">"
			+ "<table id=\"DisplayQuestionCredits\" class=\"cell-border\">"
			+ "<thead>"
			+ "<tr> <th> Sr. No. </th> <th>Student ID</th> <th>Student Name</th> <th>Marks</th> </tr>"
			+ "</thead>" + "</table>"
			+ "</div>";

	$('#content').html(myStr);

	myTable = $("#DisplayQuestionCredits").DataTable({

		columns : [ {
			data : null
		}, {
			data : "id"
		}, {
			data : "name"
		}, {
			data : "marks"
		} ],
		columnDefs : [ {
			"searchable" : false,
			"orderable" : false,
			"targets" : 0
		} ],
		order : [ [ 1, 'asc' ] ]
	});

	myTable.on('order.dt search.dt', function() {
		myTable.column(0, {
			search : 'applied',
			order : 'applied'
		}).nodes().each(function(cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();

	myTable.ajax.url("QuestionGrades?question_id=" + question_id).load();

}