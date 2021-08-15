// 김호철 : 공통에 한영변환이 없어서 추가함. 2020.01.23
// 사용법 : 
// 1. <script type="text/javascript" src="/common/js/kor-En-Conversion.js"></script> 추가
// 2. 한글->영문 변환 korToEng("변환할 한글")
// 3. 영문->할글 변환 engToKor("Change English")



// Case 정리
// --------- 1 글자 ----------
// 1. ㄱ : 자음 
// 2. ㅏ : 모음
// --------- 2 글자 ----------
// 3. 자음 + 자음 : ㄺ
// 4. 자음 + 모음 : 가
// x. 모음 + 자음 : ㅗㄱ 
// 5. 모음 + 모음 : ㅚ 
// --------- 3 글자 ----------
// x. 자음 + 자음 + 자음 : ㄱㄱㄱ/ㄺㄱ/ㄱㄺ
// x. 자음 + 자음 + 모음 : ㄹ가
// 6. 자음 + 모음 + 자음 : 간
// 7. 자음 + 모음 + 모음 : 과/가ㅏ
// x. 모음 + 자음 + 자음 : ㅗㄱㄹ/ㅇㄺ
// x. 모음 + 자음 + 모음 : ㅗ고
// x. 모음 + 모음 + 자음 : ㅚㄱ/ㅏㅏㄱ
// x. 모음 + 모음 + 모음 : ㅏㅏㅏ/ㅚㅏ/ㅏㅚ
// --------- 4 글자 ----------
// 8. 자음 + 모음 + 자음 + 자음 : 닭
// 9. 자음 + 모음 + 모음 + 자음 : 관
// --------- 5 글자 ----------
// 10. 자음 + 모음 + 모음 + 자음 + 자음 : 괅 

var 영어타이핑 = "rRseEfaqQtTdwWczxvgkoiOjpuPhynbml";
var 한글타이핑 = "ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎㅏㅐㅑㅒㅓㅔㅕㅖㅗㅛㅜㅠㅡㅣ";
var 초성모음 = "ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ";
var 중성모음 = "ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ";
var 종성모음 = "ㄱㄲㄳㄴㄵㄶㄷㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅄㅅㅆㅇㅈㅊㅋㅌㅍㅎ";

