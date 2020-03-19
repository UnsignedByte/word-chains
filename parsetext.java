/*
* @Author: UnsignedByte
* @Date:   10:55:29, 19-Mar-2020
* @Last Modified by:   UnsignedByte
* @Last Modified time: 12:46:26, 19-Mar-2020
*/

import java.io.*;
import java.util.*;

public class parsetext {
	public static final Character[] separators = {'!','.','?'}; //Characters denoting the end of a line
	public static final String[] specialWords = {"Mr.","Ms.","Mrs."}; //Words breaking this rule
	public static final Character[] keptChars = {'\''}; //Characters to keep in words that aren't letters
	public static final Character[] inlinepunc = {';',':','–','—',','}; //Punctuation that doesnt separate lines

	public static boolean contains(Object[] a, Object b){
		for(Object c : a){
			if (b.equals(c)) return true;
		}
		return false;
	}

    public static void main(String[] args) throws FileNotFoundException, IOException{
        InputManager input;
        PrintWriter output;
    	File source = new File("Plaintext-Data/Sources");
        String fileOut = "Plaintext-Data/compiledraw.txt";
        output = new PrintWriter(new BufferedWriter(new FileWriter(fileOut)));

    	for (File fileEntry : source.listFiles()) {
        	input = new InputManager(new BufferedReader(new FileReader("Plaintext-Data/Sources/"+fileEntry.getName())));


        	StringBuilder lines = new StringBuilder();
        	while(input.hasNext()){
        		String s = input.next();
        		if (contains(specialWords, s)){
        			lines.append(s.toLowerCase());
        			lines.append(' ');
        		}else{
        			boolean EOL = false;
	        		for(int i = 0; i < s.length(); i++){
	        			char c = s.charAt(i);
	        			if (i == s.length()-1 && contains(separators, c)){
	        				lines.append(' ');
	        				lines.append(c);
	        				lines.append('\n');
	        				EOL = true;
	        			}else if (contains(inlinepunc, c)){
		        			lines.append(' ');
		        			lines.append(c);
		        			lines.append(' ');
	        			}else if (('A' <= c && c <= 'Z') || ('a' <= c && c <= 'z') || contains(keptChars, c)){
		        			lines.append(Character.toLowerCase(c));
	        			}
	        		}
	        		if (!EOL) lines.append(' ');
        		}
        	}
        	output.write(lines.toString());
	    }



        output.flush();
    }
    public static class InputManager{
        public StringTokenizer tokens = new StringTokenizer("");
        public BufferedReader input;

        public InputManager(BufferedReader input){
            this.input = input;
        }

        private void updateLine() throws IOException{
            while (!tokens.hasMoreTokens()){
                String line = input.readLine();
                while (line == null){
                    tokens = null;
                    return;
                }
                tokens = new StringTokenizer(line);
            }
        }

        public boolean hasNext() throws IOException{
            this.updateLine();
            return tokens != null;
        }

        public String next() throws IOException{ //get next string
            this.updateLine();
            return tokens.nextToken();
        }

        public int nextInt() throws IOException{ //get next int
            this.updateLine();
            return Integer.parseInt(tokens.nextToken());
        }

        public char nextChar() throws IOException{ //get next int
            this.updateLine();
            return tokens.nextToken().charAt(0);
        }

        public String nextLine() throws IOException{ //get all remaining tokens in line
            this.updateLine();
            StringBuilder sb = new StringBuilder();
            sb.append(tokens.nextToken());
            while(tokens.hasMoreTokens()){
                sb.append(" ").append(tokens.nextToken());
            }
            return sb.toString();
        }
    }
}
