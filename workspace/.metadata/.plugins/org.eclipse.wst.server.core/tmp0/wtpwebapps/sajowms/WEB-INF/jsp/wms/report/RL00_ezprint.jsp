<%@ page language="java" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<script language="JavaScript" src="/common/js/jquery.js"> </script>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<title>EZgen</title>
</head>
<body topmargin="0" leftmargin="0" bgcolor="FFFFFF" onload="">
<script>
		/* WriteEZgenElement("/ezgen/moving_list.ezg", */
		WriteEZgenElement("/ezgen/distribution_list.ezg",
				[
				 	/* {"name":"i_where","value":"AND LOCAKY LIKE '1C1%'","varType":"global"} */
				 	{"name":"i_where","value":"AND STKNUM IN ('7000000286')","varType":"global"}
				 	,{"name":"i_language","value":"KO","varType":"global"}
				 	,{"name":"KEY","value":"7000001428","varType":"local"}
				 	,{"name":"KEY1","value":"2000421078","varType":"local"}
				 /* 	,{"name":"KEY","value":"7000001428"}
				 	,{"name":"KEY1","value":"2000421078"} */
				 	/* ,{"name":"i_orderby","value":"order by taskit"} */
				]
		);
		</script>
</body>	   
</html>