function 한글조합하기(src) {
  if (src == null) {
    return '';
  }
  var result = {
    사용한글자수 : src.length
  }
  switch (src.length) {
  case 0:
    result.조합된한글 = src;
    break;
  case 1: // case 1,2
    result.조합된한글 = convert영한(src);
    break;
  case 2: // case 3,4,5
    var ch1 = src.charAt(0), ch2 = src.charAt(1);
    // 3. 자음 + 자음 : ㄺ
    if (is자음(ch1) && is자음(ch2)) {
      var 결합자음 = 자음결합하기(convert영한(ch1), convert영한(ch2));
      if (결합자음) {
        result.조합된한글 = 결합자음;
      } else {
        result = 한글조합하기(src.substring(1, 2));
      }
    }
    // 4. 자음 + 모음 : 가
    else if (is자음(ch1) && is모음(ch2)) {
      result.조합된한글 = combine한글(convert영한(ch1), convert영한(ch2));
    }
    // 5. 모음 + 모음 : ㅚ
    else if (is모음(ch1) && is모음(ch2)) {
      var 결합모음 = 모음결합하기(convert영한(ch1), convert영한(ch2));
      if (결합모음) {
        result.조합된한글 = 결합모음;
      } else {
        result = 한글조합하기(src.substring(1, 2));
      }
    } else {
      result = 한글조합하기(src.substring(1, 2));
    }
    break;
  case 3:// case 6, 7
    var ch1 = src.charAt(0), ch2 = src.charAt(1), ch3 = src.charAt(2);
    // 6. 자음 + 모음 + 자음 : 간
    if (is자음(ch1) && is모음(ch2) && is자음(ch3)) {
      result.조합된한글 = combine한글(convert영한(ch1), convert영한(ch2), convert영한(ch3));
    }
    // 7. 자음 + 모음 + 모음 : 과
    else if (is자음(ch1) && is모음(ch2) && is모음(ch3)) {
      var 결합모음 = 모음결합하기(convert영한(ch2), convert영한(ch3));
      if (결합모음) {
        result.조합된한글 = combine한글(convert영한(ch1), 결합모음);
      } else {
        result = 한글조합하기(src.substring(1, 3));
      }
    } else {
      result = 한글조합하기(src.substring(1, 3));
    }
    break;
  case 4:// 
    var ch1 = src.charAt(0), ch2 = src.charAt(1), ch3 = src.charAt(2), ch4 = src.charAt(3);
    // 8. 자음 + 모음 + 자음 + 자음 : 닭
    if (is자음(ch1) && is모음(ch2) && is자음(ch3) && is자음(ch4)) {
      var 결합자음 = 자음결합하기(convert영한(ch3), convert영한(ch4));
      if (결합자음) {
        result.조합된한글 = combine한글(convert영한(ch1), convert영한(ch2), 결합자음);
      } else {
        result = 한글조합하기(src.substring(1, 4));
      }
    }
    // 9. 자음 + 모음 + 모음 + 자음 : 관
    else if (is자음(ch1) && is모음(ch2) && is모음(ch3) && is자음(ch4)) {
      var 결합모음 = 모음결합하기(convert영한(ch2), convert영한(ch3));
      if (결합모음) {
        result.조합된한글 = combine한글(convert영한(ch1), 결합모음, convert영한(ch4));
      } else {
        result = 한글조합하기(src.substring(1, 4));
      }
    } else {
      result = 한글조합하기(src.substring(1, 4));
    }
    break;
  case 5:// 
    var ch1 = src.charAt(0), ch2 = src.charAt(1), ch3 = src.charAt(2), ch4 = src.charAt(3), ch5 = src.charAt(4);
    // 자음 + 모음 + 모음 + 자음 + 자음 : 괅
    if (is자음(ch1) && is모음(ch2) && is모음(ch3) && is자음(ch4) && is자음(ch5)) {
      var 결합모음 = 모음결합하기(convert영한(ch2), convert영한(ch3));
      var 결합자음 = 자음결합하기(convert영한(ch4), convert영한(ch5));
      if (결합모음 && 결합자음) {
        result.조합된한글 = combine한글(convert영한(ch1), 결합모음, 결합자음);
      } else {
        result = 한글조합하기(src.substring(1, 5));
      }
    } else {
      result = 한글조합하기(src.substring(1, 5));
    }
    break;
  }
  return result;
}
function korToEng(src) {
  var res = "";
  if (src.length == 0) {
    return res;
  }

  for (var i = 0; i < src.length; i++) {
    var ch = src.charAt(i);
    var nCode = ch.charCodeAt(0);
    var result = '';
    var 초성, 중성, 종성;
    if (44032 <= nCode && nCode <= 55203) {
      nCode -= 44032;
      초성 = 초성모음.charAt(Math.floor(nCode / (21 * 28)));
      중성 = 중성모음.charAt(Math.floor(nCode / 28) % 21);
      종성 = 종성모음.charAt(nCode % 28 - 1);
      res += convert한영(초성);
      var 모음분해 = 모음분해하기(중성);
      if (모음분해) {
        res += convert한영(모음분해);
      } else {
        res += convert한영(중성);
      }
      var 자음분해 = 자음분해하기(종성);
      if (자음분해) {
        res += convert한영(자음분해);
      } else {
        res += convert한영(종성);
      }
    } else if (초성모음.indexOf(ch) > -1) {
      res += convert한영(ch);
    } else if (중성모음.indexOf(ch) > -1) {
      var 모음분해 = 모음분해하기(ch);
      if (모음분해) {
        res += convert한영(모음분해);
      } else {
        res += convert한영(ch);
      }
    } else if (종성모음.indexOf(ch) > -1) {
      var 자음분해 = 자음분해하기(ch);
      if (자음분해) {
        res += convert한영(자음분해);
      } else {
        res += convert한영(ch);
      }
    } else {
      res += ch;
    }
  }

  return res;
}

function convert영한(src) {
  var result = '';
  for (var i = 0; i < src.length; i++) {
    var ch = src.charAt(i);
    var index = 영어타이핑.indexOf(ch);
    if (index >= 0) {
      result += 한글타이핑.charAt(index);
    } else {
      result += ch;
    }
  }
  return result;
}
function convert한영(src) {
  var result = '';
  for (var i = 0; i < src.length; i++) {
    var ch = src.charAt(i);
    var index = 한글타이핑.indexOf(ch);
    if (index >= 0) {
      result += 영어타이핑.charAt(index);
    } else {
      result += ch;
    }
  }
  return result;
}
function is영어타이핑(ch) {
  return 영어타이핑.indexOf(ch) >= 0;
}
function is모음(ch) {
  return 영어타이핑.indexOf(ch) >= 19;
}
function is자음(ch) {
  return 영어타이핑.indexOf(ch) < 19 && 영어타이핑.indexOf(ch) >= 0;
}
function engToKor(src) {
  var res = "";
  if (src.length == 0)
    return res;
  var 초성위치 = -1, 중성위치 = -1, 종성위치 = -1; // 초성, 중성, 종성
  for (var i = 0; i < src.length; i++) {
    var result = 한글조합하기(src.slice(Math.max(src.length - 5 - i, 0), src.length - i));
    // console.log(result);
    i += result.사용한글자수 - 1;
    res = result.조합된한글 + res;
  }
  return res;
}

