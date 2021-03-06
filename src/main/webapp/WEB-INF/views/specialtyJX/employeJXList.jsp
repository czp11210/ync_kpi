<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="staticCtx" value="${pageContext.request.contextPath}/static" />
<html>
<head>
<title>专业绩效页面</title>
<style type="text/css">
	.comment {
	width:95%;/*自动适应父布局宽度*/
	overflow:auto;
	word-break:break-all;
	resize : none;
	} 
</style> 
<!-- artDialog -->
<script type="text/javascript"
	src="${staticCtx}/artdialog/artDialog.js?skin=brief"></script>
<script type="text/javascript"
	src="${staticCtx}/artdialog/plugins/iframeTools.js"></script>

<script type="text/javascript">
$(function(){
	var listSize = '${employeJXList.size() }';		
	for(var i=0;i<listSize;i++){
		var evaluateTime = $("#evaluateTime"+i).val();		
		if(evaluateTime!=null&&evaluateTime!=""){
			$("#evaluateLink"+i).html('修改');			
		}else{
			$("#evaluateLink"+i).html('评价');
		}
	}
});
	//去评分页面
	function toEvaluate(beEvaluatedId,createTime){
		var time = createTime.substring(0,10);	
		//先判断当前时间是否允许评分
		$.ajax({
			type : "post",
			url : "${ctx}/specialtyJX/isAllowedEvaluate",		
			success : function(data) {
				if (data == "NO") {
					alert("对不起，现在不允许评分！");
					window.location.href="${ctx}/specialtyJX/employeJXList";
				}else if(data == "OK"){
					window.location.href="${ctx}/specialtyJX/evaluatePage?beEvaluatedId="+beEvaluatedId+"&createTime="+time;
				}				
			}
		});		
	}	
	function formatDate(times) {
		var date = new Date(times);
		var fm = date.format('yyyy-MM');
		return fm;
	}
</script>
</head>
<body>
	<div class="container-fluid">
		<div class="row-fluid">
			<div class="span2">
				<ul class="nav nav-tabs nav-stacked">
					<li class="nav-header"><h4>${em.departmentName }专业评价</h4></li>
					<c:forEach items="${pe.getContent()}" var="pc">
						<li><a
							href="${ctx }/specialtyJX/employeJXList?date=<fmt:formatDate value="${pc.createTime}" pattern="yyyy-MM"/>">${pc.peDateDepartment.replace('_','') }</a></li>
					</c:forEach>
				</ul>
			</div>
			<div class="span10">
				<h3>
					<fmt:formatDate value="${date}" pattern="yyyy-MM" />${em.departmentName}专业性评价</h3>
				<table class="table  table-striped table-bordered table-condensed">
					<thead>
						<tr align="center">
							<th>序号</th>
							<th>人员</th>
							<c:forEach var="specialty" items="${speList}">
								<th>${specialty.name }</th>
							</c:forEach>
							<th>总分</th>
							<th>评语</th>
							<th>评价人</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="employeJX" items="${employeJXList }" varStatus="status">
							<tr align="center">
								<td>${status.index+1 }</td>
								<td>${employeJX.beEvaluatedName }</td>
								<c:forEach var="specialty" items="${speList}">
									<c:forEach var="specialtyJX" items="${employeJX.specialtyJXList }">
										<c:if test="${specialty.specId == specialtyJX.specialtyId }">
											<td>${specialtyJX.score }</td>
										</c:if>
									</c:forEach>
								</c:forEach>
								<td>${employeJX.totalScore }</td>								
								<td>
									<textarea rows="1" cols="3" class="comment" disabled="disabled">${employeJX.comment }</textarea>
								</td>
								<td>${employeJX.evaluateName}</td>
								<td>
									<a id="evaluateLink${status.index }" href="javascript:void(0)" onclick="toEvaluate(${employeJX.beEvaluatedId},'${employeJX.createTime}');"></a>	
									<!-- 放一个评价时间的隐藏域 -->	
									<input type="hidden" id="evaluateTime${status.index }" value="${employeJX.evaluateTime}"/>						
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>		
	</div>
</body>
</html>
