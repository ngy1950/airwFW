package project.common.util;

public class DasStringFormat {


	public int getFormByte(String str) {
		char c;
		String s;
		int type;
		int bt = 0;
		for (int i = 0; i < str.length(); i++) {
			c = str.charAt(i);
			type = Character.getType(c);

			s = c + "";
			// bt += s.getBytes().length;

			/*
			 * Type List 1 : 영어 5 : 한글 9 : 숫자 21 : 특수기호( 22 : 특수기호) 24 : 특수기호 26 :
			 * 특수기호
			 */
			if (type == 5)
				bt += 2;
			else
				bt += 1;
		}

		return bt;
	}

	public String getFormByteMaxLength(String str, int maxByte) {
		char c;
		String s;
		int type;
		int bt = 0;
		String returnStr = "";
		for (int i = 0; i < str.length(); i++) {
			c = str.charAt(i);
			type = Character.getType(c);

			s = c + "";
			/*
			 * Type List 1 : 영어 5 : 한글 9 : 숫자 21 : 특수기호( 22 : 특수기호) 24 : 특수기호 26 :
			 * 특수기호
			 */

			// String Control
			if (bt >= maxByte) {
				return returnStr;
			} else if ((maxByte - 1) == bt && type == 5) {
				returnStr = returnStr + " ";
				return returnStr;
			} else {
				returnStr = returnStr + c;
			}

			// byte Control
			if (type == 5) {
				bt += 2;
			} else {
				bt += 1;
			}
		}

		return returnStr;
	}

	public String byteSpacePaddingAlignString(String str, int size, int align) {
		String resultStr = "";

		int byteLength = getFormByte(str);

		if (byteLength > size) {
			resultStr = getFormByteMaxLength(str, size);
		} else {
			String space = "";
			for (int i = 0; i < size - byteLength; i++) {
				space = space + " ";
			}

			if (align == 1) { // 오른쪽정렬
				resultStr = space + str;
			} else { // 왼쪽정렬
				resultStr = str + space;
			}
		}
		return resultStr;
	}
}
