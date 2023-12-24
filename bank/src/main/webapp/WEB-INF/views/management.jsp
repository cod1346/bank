<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
</head>
<body style="padding: 10px;">
	<button type="button" class="btn btn-primary recordBtn" data-bs-toggle="modal" data-bs-target="#exampleModal">
	  최근 거래내역 보기
	</button>
	<div>계좌번호 : ${dto.accountNo }</div>
	<div>잔액 : ${dto.balance }</div>
	
	<button type="button" class="showDeposit" data-bs-toggle="modal" data-bs-target="#exampleModal">보유중인 예금보기</button><br>
	<button type="button" class="showSaving" data-bs-toggle="modal" data-bs-target="#exampleModal">보유중인 적금보기</button><br>
	
	<button type="button" id="insert">입금</button><br>
	<button type="button" id="withdraw">출금(수수료5%)</button><br>
	<button type="button" id="transfer">송금(수수료3%)</button><br>
	<button type="button" id="deposit">예금(1분당20% 단리)</button><br>
	<button type="button" id="saving">적금(2분당 7% 복리)</button><br>
	<div hidden="" id="transferDiv">
		<span>계좌번호</span><input id="transferNo"><button type="button" id="checkTransferNoBtn">계좌번호확인</button>
	</div>
	<div id="numberDiv" hidden="">
		<span id="type"></span><span id="insertValue"></span>
		<select hidden="" id="period">
			<option value="">기간
			<option value="3">3분
			<option value="5">5분
			<option value="7">7분
		</select>
		<span hidden="" id='charge'>(수수료 : <span id='chargeValue'></span><span>)</span></span>
		<br>
		<button type="button" class="numberBtn">1</button><button type="button" class="numberBtn">2</button><button type="button" class="numberBtn">3</button><button type="button" id="remove">←</button><br>
		<button type="button" class="numberBtn">4</button><button type="button" class="numberBtn">5</button><button type="button" class="numberBtn">6</button><br>
		<button type="button" class="numberBtn">7</button><button type="button" class="numberBtn">8</button><button type="button" class="numberBtn">9</button><br>
		<button type="button" class="numberBtn">0</button><button type="button" id="clear">clear</button>
		<button style="color: blue;" id="confirmBtn"></button>
		<span></span>
	</div>
	
	<div hidden="">
		<input hidden="" id="accountNo" value="${dto.accountNo }">계좌번호
		<input hidden="" id="balance" value="${dto.balance }">잔액
	</div>
	<!-- 
		const data = {
            accountNo : 계좌번호 ,
            type: 입금,출금,송금,적금,예금 ,
            balance : 잔액 ,
            value : 금액 ,
            time: 시간 
        };
	 -->
	
	<!-- Modal -->
	<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog modal-xl">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="exampleModalLabel">최근 거래내역</h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body"> 
	       
	       <!-- 예적금 목록 -->
	       <table class="table depositTable" hidden="">
			  <thead>
			    <tr>
			      <th scope="col">거래시간</th>
			      <th scope="col">원금</th>
			      <th scope="col">이자</th> 
			      <th scope="col">만기일</th>
			      <th scope="col"></th>
			    </tr>
			  </thead>
			  <tbody id="depositList">
			  </tbody>
			</table>
			
	        <table class="table savingTable" hidden="">
			  <thead>
			    <tr>
			      <th scope="col">거래시간</th>
			      <th scope="col">원금</th>
			      <th scope="col">현재금액</th>
			      <th scope="col">만기일</th> 
			      <th scope="col"></th>
			    </tr>
			  </thead>
			  <tbody id="savingList">
			  </tbody>
			</table>
	        <!-- 거래내역 -->
	        <table class="table recordTable" hidden="">
			  <thead>
			    <tr>
			      <th scope="col">타입</th>
			      <th scope="col">거래시간</th>
			      <th scope="col">금액</th>
			      <th scope="col">수수료</th>
			      <th scope="col">잔액</th>
			    </tr>
			  </thead>
			  <tbody id="recordList">
			  </tbody>
			</table>
			
	      </div>
	    </div>
	  </div>
	</div>
