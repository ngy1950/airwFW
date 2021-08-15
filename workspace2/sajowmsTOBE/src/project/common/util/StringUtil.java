package project.common.util;

import java.math.BigDecimal;
import java.text.CharacterIterator;
import java.text.StringCharacterIterator;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import project.common.service.SystemMagService;

public class StringUtil {

	static final Logger log = LogManager.getLogger(StringUtil.class.getName());
	/**
	 * 
	 * @param value
	 * @param defalutValue
	 * @return
	 */
	public static String isNull(String value, String defalutValue) {
		return isNull(value) ? defalutValue : value;
	}

	/**
	 * 
	 * @param value
	 * @param defalutValue
	 * @return
	 */
	public static String isEmpty(String value, String defalutValue) {
		return isEmpty(value) ? defalutValue : value;
	}
	
	/**
	 * 
	 * @param value
	 * @return
	 */
	public static boolean isNull(String value) {
		return (value == null);
	}
	
	/**
	 * 
	 * @param value
	 * @return
	 */
	public static boolean isZero(BigDecimal value) {
		return value.toString().equals("0");
	}

	/**
	 * 
	 * @param value
	 * @return
	 */
	public static boolean isEmpty(String value) {
		return (isNull(value) || value.trim().length() == 0);
	}
	
	public static boolean isNotEmpty(String value) {
		return isEmpty(value) ? false : true;
	}

	public static boolean isNumeric(String str) {
        if (str == null)
            return false;

        int sz = str.length();
        for (int i = 0; i < sz; i++)
            if (Character.isDigit(str.charAt(i)) == false)
                return false;

        return true;
    }
	
	/**
	 * 
	 * @param src
	 * @param oldstr
	 * @param newstr
	 * @return
	 */
	public synchronized static String replaceByStringBuffer(String src, String oldstr, String newstr) {
		if (src == null)
			return null;

		StringBuffer dest = new StringBuffer("");
		int len = oldstr.length();
		int srclen = src.length();
		int pos = 0;
		int oldpos = 0;

		while ((pos = src.indexOf(oldstr, oldpos)) >= 0) {
			dest.append(src.substring(oldpos, pos));
			dest.append(newstr);
			oldpos = pos + len;
		}
		dest.append(src.substring(oldpos, srclen));

		return dest.toString();
	}

	/**
	 * 
	 * @param src
	 * @param oldstr
	 * @param newstr
	 * @return
	 */
	public synchronized static String replaceByAutomata(String src, String oldstr, String newstr) {
		if (src == null)
			return null;

		final int ORDINARY_STATE = 0;
		final int MATCH_STATE = 1;

		StringBuffer dest = new StringBuffer("");
		char[] data = src.toCharArray();
		char[] olddata = oldstr.toCharArray();

		int pos = 0;
		int mcount = 0;

		int len = oldstr.length();
		int state = ORDINARY_STATE;
		char first = olddata[0];
		int srcLen = data.length;

		for (int i = 0; i < srcLen; i++) {
			switch (state) {
			case ORDINARY_STATE:
				if (data[i] == first) {
					if (i > pos) {
						dest.append(data, pos, i - pos);
						pos = i;
					}
					mcount = 1;
					state = MATCH_STATE;
				} else {
					while (i < srcLen && data[i] != first) {
						i++;
					}
					if (i > pos) {
						dest.append(data, pos, i - pos);
						pos = i;
					}
					mcount = 1;
					state = MATCH_STATE;
				}
				break;
			case MATCH_STATE:
				while (i < srcLen && mcount < len && olddata[mcount] == data[i]) {
					i++;
					mcount++;
				}

				if (mcount == len)
					dest.append(newstr);
				else
					dest.append(data, pos, mcount);
				
				pos = i;
				mcount = 0;
				state = ORDINARY_STATE;
				break;
			}
		}

		if (pos < srcLen) {
			dest.append(data, pos, srcLen - pos);
		}

		return dest.toString();
	}

	/**
	 * <p>
	 * Joins the elements of the provided array into a single String containing
	 * the provided list of elements.
	 * </p>
	 * 
	 * <p>
	 * No delimiter is added before or after the list. A <code>null</code>
	 * separator is the same as an empty String (""). Null objects or empty
	 * strings within the array are represented by empty strings.
	 * </p>
	 * 
	 * <pre>
	 *      StringUtils.join(null, *)                = null
	 *      StringUtils.join([], *)                  = &quot;&quot;
	 *      StringUtils.join([null], *)              = &quot;&quot;
	 *      StringUtils.join([&quot;a&quot;, &quot;b&quot;, &quot;c&quot;], &quot;--&quot;)  = &quot;a--b--c&quot;
	 *      StringUtils.join([&quot;a&quot;, &quot;b&quot;, &quot;c&quot;], null)  = &quot;abc&quot;
	 *      StringUtils.join([&quot;a&quot;, &quot;b&quot;, &quot;c&quot;], &quot;&quot;)    = &quot;abc&quot;
	 *      StringUtils.join([null, &quot;&quot;, &quot;a&quot;], ',')   = &quot;,,a&quot;
	 * </pre>
	 * 
	 * @param array
	 *            the array of values to join together, may be null
	 * @param separator
	 *            the separator character to use, null treated as ""
	 * @return the joined String, <code>null</code> if null array input
	 */
	public static String join(Object[] array, String separator) {
		if (array == null)
			return null;
		
		if (separator == null)
			separator = "";

		int arraySize = array.length;
		int bufSize = ((arraySize == 0) ? 0 : arraySize * ((array[0] == null ? 16 : array[0].toString().length()) + separator.length()));

		StringBuffer buf = new StringBuffer(bufSize);

		for (int i = 0; i < arraySize; i++) {
			if (i > 0)
				buf.append(separator);
			if (array[i] != null)
				buf.append(array[i]);
		}
		
		return buf.toString();
	}

	/**
	 * 
	 * @param stringToPad
	 * @param padder
	 * @param size
	 * @return
	 */
	public static String leftPad(String stringToPad, String padder, int size) {
		StringBuffer strb;
		StringCharacterIterator sci;

		if (padder.length() == 0)
			return stringToPad;

		if (isNull(stringToPad)) {
			char[] t = new char[size];
			for (int i = 0; i < t.length; i++)
				t[i] = padder.charAt(0);

			stringToPad = String.valueOf(t);
		}

		strb = new StringBuffer(size);
		sci = new StringCharacterIterator(padder);

		while (strb.length() < (size - stringToPad.length()))
			for (char ch = sci.first(); ch != CharacterIterator.DONE; ch = sci.next())
				if (strb.length() < size - stringToPad.length())
					strb.insert(strb.length(), String.valueOf(ch));
		return strb.append(stringToPad).toString();
	}

	/**
	 * 
	 * @param stringToPad
	 * @param padder
	 * @param size
	 * @return
	 */
	public static String rightPad(String stringToPad, String padder, int size) {
		StringBuffer strb;
		StringCharacterIterator sci;

		if (padder.length() == 0)
			return stringToPad;

		if (isNull(stringToPad)) {
			char[] t = new char[size];
			for (int i = 0; i < t.length; i++)
				t[i] = padder.charAt(0);
			stringToPad = String.valueOf(t);
		}

		strb = new StringBuffer(stringToPad);
		sci = new StringCharacterIterator(padder);

		while (strb.length() < size) {
			for (char ch = sci.first(); ch != CharacterIterator.DONE; ch = sci.next())
				if (strb.length() < size)
					strb.append(String.valueOf(ch));
		}
		return strb.toString();
	}
}
