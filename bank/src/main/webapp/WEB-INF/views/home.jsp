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
	<form id="form" method="post" action="/management">
		<div><input id="username" name="username" placeholder="아이디"></div>
		<div><input id="password" type="password" placeholder="비밀번호"></div>
		<button id="loginBtn" type="submit">로그인</button>
	</form>
	<a href="/register">계좌등록</a><br>
</body>
<script>
document.querySelector("#loginBtn").addEventListener("click",(e)=>{
	e.preventDefault();
	if(document.querySelector("#username").value==""){
		alert("아이디확인")
		return;
	}else if(document.querySelector("#password").value==""){
		alert("패스워드확인")
		return;
	}
	const data = {
	           username: document.querySelector("#username").value,
	           password: document.querySelector("#password").value
	};
	fetch("/login", {
		 method: 'POST',
         headers: {
             'Content-Type': 'application/json'
         },
         body: JSON.stringify(data) 
     })
    .then(response=>{
           if(response.ok){
               return response.text()
           }
       })
    .then(data=>{
    	console.log(data)
    	if(data==0){
    		alert("계정확인")
    	}else{
    		document.querySelector("#form").submit()
    	}
    })
})
</script>
</html>