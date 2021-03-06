<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="staticCtx" value="${pageContext.request.contextPath}/static"/>
<html>
<head>
	<title></title>	
	
<style type="text/css">
	.comment {
	width:30%;/*自动适应父布局宽度*/
	overflow:auto;
	word-break:break-all;
	resize : none;
	} 
</style> 
<script type="text/javascript" src="${staticCtx}/jquery/jqueryForm.js"></script>
<script type="text/javascript">
	//评价或修改的标志
	var operation = '${operation}';
	var totalScore = 0;
	var listSize = '${employeJX.specialtyJXList.size() }';
	$(function(){	
		
		$("#score0,#score1").bind('input propertychange', function() {			
			var score0 = $("#score0").val();
			var score1 = $("#score1").val();			
			totalScore = parseInt(parseInt(score0)+parseInt(score1));			
			$("#totalScore").html(totalScore);			
		});
	});
	
	function btnCommit(){			
		var createTime = $("#createTime").val();						
		for(var i=0;i<listSize;i++){
			var score = $("#score"+i).val();
			//totalScore += parseFloat(score);
			if(score==0||score==null||score==undefined){
				alert("请您输入评分！");
				return;
			}
			if(parseFloat(score)<0){
				alert("单项评分不能低于0分");
				return;
			}else if(parseFloat(score)>30){
				alert("单项评分不能大于30分");
				return;
			}			
		}			
		
		if(parseFloat(totalScore)>30){
			var total = parseFloat(totalScore);
			/* alert("总分："+total); */
			alert("总分不能大于30分");
			return;
		}
		var commentLength = $("#comment").val().length; 
		if(commentLength==0||commentLength==null||commentLength==undefined||commentLength=="") {			
			alert("请您输入50字以内评语！" ); 
			return;
		}else if(commentLength>50) {			
			alert("评语不能超过50字！" ); 
			return;
		}		
		$('#evaluateForm').ajaxSubmit({
			type : "post",
			url : "${ctx}/specialtyJX/evaluateSpec",
			data : {operation : operation},
			success:function(data){
				if(data=="OK"){
					alert("评价成功！");
	    			window.location.href="${ctx}/specialtyJX/employeJXList?createTime="+createTime;			
	    		}else if(data=="isNotMt"){
	    			alert("对不起！您没有评分权限");
	    			window.location.href="${ctx}/specialtyJX/employeJXList?createTime="+createTime;
	    		}else{
	    			alert("评价失败！");
	    			window.location.href="${ctx}/specialtyJX/employeJXList?createTime="+createTime;	
	    		}
			}
		});		
	}	
	
</script>
</head>
<body>
<div style="margin-left: 200px">
	<form id="evaluateForm" action="" >
		 <table  border="1px;" style="border-collapse: collapse;width: 600px;" bordercolor="#000000">
			<tr align="center">
				<td>序号</td>
				<td>专业性</td>
				<td>评分</td>				
			</tr>			
			<input type="hidden" id="createTime" name="createTime" value="${employeJX.createTime }"/>
			<c:forEach var="specialtyJX" items="${employeJX.specialtyJXList }" varStatus="status">
				<tr align="center">
					<td>${status.index+1 }</td>				
					<td>
						${specialtyJX.specialtyName }						
						<input type="hidden"  name="specialtyJXList[${status.index }].id" value="${specialtyJX.id }"/>
					</td>							
					<td><input type="text" id="score${status.index }" style="text-align:center;"  name="specialtyJXList[${status.index }].score" value="${specialtyJX.score }"/></td>	
				</tr>
			</c:forEach>
		</table>
		<span id="" style="margin-left: 300px">总分30分，各专业性满分为总分除以专业性数量</span><br/>
		评语：<textarea id="comment"  rows="3" name="comment" class="comment">${employeJX.comment}</textarea><br/>
		<span id="" style="color:red;margin-left: 200px">请输入评语</span><br/>
		总分 <span id="totalScore" style="margin-left: 200px">${employeJX.totalScore }</span>分<br/> 
		<input type="button" style="margin-left: 200px" value="提交" onclick="btnCommit()"/>		
	</form>
</div>	
</body>
</html>
