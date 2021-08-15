/*
 * Ezgen View
 */

function ezgenPrint( openFile, openID, wherestr, orderbystr, language ){
	document.report1.action = "../ezgen/ezprint.jsp";
	document.report1.i_filenm.value = openFile;
	document.report1.i_where.value =  wherestr;
	document.report1.i_orderby.value =  orderbystr;
	document.report1.i_language.value =  language;

	window.open("", openID, "menubar=no,resizable=yes,scrollbars=yes,status=no,titlebar=no,toolbar=no,location=no");
	document.report1.target = openID;  // taget 을 새창의 이름을 부여한다.
	document.report1.submit();
}
