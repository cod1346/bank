<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form id="form" method="post" action="/register">
		<input id="username" name = "username" placeholder="아이디" type="text"><span id="dupUsername" style="color: red;" hidden="">중복아이디</span><br>
		<input id="password" name="password" placeholder="계좌비밀번호(숫자4자리)" type="password"><br>
		<input id="confirmPassword" placeholder="비밀번호확인" type="password"><button type="button" id="confirmPasswordBtn">비밀번호확인</button><br>
		<input id="name" name = "name" placeholder="이름" type="text"><br>
		<input id="email" name = "email" placeholder="이메일" type="email"><button type="button" id="confirmEmailBtn">이메일인증</button><br>
		<div id="confirmEmail" hidden="">
			<input placeholder="인증번호" id="checkEmail">
			<button type="button" id="checkEmailBtn">인증확인</button>	
			<span id="checkOk" hidden="">인증확인완료</span>
		</div>
		<button id="registerBtn" type="submit">계좌등록</button>
		<div><a href="/">홈으로</a></div>
	</form>
	
</body>
<script>
	var checkPassword = false;
	var checkEmail = false;
	var code = ""
	var dupUsername = false;
	document.querySelector("#confirmEmailBtn").addEventListener("click",()=>{
		code = Math.floor(Math.random() * 9000) + 1000;
		const data = {
		           code: code,
		           to: document.querySelector("#email").value
		};
		fetch("/checkEmail", {
			 method: 'POST',
	            headers: {
	                'Content-Type': 'application/json'
	            },
	            body: JSON.stringify(data) 
	        })
        .then(response=>{
            if(response.ok){
                alert("이메일을 확인해주세요.")
            }else{
                alert("실패")
            }
        })
        document.querySelector("#confirmEmail").removeAttribute("hidden")
	})
	document.querySelector("#checkEmailBtn").addEventListener("click",()=>{
		if(code==document.querySelector("#checkEmail").value){
			alert("같음")
			document.querySelector("#checkOk").removeAttribute("hidden")
			document.querySelector("#checkEmailBtn").setAttribute("hidden","")
			document.querySelector("#confirmEmailBtn").setAttribute("hidden","")
			document.querySelector("#email").readOnly = true;
			document.querySelector("#checkEmail").readOnly = true;
			checkEmail=true
		}else{
			alert("틀림")
		}
	})
	document.querySelector("#confirmPasswordBtn").addEventListener("click",()=>{
		const password = document.querySelector("#password") 
		const confirmPassword = document.querySelector("#confirmPassword")
		if (isNaN(password.value) || password.value.length !== 4) {
 		   alert("비밀번호는 4자리의 숫자로 입력해주세요.");
		}else if(password.value==confirmPassword.value){
			alert("같음")
			password.readOnly = true;
			confirmPassword.readOnly = true;
			checkPassword = true
		}else{
			alert("틀림")
		}
	})
	document.querySelector("#username").addEventListener('input', ()=>{
		fetch("/checkUsername?username="+document.querySelector("#username").value, {
			 method: 'POST' 
	        })
       .then(response=>{
           if(response.ok){
               return response.text()
           }
       }).then(data=>{
    	   if(data==1){
    		   document.querySelector("#dupUsername").removeAttribute("hidden")
			   dupUsername=false
			   console.log("data=1")
			   console.log(dupUsername)
    	   }else{
    		   document.querySelector("#dupUsername").setAttribute("hidden","")
			   dupUsername=true
    	   }
       })
	});
	document.querySelector("#registerBtn").addEventListener('click', (e)=>{
		e.preventDefault();
		if(document.querySelector("#username").value==""){
			alert("아이디를 입력해주세요.")
		}else if(!dupUsername){
			alert("중복아이디입니다.")
		}else if(!checkPassword){
			alert("비밀번호를 확인해주세요.")
		}else if(document.querySelector("#name").value==""){
			alert("이름을 입력해주세요")
		}else if(!checkEmail){
			alert("이메일을 인증해주세요.")
		}else{
			alert("성공")
			document.querySelector("#form").submit()
		}
			
		
	});
	
</script>
</html>