</body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
<script>
const accountNo = document.querySelector("#accountNo").value
console.log()
function doAct(type){
	document.querySelector("#period").value=""
	document.querySelector("#period").setAttribute("hidden","")
	document.querySelector("#chargeValue").innerHTML=''
	document.querySelector("#charge").setAttribute("hidden","")
	document.querySelector("#transferNo").value=''
	document.querySelector("#insertValue").innerHTML=''
    document.querySelector("#numberDiv").removeAttribute("hidden")
	document.querySelector("#type").innerHTML=type+"액 : "
	document.querySelector("#confirmBtn").innerHTML=type
    document.querySelector("#transferDiv").setAttribute("hidden","")
    if(type=='출금'||type=='송금'){
    	document.querySelector("#charge").removeAttribute("hidden")
    }
    if(type=='적금'||type=='예금'){
    	document.querySelector("#period").removeAttribute("hidden")
    }
   
}

document.querySelector("#remove").addEventListener("click",()=>{
	document.querySelector("#insertValue").innerHTML=document.querySelector("#insertValue").innerHTML.slice(0, -1)
})
document.querySelector("#clear").addEventListener("click",()=>{
	document.querySelector("#insertValue").innerHTML="";
})

document.querySelector("#insert").addEventListener("click",()=>{
    doAct("입금")
})
document.querySelector("#withdraw").addEventListener("click",()=>{
    doAct("출금")
})
document.querySelector("#transfer").addEventListener("click",()=>{
    doAct("송금")
    document.querySelector("#transferDiv").removeAttribute("hidden")
})
document.querySelector("#deposit").addEventListener("click",()=>{
    doAct("예금")
})
document.querySelector("#saving").addEventListener("click",()=>{
    doAct("적금")
})
var charge = 0
document.querySelectorAll(".numberBtn").forEach(btn => {
    btn.addEventListener("click",(e)=>{
    	charge = 0
	    document.querySelector("#insertValue").innerHTML+=e.target.innerHTML;
	    
    	let insertValue = parseInt(document.querySelector("#insertValue").innerHTML);
    	let chargeValueWith = isNaN(Math.round(insertValue / 100*5)) ? 0 : Math.round(insertValue / 100 * 5);
    	let chargeValueTrans = isNaN(Math.round(insertValue / 100*3)) ? 0 : Math.round(insertValue / 100* 3);
    	console.log(Math.round(insertValue/100*3))
    	if(document.querySelector("#confirmBtn").innerHTML=='출금'){
    		document.querySelector("#chargeValue").innerHTML=chargeValueWith
    		charge = chargeValueWith
	   	}else if(document.querySelector("#confirmBtn").innerHTML=='송금'){
    		document.querySelector("#chargeValue").innerHTML=chargeValueTrans
    		charge = chargeValueTrans
   	    }
	    //Math.round(num * 10) / 10
    	if(document.querySelector("#confirmBtn").innerHTML!="입금"&&parseInt(document.querySelector("#insertValue").innerHTML)+(Math.round(parseInt(document.querySelector("#insertValue").innerHTML)/100*5))	>parseInt(document.querySelector("#balance").value)){
    		
    		alert("잔액이 부족합니다")		
    		document.querySelector("#insertValue").innerHTML=document.querySelector("#insertValue").innerHTML.slice(0, -1)
    	}
    })
});
var transferNoBool = false
var name = ''
document.querySelector("#transferNo").addEventListener('input', ()=>{
	transferNoBool = false
})
document.querySelector("#checkTransferNoBtn").addEventListener('click', ()=>{
	fetch("/checkTransferNo?accountNo="+document.querySelector("#transferNo").value)
	.then(response=>{
		if(!response.ok){
			alert("계좌번호 없음")
  		    throw new Error('계좌번호 없음');
		}
        return response.text()
    }).then(data=>{
       transferNoBool=true
 	   alert("'"+data+"'님")
 	   name = data
    })
    .catch(error => {
        console.error('계좌번호 없음');
    });
})