function combine한글(초성, 중성, 종성) {
  return String.fromCharCode(44032 + 초성모음.indexOf(초성) * 21 * 28 + 중성모음.indexOf(중성) * 28 + 종성모음.indexOf(종성) + 1);
}
function 모음결합하기(ch1, ch2) {
  var result = null;
  if (ch1 == 'ㅗ' && ch2 == 'ㅏ') { // ㅘ
    result = 'ㅘ';
  } else if (ch1 == 'ㅗ' && ch2 == 'ㅐ') { // ㅙ
    result = 'ㅙ';
  } else if (ch1 == 'ㅗ' && ch2 == 'ㅣ') { // ㅚ
    result = 'ㅚ';
  } else if (ch1 == 'ㅜ' && ch2 == 'ㅓ') { // ㅝ
    result = 'ㅝ';
  } else if (ch1 == 'ㅜ' && ch2 == 'ㅔ') { // ㅞ
    result = 'ㅞ';
  } else if (ch1 == 'ㅜ' && ch2 == 'ㅣ') { // ㅟ
    result = 'ㅟ';
  } else if (ch1 == 'ㅡ' && ch2 == 'ㅣ') { // ㅢ
    result = 'ㅢ';
  }
  return result;
}
function 모음분해하기(ch) {
  switch (ch) {
  case 'ㅘ':
    return 'ㅗㅏ';
  case 'ㅙ':
    return 'ㅗㅐ';
  case 'ㅚ':
    return 'ㅗㅣ';
  case 'ㅝ':
    return 'ㅜㅓ';
  case 'ㅞ':
    return 'ㅜㅔ';
  case 'ㅟ':
    return 'ㅜㅣ';
  case 'ㅢ':
    return 'ㅡㅣ';
  }
  return null;
}
function 자음결합하기(ch1, ch2) {
  var result = null;
  if (ch1 == 'ㄱ' && ch2 == 'ㅅ') { // ㄳ
    result = 'ㄳ';
  } else if (ch1 == 'ㄴ' && ch2 == 'ㅈ') { // ㄵ
    result = 'ㄵ';
  } else if (ch1 == 'ㄴ' && ch2 == 'ㅎ') { // ㄶ
    result = 'ㄶ';
  } else if (ch1 == 'ㄹ' && ch2 == 'ㄱ') { // ㄺ
    result = 'ㄺ';
  } else if (ch1 == 'ㄹ' && ch2 == 'ㅁ') { // ㄻ
    result = 'ㄻ';
  } else if (ch1 == 'ㄹ' && ch2 == 'ㅂ') { // ㄼ
    result = 'ㄼ';
  } else if (ch1 == 'ㄹ' && ch2 == 'ㅅ') { // ㄽ
    result = 'ㄽ';
  } else if (ch1 == 'ㄹ' && ch2 == 'ㅌ') { // ㄾ
    result = 'ㄾ';
  } else if (ch1 == 'ㄹ' && ch2 == 'ㅍ') { // ㄿ
    result = 'ㄿ';
  } else if (ch1 == 'ㄹ' && ch2 == 'ㅎ') { // ㅀ
    result = 'ㅀ';
  } else if (ch1 == 'ㅂ' && ch2 == 'ㅅ') { // ㅄ
    result = 'ㅄ';
  }
  return result;
}
function 자음분해하기(ch) {
  switch (ch) {
  case 'ㄳ':
    return 'ㄱㅅ';
  case 'ㄵ':
    return 'ㄴㅈ';
  case 'ㄶ':
    return 'ㄴㅎ';
  case 'ㄺ':
    return 'ㄹㄱ';
  case 'ㄻ':
    return 'ㄹㅁ';
  case 'ㄼ':
    return 'ㄹㅂ';
  case 'ㄽ':
    return 'ㄹㅅ';
  case 'ㄾ':
    return 'ㄹㅌ';
  case 'ㄿ':
    return 'ㄹㅍ';
  case 'ㅀ':
    return 'ㄹㅎ';
  case 'ㅄ':
    return 'ㅂㅅ';
  }
  return null;
}