document.querySelector("#confirmBtn").addEventListener("click",()=>{
	if(document.querySelector("#insertValue").innerHTML<1){
		alert("금액을 확인해주세요.")
	}else{
		if(document.querySelector("#confirmBtn").innerHTML!="입금"&&document.querySelector("#insertValue").value)
   		var type=""
   		if(document.querySelector("#confirmBtn").innerHTML=="입금"){
			type="insert"
			record(type)
		}else if(document.querySelector("#confirmBtn").innerHTML=="출금"){
			type="withdraw"
			record(type)
		}else if(document.querySelector("#confirmBtn").innerHTML=="송금"){
			type="transfer"
			if(!transferNoBool){
				alert("계좌번호 확인")
			}else{
				console.log("계좌번호 ok")
				record(type)
			}
		}else if(document.querySelector("#confirmBtn").innerHTML=="적금"){
			if(document.querySelector("#period").value==""){
				alert("기간을 설정해주세요")
			}else{
				type="saving"
				record(type)
			}
		}else if(document.querySelector("#confirmBtn").innerHTML=="예금"){
			if(document.querySelector("#period").value==""){
				alert("기간을 설정해주세요")
			}else{
				type="deposit"
				record(type)
			}
		}
	}
})
function record(type){
    var balance = parseInt(document.querySelector("#balance").value)
    var data;
    if(type=='insert'){
    	balance+=parseInt(document.querySelector("#insertValue").innerHTML)
    }else{
    	balance-=parseInt(document.querySelector("#insertValue").innerHTML)
    }
    let insertValue = parseInt(document.querySelector("#insertValue").innerHTML)
    let chargeValueWith = isNaN(Math.round(insertValue / 100*5)) ? 0 : Math.round(insertValue / 100 * 5);
	let chargeValueTrans = isNaN(Math.round(insertValue / 100*3)) ? 0 : Math.round(insertValue / 100* 3);
    if(type=='transfer'){
        data = {
        	value:document.querySelector("#insertValue").innerHTML,
            accountNo: accountNo,
            type: type,
            balance : balance-chargeValueTrans,
            toName: name,
            transferNo: document.querySelector("#transferNo").value,
            charge : charge
        };
    }else if(type=='withdraw'){
        data = {
            	value:document.querySelector("#insertValue").innerHTML,
                accountNo: accountNo,
                type: type,
                balance : balance-chargeValueWith,
                charge : charge
        }
    }else if(type=="deposit"||type=="saving"){
        data = {
            	value:document.querySelector("#insertValue").innerHTML,
                accountNo: accountNo,
                type: type,
                balance : balance,
                period : document.querySelector("#period").value*60
            };
    }else{
        data = {
            	value:document.querySelector("#insertValue").innerHTML,
                accountNo: accountNo,
                type: type,
                balance : balance,
            };
    }
    fetch("/record", {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data) 
    })
    .then(response=>{
        if(response.ok){
            alert("성공")
            location.reload()
        }else{
            alert("실패")
        }
    })
    console.log(data)
}
//거래내역 -----------------------------------

document.querySelector(".recordBtn").addEventListener("click",()=>{
	document.querySelector(".depositTable").setAttribute("hidden","")
	document.querySelector(".savingTable").setAttribute("hidden","")
	document.querySelector(".recordTable").removeAttribute("hidden")
	document.querySelector("#exampleModalLabel").innerHTML="최근 거래내역"
    fetch("/recordPost?accountNo="+accountNo, {
        method: 'POST',
    })
    .then(response=>{
        if(response.ok){
            return response.json()
        }
    })
    .then(data=>{
        var str = ''
        var recordList = document.querySelector("#recordList")
        var dataType=''
        data.forEach(e=>{
            console.log(e.type)
            if(e.type=='withdraw'){
                dataType='출금'
            }else if(e.type=='saving'){
                dataType='적금'
            }else if(e.type=='deposit'){
                dataType='예금'
            }else if(e.type=='expireSaving'){
                dataType='적금만기'
            }else if(e.type=='expireDeposit'){
                dataType='예금만기'
            }else if(e.type=='deleteDeposit'){
                dataType='예금해지'
            }else if(e.type=='deleteSaving'){
                dataType='적금해지'
            }
            if(e.type=='receive'){
                dataType='입금'
                str+="<tr><td scope='row'>"+dataType+"("+e.fromName+")</td>"
                +"<td>"+e.doDate+"</td>"
                +"<td class='text-primary'>+"+e.value+"</td>"
                +"<td>"+e.charge+"</td>"
                +"<td>"+e.balance+"</td></tr>"
            }else if(e.type=='insert'){
                str+="<tr><td scope='row'>입금</td>"
                +"<td>"+e.doDate+"</td>"
                +"<td class='text-primary'>+"+e.value+"</td>"
                +"<td>"+e.charge+"</td>"
                +"<td>"+e.balance+"</td></tr>"
            }else if(e.type=='transfer'){
                str+="<tr><td scope='row'>송금("+e.toName+")</td>"
                    +"<td>"+e.doDate+"</td>"
                    +"<td class='text-danger'>-"+e.value+"</td>"
                    +"<td>"+e.charge+"</td>"
                    +"<td>"+e.balance+"</td></tr>"
            }else if(e.type=='expireSaving'||e.type=='expireDeposit'){
                str+="<tr><td scope='row'>"+dataType+"</td>"
                +"<td>"+e.doDate+"</td>"
                +"<td class='text-primary'>+"+e.value+"(원금:"+e.principal+")</td>"
                +"<td>"+e.charge+"</td>"
                +"<td>"+e.balance+"</td></tr>"
            }else if(e.type=='deleteSaving'||e.type=='deleteDeposit'){
                str+="<tr><td scope='row'>"+dataType+"</td>"
                +"<td>"+e.doDate+"</td>"
                +"<td class='text-primary'>+"+e.value+"</td>"
                +"<td>"+e.charge+"</td>"
                +"<td>"+e.balance+"</td></tr>"
            }else{
                str+="<tr ><td scope='row'>"+dataType+"</td>"
                +"<td>"+e.doDate+"</td>"
                +"<td class='text-danger'>-"+e.value+"</td>"
                +"<td>"+e.charge+"</td>"
                +"<td>"+e.balance+"</td></tr>"
            }
         })
         recordList.innerHTML=str
      })
})
//예적금 보기 ======================================
document.querySelector(".showDeposit").addEventListener("click",()=>{
	savingList("deposit")
	document.querySelector(".depositTable").removeAttribute("hidden")
	document.querySelector(".savingTable").setAttribute("hidden","")
	document.querySelector("#exampleModalLabel").innerHTML="예금목록"
	
})
document.querySelector(".showSaving").addEventListener("click", () => {
    savingList("saving");
    document.querySelector(".savingTable").removeAttribute("hidden");
    document.querySelector(".depositTable").setAttribute("hidden", "");
    document.querySelector("#exampleModalLabel").innerHTML = "적금목록";
});

function savingList(type){
	document.querySelector(".recordTable").setAttribute("hidden","")
    fetch("/savingList?accountNo="+accountNo, {
        method: 'POST',
    })
    .then(response=>{
        if(response.ok){
            return response.json()
        }
    })
    .then(data=>{
        console.log(data)
        var str = ''
        var savingList = document.querySelector("#"+type+"List")
        data.forEach(e=>{
        	
        	const timestamp = e.expireDate;
        	const expireDate = new Date(timestamp);
        	const formattedDate = formatDate(expireDate);
        	console.log(formattedDate)
        	
        	
            if(type=='deposit'&&e.type=='deposit'){
                str+="<tr ><td>"+e.savingDate+"</td>"
                +"<td>"+e.principal+"</td>"
                +"<td class='text-primary'>"+e.interest+"</td>"
                +"<td>"+formattedDate+"</td>"
                +"<td><button type='button' data-savingNo='"+e.savingNo+"' onclick='deleteSaving(this)'>중도해지하기</button></td></tr>"
            }else if(type=='saving'&&e.type=='saving'){
                str+="<tr ><td>"+e.savingDate+"</td>"
                +"<td>"+e.principal+"</td>"
                +"<td class='text-primary'>"+e.balance+"</td>"
                +"<td>"+formattedDate+"</td>"
                +"<td><button type='button' data-savingNo='"+e.savingNo+"' onclick='deleteSaving(this)'>중도해지하기</button></td></tr>"
            }
        })
        savingList.innerHTML=str
    })
}
function formatDate(date) {
    const year = date.getFullYear().toString().slice(2);
    let month = (date.getMonth() + 1).toString().padStart(2, '0'); 
    let day = date.getDate().toString().padStart(2, '0'); 
    let hours = date.getHours().toString().padStart(2, '0'); 
    let minutes = date.getMinutes().toString().padStart(2, '0');
    let seconds = date.getSeconds().toString().padStart(2, '0'); 

    return year+"-"+month+"-"+day+" "+hours+":"+minutes+":"+seconds;
}

function deleteSaving(btn) {
    const savingNo = btn.getAttribute("data-savingNo");
    console.log(savingNo);
    fetch("/deleteSaving?savingNo="+savingNo, {
        method: 'POST',
    })
    .then(response=>{
        if(response.ok){
            alert("해지성공")
            location.reload()
        }
    })
}
</script>
</html>